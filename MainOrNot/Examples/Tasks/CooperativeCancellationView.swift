//
//  CooperativeCancellationView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate cooperative cancellation with Task.isCancelled
//  and Task.checkCancellation().
//

import SwiftUI

struct CooperativeCancellationView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.Cancellation.title
    
    private let objective = String(localized: "example.cancellation.objective")
    
    private let code = #"""
let longTask = Task {
    while !Task.isCancelled {
        print("⏱️ working…")
        try? await Task.sleep(for: .milliseconds(500))
        Task.checkCancellation()
    }
    print("🚫 cancelled")
}

try? await Task.sleep(for: .seconds(2))
longTask.cancel()
"""#
    
    private let validationPoints = [
        String(localized: "cancellation.validation.1"),
        String(localized: "cancellation.validation.2"),
        String(localized: "cancellation.validation.3")
    ]
    
    private let flagsImpact = String(localized: "cancellation.flags")
    
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
        
        await CancellationExample().demonstrateCancellation(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate cooperative cancellation
extension CooperativeCancellationView {
    struct CancellationExample {
        func demonstrateCancellation(log: @escaping LogCallback) async {
            log("🚀 Starting a long task...", .info)
            
            let longTask = Task {
                var iteration = 0
                while !Task.isCancelled {
                    iteration += 1
                    log("⏱️ working… (iteration \(iteration))", .output)
                    
                    do {
                        try await Task.sleep(for: .milliseconds(500))
                        try Task.checkCancellation()
                    } catch {
                        log("🚫 cancelled (via checkCancellation)", .error)
                        break
                    }
                }
                
                if Task.isCancelled {
                    log("🚫 cancelled (via isCancelled)", .error)
                }
            }
            
            log("⏳ Wait 2 seconds before cancellation...", .info)
            try? await Task.sleep(for: .seconds(2))
            
            log("❌ Calling longTask.cancel()", .info)
            longTask.cancel()
            
            // Wait a bit to see the result
            try? await Task.sleep(for: .milliseconds(600))
            
            log("✅ Demonstration completed", .success)
        }
    }
}

#Preview {
    NavigationStack { CooperativeCancellationView() }
}
