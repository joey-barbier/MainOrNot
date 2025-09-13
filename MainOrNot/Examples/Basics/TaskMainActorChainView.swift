//
//  TaskMainActorChainView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate the chain Task {} -> @MainActor method -> async method
//  and how context switches work in this pattern.
//

import SwiftUI

struct TaskMainActorChainView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = String(localized: "example.taskchain.title")
    
    private let objective = String(localized: "example.taskchain.objective")
    
    private let code = #"""
// 1. Struct with @MainActor method
struct UIManager {
    @MainActor
    func updateUI() async {
        print("✅ updateUI on MainActor: \(Thread.isMainThread)")
        
        // Call async method
        let data = await DataService().fetchData()
        print("📱 Back in updateUI: \(Thread.isMainThread)")
        print("📄 Data: \(data)")
    }
}

// 2. Simple async struct
struct DataService {
    func fetchData() async -> String {
        print("🔄 fetchData on background: \(!Thread.isMainThread)")
        try? await Task.sleep(nanoseconds: 100_000_000)
        return "Sample data"
    }
}

// Usage: Task -> @MainActor -> async
Task {
    print("🚀 Task starts: \(!Thread.isMainThread)")
    await UIManager().updateUI()
    print("✨ Task ends: \(!Thread.isMainThread)")
}
"""#
    
    private let validationPoints = [
        String(localized: "taskchain.validation.1"),
        String(localized: "taskchain.validation.2"),
        String(localized: "taskchain.validation.3"),
        String(localized: "taskchain.validation.4"),
        String(localized: "taskchain.validation.5")
    ]
    
    private let flagsImpact = String(localized: "taskchain.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact,
            productionNotes: String(localized: "taskchain.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    private func runExample(addLog: @escaping LogCallback) async throws {
        await TaskChainExample().demonstrateTaskChain(log: addLog)
    }
}

// MARK: - Example implementation
extension TaskMainActorChainView {
    struct TaskChainExample {
        func demonstrateTaskChain(log: @escaping LogCallback) async {
            log("🎯 Demonstrating Task -> @MainActor -> async chain", .info)
            
            log("🚀 Task starts...", .info)
            log("Task thread: \(currentThreadStatus())", .output)
            
            log("📞 Calling @MainActor method...", .info)
            await UIManager().updateUI(log: log)
            
            log("✨ Task completed on: \(currentThreadStatus())", .success)
        }
    }
    
    // 1. Struct with @MainActor method
    struct UIManager {
        @MainActor
        func updateUI(log: @escaping LogCallback) async {
            log("✅ start updateUI(@MainActor) on: \(currentThreadStatus())", .success)
            
            log("🔄 Calling async fetchData()...", .output)
            let data = await DataService().fetchData(log: log)
            
            log("📱 Back in updateUI on: \(currentThreadStatus())", .success)
            log("📄 Data: \(data)", .output)
        }
    }
    
    // 2. Simple async struct
    struct DataService {
        func fetchData(log: @escaping LogCallback) async -> String {
            log("🔄 fetchData on: \(currentThreadStatus())", .output)
            
            // Simulate network call
            try? await Task.sleep(nanoseconds: 200_000_000)
            
            return "Sample data"
        }
    }
}

#Preview {
    NavigationStack { TaskMainActorChainView() }
}
