//
//  TaskVsDetachedView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate the difference between Task {} which inherits from the actor
//  and Task.detached {} which starts from a neutral context.
//

import SwiftUI

struct TaskVsDetachedView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.TaskVs.title
    
    private let objective = String(localized: "example.taskvs.objective")
    
    private let code = #"""
// Test simple : Task vs Task.detached
Task(priority: .medium) {
    print("in Task        – isMainThread =", Thread.isMainThread)
}

Task.detached {
    print("in detached    – isMainThread =", Thread.isMainThread)
}

// Swift 6.2 trap: Task.detached + @MainActor function
struct DataProcessor {  // Without annotation = @MainActor by default
    func process() { print("process → \(Thread.isMainThread)") }
}

Task.detached {
    let processor = DataProcessor()
    await processor.process()  // ⚠️ May return to MainThread!
}
"""#
    
    private let validationPoints = [
        String(localized: "taskvs.validation.1"),
        String(localized: "taskvs.validation.2"),
        String(localized: "taskvs.validation.3"),
        String(localized: "taskvs.validation.4"),
        String(localized: "taskvs.validation.5")
    ]
    
    private let flagsImpact = String(localized: "detached.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact,
            productionNotes: String(localized: "taskdetached.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        addLog("🧵 Current context", .info)
        
        await TaskDetachedExample().demonstrateTaskBehavior(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate Task vs Task.detached with Swift 6.2 traps
extension TaskVsDetachedView {
    struct TaskDetachedExample {
        func demonstrateTaskBehavior(log: @escaping LogCallback) async {
            // Test 1: Basic Task vs Task.detached
            log("", .info)
            log("🧪 Test 1: Basic Task vs Task.detached", .info)
            
            log("📦 Creating a normal Task...", .info)
            Task(priority: .medium) {
                log("in Task        – execution", .output)
            }
            
            try? await Task.sleep(nanoseconds: 100_000_000)
            
            log("📦 Creating a Task.detached...", .info)
            Task.detached {
                log("in detached    – execution", .output)
            }
            
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            // Test 2: The trap with struct @MainActor
            log("", .info)
            log("🧪 Test 2: TRAP - Task.detached + struct @MainActor", .info)
            
            Task.detached {
                log("detached start  – execution", .output)
                
                // ⚠️ TRAP: struct without annotation = @MainActor in Swift 6.2
                let processor = DataProcessorMainActor()
                await processor.process(log: log)
                
                log("detached end    – execution", .output)
            }
            
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            // Test 3: Solution with nonisolated
            log("", .info)
            log("🧪 Test 3: SOLUTION - Task.detached + struct nonisolated", .info)
            
            Task.detached {
                log("detached start  – execution", .output)
                
                // ✅ Solution: nonisolated struct stays in background
                let processor = DataProcessorNonisolated()
                processor.process(log: log)
                
                log("detached end    – execution", .output)
            }
            
            try? await Task.sleep(nanoseconds: 200_000_000)
        }
    }
    
    // Struct without annotation = @MainActor by default in Swift 6.2
    struct DataProcessorMainActor {
        func process(log: LogCallback) async {
            log("process @MainActor – execution", .output)
        }
    }
    
    // Explicitly nonisolated struct
    nonisolated struct DataProcessorNonisolated {
        func process(log: LogCallback) {
            log("process nonisolated – execution", .output)
        }
    }
}

#Preview {
    NavigationStack { TaskVsDetachedView() }
}
