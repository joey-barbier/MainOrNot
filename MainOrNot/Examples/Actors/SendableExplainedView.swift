//
//  SendableExplainedView.swift
//  ConcurrencyDemo
//
//  Objective: Simply understand when Sendable is needed
//

import SwiftUI

struct SendableExplainedView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = String(localized: "example.sendable.title")
    
    private let objective = String(localized: "example.sendable.objective")
    
    private let code = #"""
// ✅ NO SENDABLE NEEDED: Same context
@MainActor
class ViewModel {
    let service = DataService()
    
    func processData() async {
        // Both on MainActor = OK
        let data = NonSendableData()
        service.update(data)
    }
}

@MainActor  
class DataService {
    func update(_ data: NonSendableData) {
        // Can use non-Sendable: same isolation
    }
}

// ❌ SENDABLE NEEDED: Cross boundary
@MainActor
class UIViewModel {
    let worker = BackgroundWorker()
    
    func sendData() async {
        let data = NonSendableData()
        // ❌ ERROR: Cannot pass non-Sendable across
        // await worker.process(data)
        
        let user = User(name: "Alice")  
        // ✅ OK: User is Sendable (struct)
        await worker.process(user)
    }
}

actor BackgroundWorker {
    func process(_ user: User) {
        // Requires Sendable parameter
    }
}

// Types
struct User { let name: String }      // ✅ Automatically Sendable
class NonSendableData { var text = "" } // ❌ Not Sendable
"""#
    
    private let validationPoints = [
        String(localized: "sendable.validation.1"),
        String(localized: "sendable.validation.2"),
        String(localized: "sendable.validation.3"),
        String(localized: "sendable.validation.4"),
        String(localized: "sendable.validation.5")
    ]
    
    private let flagsImpact = String(localized: "sendable.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact,
            productionNotes: String(localized: "sendable.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        await SendableDemo().demonstrate(log: addLog)
    }
}

// MARK: - Simple demo
extension SendableExplainedView {
    struct SendableDemo {
        func demonstrate(log: @escaping LogCallback) async {
            log("🎯 When do you need Sendable?", .info)
            log("", .info)
            
            // Case 1: Same isolation = NO Sendable needed
            log("✅ CASE 1: Same isolation context", .success)
            await demonstrateSameIsolation(log: log)
            
            log("", .info)
            log("", .info)
            
            // Case 2: Cross isolation = Sendable REQUIRED
            log("❌ CASE 2: Cross isolation boundary", .error)
            await demonstrateCrossIsolation(log: log)
            
            log("", .info)
            log("🔍 Simple rule:", .info)
            log("• Same actor/thread = Any type OK", .success)
            log("• Different actor/thread = Only Sendable types", .error)
        }
        
        @MainActor
        func demonstrateSameIsolation(log: @escaping LogCallback) async {
            log("📍 Both on MainActor:", .output)
            
            // Non-Sendable class
            class MyData {
                var value = 42
            }
            
            let data = MyData()
            let service = MainService()
            
            // ✅ OK: Both on MainActor
            service.process(data)
            log("✅ Non-Sendable passed within MainActor", .success)
        }
        
        func demonstrateCrossIsolation(log: @escaping LogCallback) async {
            log("📍 From task to actor:", .output)
            let point = Calculator.Point(x: 10, y: 20)
            let calculator = Calculator()
            
            // ✅ OK: Point is Sendable (struct)
            let result = await calculator.compute(point)
            log("✅ Sendable struct crossed boundary: \(result)", .success)
            
            // If we tried with non-Sendable:
            log("❌ Non-Sendable class would cause compile error", .error)
        }
    }
    
    // Helper types
    @MainActor
    class MainService {
        func process(_ data: AnyObject) {
            // Can receive any type when on same actor
        }
    }
    
    actor Calculator {
        func compute(_ point: Point) -> String {
            "Computed: (\(point.x), \(point.y))"
        }
        
        struct Point {
            let x: Int
            let y: Int
        }
    }
}

#Preview {
    NavigationStack { SendableExplainedView() }
}
