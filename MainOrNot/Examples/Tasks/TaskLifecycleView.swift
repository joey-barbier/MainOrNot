//
//  TaskLifecycleView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate Task lifecycle management when the user
//  leaves the view, with direct View vs ViewModel/Interactor patterns.
//

import SwiftUI

struct TaskLifecycleView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.Lifecycle.title
    
    private let objective = String(localized: "example.lifecycle.objective")
    
    private let code = #"""
// ❌ PROBLEM: Task continues after navigation back
Button("Fetch Data") {
    Task {
        let data = await apiCall() // Continues even if view destroyed!
        updateUI(data)
    }
}

// ✅ SOLUTION 1: Direct view
@State private var currentTask: Task<Void, Never>?

Button("Fetch Data") {
    currentTask = Task {
        let data = await apiCall()
        await MainActor.run { updateUI(data) }
    }
}
.onDisappear { currentTask?.cancel() }

// ✅ SOLUTION 2: ViewModel pattern
class ViewModel: ObservableObject {
    private var tasks: Set<Task<Void, Never>> = []
    
    func cleanup() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }
}
"""#
    
    private let validationPoints = [
        String(localized: "lifecycle.validation.1"),
        String(localized: "lifecycle.validation.2"),
        String(localized: "lifecycle.validation.3"),
        String(localized: "lifecycle.validation.4"),
        String(localized: "lifecycle.validation.5"),
        String(localized: "lifecycle.validation.6")
    ]
    
    private let flagsImpact = String(localized: "lifecycle.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact,
            productionNotes: String(localized: "lifecycle.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        await TaskLifecycleExample().demonstrateLifecycle(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate Task lifecycle
extension TaskLifecycleView {
    struct TaskLifecycleExample {
        func demonstrateLifecycle(log: @escaping LogCallback) async {
            log("🚀 Task Lifecycle Demonstration", .info)
            log("", .info)
            
            // Problem simulation
            log("❌ PROBLEM: Unmanaged Task", .info)
            await demonstrateProblem(log: log)
            
            log("", .info)
            
            // Solution 1: Direct view
            log("✅ SOLUTION 1: Direct view with cancellation", .info)
            await demonstrateDirectViewSolution(log: log)
            
            log("", .info)
            
            // Solution 2: ViewModel pattern
            log("✅ SOLUTION 2: ViewModel pattern", .info)
            await demonstrateViewModelSolution(log: log)
            
            log("", .info)
            log("🎯 Demonstration completed", .success)
        }
        
        private func demonstrateProblem(log: @escaping LogCallback) async {
            log("🔄 Starting long task (5s)...", .output)
            log("👆 In production: user goes 'back' during call", .output)
            log("⚠️ Result: Task continues and may crash (view destroyed)", .output)
            
            // Short simulation for example
            try? await Task.sleep(for: .milliseconds(500))
            log("💥 Task finishes but view no longer exists!", .error)
        }
        
        private func demonstrateDirectViewSolution(log: @escaping LogCallback) async {
            log("📦 Storing Task in @State", .output)
            
            let task = Task {
                log("🔄 API call in progress...", .output)
                try? await Task.sleep(for: .milliseconds(800))
                
                if Task.isCancelled {
                    log("🚫 Task cancelled properly", .success)
                    return
                }
                
                await MainActor.run {
                    log("✅ Data received and UI updated", .success)
                }
            }
            
            // Cancellation simulation after 400ms (like a quick back)
            try? await Task.sleep(for: .milliseconds(400))
            log("🚪 User goes 'back' → .onDisappear", .info)
            task.cancel()
            
            try? await Task.sleep(for: .milliseconds(500))
        }
        
        private func demonstrateViewModelSolution(log: @escaping LogCallback) async {
            let viewModel = MockViewModel()
            
            log("🏗️ ViewModel starts multiple tasks", .output)
            await viewModel.startMultipleTasks(log: log)
            
            try? await Task.sleep(for: .milliseconds(600))
            
            log("🚪 Navigation back → ViewModel.cleanup()", .info)
            viewModel.cleanup()
            
            try? await Task.sleep(for: .milliseconds(400))
            log("🧹 All ViewModel tasks cancelled", .success)
        }
    }
    
    // Mock ViewModel for demonstration
    class MockViewModel {
        private var tasks: Set<Task<Void, Never>> = []
        
        func startMultipleTasks(log: @escaping LogCallback) async {
            let task1 = Task {
                log("🔄 Task 1: Fetch user profile", .output)
                try? await Task.sleep(for: .seconds(2))
                if !Task.isCancelled {
                    log("✅ User profile loaded", .output)
                }
            }
            
            let task2 = Task {
                log("🔄 Task 2: Fetch notifications", .output)
                try? await Task.sleep(for: .seconds(3))
                if !Task.isCancelled {
                    log("✅ Notifications loaded", .output)
                }
            }
            
            tasks.insert(task1)
            tasks.insert(task2)
        }
        
        func cleanup() {
            tasks.forEach { $0.cancel() }
            tasks.removeAll()
        }
        
//        /*isolated*/ deinit {
//            cleanup() // Additional safety
//        }
    }
}

#Preview {
    NavigationStack { TaskLifecycleView() }
}
