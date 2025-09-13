//
//  TaskGroupParallelView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate TaskGroup for parallel execution with type inference
//  and show the impact of Swift 6 flags on isolation.
//

import SwiftUI

struct TaskGroupParallelView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.TaskGroup.title
    
    private let objective = String(localized: "example.taskgroup.objective")
    
    private let code = #"""
// Swift 6: automatic type inference!
await withTaskGroup { group in
    group.addTask { await fetchUser() }
    group.addTask { await fetchPosts() }
    group.addTask { await fetchComments() }
    
    for await result in group {
        print("Result:", result)
    }
}

// Comparison with async let (for fixed number)
async let user = fetchUser()
async let posts = fetchPosts()
let results = await (user, posts)
"""#
    
    private let validationPoints = [
        String(localized: "taskgroup.validation.1"),
        String(localized: "taskgroup.validation.2"),
        String(localized: "taskgroup.validation.3"),
        String(localized: "taskgroup.validation.4"),
        String(localized: "taskgroup.validation.5")
    ]
    
    private let flagsImpact = String(localized: "taskgroup.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact,
            productionNotes: String(localized: "taskgroup.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        await TaskGroupExample().demonstrateTaskGroup(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate TaskGroup
extension TaskGroupParallelView {
    struct TaskGroupExample {
        func demonstrateTaskGroup(log: @escaping LogCallback) async {
            log("🚀 TaskGroup vs async let demonstration", .info)
            log("", .info)
            
            // Example 1: TaskGroup for dynamic number
            log("📦 Test 1: TaskGroup (dynamic number)", .info)
            
            let tasks = ["Task A", "Task B", "Task C", "Task D"]
            
            await withTaskGroup(of: String.self) { group in
                for (index, taskName) in tasks.enumerated() {
                    group.addTask {
                        await simulateWork(name: taskName, duration: 0.5 + Double(index) * 0.2, log: log)
                    }
                }
                
                log("⏳ Waiting for results...", .info)
                for await result in group {
                    log("✅ Completed: \(result)", .success)
                }
            }
            
            log("", .info)
            
            // Example 2: async let for fixed number
            log("📦 Test 2: async let (fixed number)", .info)
            
            async let taskX = simulateWork(name: "Task X", duration: 0.3, log: log)
            async let taskY = simulateWork(name: "Task Y", duration: 0.4, log: log)
            
            let results = await (taskX, taskY)
            log("✅ Results: \(results.0) + \(results.1)", .success)
            
            log("", .info)
            log("🎯 Comparison completed", .success)
        }
        
        private func simulateWork(name: String, duration: Double, log: LogCallback) async -> String {
            log("🔄 Start: \(name)", .output)
            
            // Random time to demonstrate that finish order is not guaranteed
            let randomDuration = duration + Double.random(in: -0.2...0.3)
            try? await Task.sleep(for: .milliseconds(Int(randomDuration * 1000)))
            
            let result = "\(name) (duration: \(String(format: "%.1f", randomDuration))s)"
            return result
        }
    }
}

#Preview {
    NavigationStack { TaskGroupParallelView() }
}
