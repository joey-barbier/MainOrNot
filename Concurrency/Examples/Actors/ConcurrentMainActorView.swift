//
//  ConcurrentMainActorView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate the @concurrent attribute which forces a function
//  to execute in background, exiting from MainActor.
//

import SwiftUI

struct ConcurrentMainActorView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.Concurrent.title
    
    private let objective = String(localized: "example.concurrent.objective")
    
    private let code = #"""
@concurrent func heavy() async -> Int {
    (1...50_000_000).reduce(0, +)
}

print("Thread before =", Thread.isMainThread)
let sum = await heavy()
print("Thread after =", Thread.isMainThread, "– sum =", sum)
"""#
    
    private let validationPoints = [
        String(localized: "concurrent.validation.1"),
        String(localized: "concurrent.validation.2"),
        String(localized: "concurrent.validation.3"),
        String(localized: "concurrent.validation.4")
    ]
    
    private let flagsImpact = String(localized: "concurrent.flags")
    
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
        await ConcurrentExample().demonstrateConcurrent(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate @concurrent
extension ConcurrentMainActorView {
    struct ConcurrentExample {
        func demonstrateConcurrent(log: @escaping LogCallback) async {
            @concurrent func heavyCalculation() async -> Int {
                log("Intensive calculation in progress...", .output)
                
                // Intensive calculation to demonstrate offloading
                let result = (1...50_000_000).reduce(0, +)
                
                log("Calculation completed: \(result)", .output)
                return result
            }
            
            log("Thread before", .output)
            
            log("⚡ Starting @concurrent calculation...", .info)
            let sum = await heavyCalculation()
            
            log("Thread after – sum = \(sum)", .output)
        }
    }
}

#Preview {
    NavigationStack { ConcurrentMainActorView() }
}
