//
//  MainActorIsolationView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate the impact of Swift 6 flags (AC and DAI) on isolation
//  by testing two execution paths: direct and via Task.detached.
//

import SwiftUI

struct MainActorIsolationView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.MainActor.title
    
    private let objective = String(localized: "example.mainactor.objective")
    
    private let code = #"""
func fetch() async {
    print("fetch → Thread.isMainThread =", Thread.isMainThread)
    
    // Test with Task.detached to see flag impact
    await Task.detached {
        await parse()
    }.value
}

func parse() async {
    print("parse → Thread.isMainThread =", Thread.isMainThread)
}

await fetch()

// AC also enables Infer Isolated Conformances (IIC). Useful if you're working with DAI set to nonisolated (not a recommended setting though)

// With IIC false and DAI set to nonisolated

@MainActor
struct IsolatedStruct: Equatable { /* Conformance of 'IsolatedStruct' to protocol 'Equatable' crosses into main actor-isolated code and can cause data races */
    let id: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// With IIC true and DAI set to nonisolated, or DAI set to MainActor, it will compile.

"""#
    
    private let validationPoints = [
        String(localized: "mainactor.validation.1"),
        String(localized: "mainactor.validation.2"),
        String(localized: "mainactor.validation.3"),
        String(localized: "mainactor.validation.4"),
        String(localized: "mainactor.validation.5"),
        String(localized: "mainactor.validation.6")
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
                    acFalseNonisolated: "false / false",
                    acTrueNonisolated: "true / false",
                    acFalseMainActor: "true / true",
                    acTrueMainActor: "true / true",
                    description: "fetch / parse",
                    notes: [
                        "true/false = Thread.isMainThread (on MainActor or not)",
                        "AC (Approachable Concurrency) = GlobalActorIsolatedTypesUsability",
                        "DAI (Default Actor Isolation) = MainActor or nonisolated",
                        "Task.detached never inherits context"
                    ]
                )
            }
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        // Display current flags
        addLog("🏳️ Current configuration:", .info)
        addLog("• Approachable Concurrency (AC) = YES", .info)
        addLog("• Default Actor Isolation (DAI) = MainActor", .info)
        addLog("", .info)

        await SwiftConcurrencyExample().fetch(log: addLog)
        
        addLog("", .info)
        addLog("📊 Observed result:", .success)
        addLog("→ See thread column to verify isolation", .success)
    }
}

// MARK: - Separate struct to avoid MainActor inheritance and actually test flag impact
extension MainActorIsolationView {
    struct SwiftConcurrencyExample {
        func fetch(log: @escaping LogCallback) async {
            log("fetch → execution", .output)
            
            // Test with Task.detached to see flag impact
            // We use await and .value to wait for execution to not display
            // "execution finished" while the task is not finished
            await Task.detached {
                await parse(log: log)
            }.value
        }
        
        func parse(log: LogCallback) async {
            log("parse(Task.detached) → execution", .output)
        }
    }
}

#Preview {
    NavigationStack { MainActorIsolationView() }
}
