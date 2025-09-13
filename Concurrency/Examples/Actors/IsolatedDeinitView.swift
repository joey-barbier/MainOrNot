//
//  IsolatedDeinitView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate `isolated deinit` which allows safe cleanup
//  of actor resources without data race risk.
//

import SwiftUI

struct IsolatedDeinitView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.Deinit.title
    
    private let objective = String(localized: "example.deinit.objective")
    
    private let code = #"""
actor Session {
    let worker = Task { /* loop */ }
    
    isolated deinit {
        worker.cancel()
    }
}
"""#
    
    private let validationPoints = [
        String(localized: "deinit.validation.1"),
        String(localized: "deinit.validation.2"),
        String(localized: "deinit.validation.3")
    ]
    
    private let flagsImpact = String(localized: "deinit.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        await IsolatedDeinitExample().demonstrateIsolatedDeinit(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate isolated deinit
extension IsolatedDeinitView {
    struct IsolatedDeinitExample {
        func demonstrateIsolatedDeinit(log: @escaping LogCallback) async {
            // Locally defined actor
            actor Session {
                let sessionId: String
                let worker: Task<Void, Never>
                
                let logCallback: LogCallback
                
                init(sessionId: String, logCallback: @escaping LogCallback) {
                    self.sessionId = sessionId
                    self.logCallback = logCallback
                    self.worker = Task {
                        var counter = 0
                        while !Task.isCancelled {
                            counter += 1
                            try? await Task.sleep(nanoseconds: 200_000_000)
                            if counter > 10 { break }
                        }
                    }
                    logCallback("📱 Session \(sessionId) created", .info)
                }
                
                // ✅ isolated deinit guarantees thread-safe cleanup
                isolated deinit {
                    logCallback("🧹 isolated deinit: cleanup session \(sessionId)", .success)
                    worker.cancel()
                    logCallback("❌ Worker task cancelled properly", .success)
                }
                
                func status() -> String {
                    return "Session \(sessionId) - Worker: \(worker.isCancelled ? "cancelled" : "running")"
                }
            }
            
            // Create session in limited scope
            do {
                let session = Session(sessionId: "ABC123", logCallback: log)
                
                log("Status: \(await session.status())", .output)
                
                try? await Task.sleep(nanoseconds: 500_000_000)
                log("Status: \(await session.status())", .output)
                
                log("🎯 Session will be destroyed...", .info)
            }
            
            try? await Task.sleep(nanoseconds: 200_000_000)
            log("✅ Cleanup completed", .success)
        }
    }
}

#Preview {
    NavigationStack { IsolatedDeinitView() }
}
