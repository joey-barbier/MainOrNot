//
//  ActorDataRaceView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate how an actor eliminates data races
//  by comparing unprotected vs protected concurrent access.
//

import SwiftUI

struct ActorDataRaceView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.DataRace.title
    
    private let objective = String(localized: "example.datarace.objective")
    
    private let code = #"""
actor Counter { 
    var value = 0
    func inc() { value += 1 } 
}

func raceWithoutActor() async -> Int {
    var v = 0
    await withTaskGroup(of: Void.self) { g in
        for _ in 0..<10_000 { 
            g.addTask { v += 1 } 
        }
    }
    return v
}

func safeWithActor() async -> Int {
    let c = Counter()
    await withTaskGroup(of: Void.self) { g in
        for _ in 0..<10_000 { 
            g.addTask { await c.inc() } 
        }
    }
    return await c.value
}
"""#
    
    private let validationPoints = [
        String(localized: "datarace.validation.1"),
        String(localized: "datarace.validation.2"),
        String(localized: "datarace.validation.3")
    ]
    
    private let flagsImpact = String(localized: "datarace.flags")
    
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
        await DataRaceExample().demonstrateDataRace(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate data race protection
extension ActorDataRaceView {
    struct DataRaceExample {
        func demonstrateDataRace(log: @escaping LogCallback) async {
            log("🚀 Actor vs Data Race Demonstration", .info)
            log("", .info)
            
            // Test 1: Data race simulation (without real data race)
            log("⚠️ Test 1: Without actor (simulated data race)", .info)
            let unsafeResult = Int.random(in: 8000...9500)
            log("Result without protection: \(unsafeResult) ≠ 10,000", .error)
            log("💥 Unpredictable value due to concurrent access", .error)
            
            log("", .info)
            
            // Test 2: With actor
            log("✅ Test 2: With actor (guaranteed protection)", .info)
            let safeResult = await demonstrateSafeActor(log: log)
            
            if safeResult == 10_000 {
                log("Result with actor: \(safeResult) = 10,000 ✅", .success)
                log("🎯 Actor eliminated the data race!", .success)
            } else {
                log("Result with actor: \(safeResult) ≠ 10,000 ❌", .error)
            }
            
            log("", .info)
            log("🔒 Conclusion: Actors automatically serialize access", .success)
        }
        
        private func demonstrateSafeActor(log: @escaping LogCallback) async -> Int {
            log("🔄 Creating a Counter actor", .output)
            
            // Locally defined actor to avoid captures
            actor Counter {
                var value = 0
                func increment() {
                    value += 1
                }
                func getValue() -> Int {
                    return value
                }
            }
            
            let counter = Counter()
            log("🚀 Starting 10,000 concurrent increments", .output)
            
            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<10_000 {
                    group.addTask {
                        await counter.increment()  // ✅ Serialized access
                    }
                }
            }
            
            log("✅ All tasks completed", .output)
            return await counter.getValue()
        }
    }
}

#Preview {
    NavigationStack { ActorDataRaceView() }
}
