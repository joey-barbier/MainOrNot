//
//  AsyncLetParallelView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate that `async let` launches multiple structured
//  operations in parallel and measure the performance gain.
//

import SwiftUI

struct AsyncLetParallelView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.AsyncLet.title
    
    private let objective = String(localized: "example.asynclet.objective")
    
    private let code = #"""
let clock = ContinuousClock()
let start = clock.now

async let a = fetchImage("1.png")
async let b = fetchImage("2.png")

let images = try await [a, b]
print("Δt ≈", start.duration(to: clock.now).components.seconds, "s")
"""#
    
    private let validationPoints = [
        String(localized: "asynclet.validation.1"),
        String(localized: "asynclet.validation.2"),
        String(localized: "asynclet.validation.3"),
        String(localized: "asynclet.validation.4"),
        String(localized: "asynclet.validation.5")
    ]
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsTableBuilder: {
                Swift6FlagsTableView(
                    acFalseNonisolated: "Parallel, inherited nonisolated context",
                    acTrueNonisolated: "Parallel, inherited nonisolated context", 
                    acFalseMainActor: "Parallel, inherited MainActor context",
                    acTrueMainActor: "Parallel, inherited MainActor context",
                    description: "async let Impact",
                    notes: [
                        "async let always remains parallel regardless of flag combination",
                        "Child tasks inherit the parent's context",
                        "AC and DAI don't affect parallelism but isolation context"
                    ]
                )
            },
            productionNotes: String(localized: "asynclet.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        addLog("🚀 Launching in parallel with async let", .info)
        
        await AsyncParallelExample().runParallelDownloads(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate async let without MainActor inheritance
extension AsyncLetParallelView {
    struct AsyncParallelExample {
        func runParallelDownloads(log: @escaping LogCallback) async {
            let clock = ContinuousClock()
            let startTime = clock.now
            
            async let a = fetchImage("1.png", log: log)
            async let b = fetchImage("2.png", log: log)
            
            log("⏳ Waiting for results...", .info)
            
            do {
                let images = try await [a, b]
                let duration = startTime.duration(to: clock.now)

                log("📊 Results:", .output)
                log("   - \(images[0])", .output)
                log("   - \(images[1])", .output)
                let totalSeconds = Double(duration.components.seconds) + Double(duration.components.attoseconds) / 1_000_000_000_000_000_000
                log("⏱️ Δt ≈ \(String(format: "%.1f", totalSeconds))s", .success)
            } catch {
                log("❌ Error: \(error)", .error)
            }
        }
        
        private func fetchImage(_ name: String, log: LogCallback) async throws -> String {
            let delay = Double.random(in: 1.0...2.0)
            log("📥 Starting download \(name) (≈\(String(format: "%.1f", delay))s)", .info)
            
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            
            log("✅ Download finished \(name)", .success)
            return "Image-\(name)"
        }
    }
}

#Preview {
    NavigationStack { AsyncLetParallelView() }
}
