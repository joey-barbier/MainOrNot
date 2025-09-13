//
//  NonisolatedPropertyView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate that a `nonisolated` property allows
//  synchronous access without `await` from any context.
//

import SwiftUI

struct NonisolatedPropertyView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = L10n.Example.Nonisolated.title
    
    private let objective = String(localized: "example.nonisolated.objective")
    
    private let code = #"""
actor UserService {
    private var userData: [String: Any] = [:]
    
    // ✅ nonisolated = synchronous access, no isolation
    nonisolated let serviceID = UUID()
    nonisolated var serviceName: String { "UserService" }
    
    // ⚠️ Normal property = isolated, await required
    var userCount: Int { userData.count }
}

let service = UserService()
print(service.serviceName)  // ✅ No await needed
print(service.serviceID)    // ✅ Direct access

let count = await service.userCount  // ⚠️ await required
"""#
    
    private let validationPoints = [
        String(localized: "nonisolated.validation.1"),
        String(localized: "nonisolated.validation.2"),
        String(localized: "nonisolated.validation.3"),
        String(localized: "nonisolated.validation.4"),
        String(localized: "nonisolated.validation.5")
    ]
    
    private let flagsImpact = String(localized: "nonisolated.flags")
    
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
        await NonisolatedExample().demonstrateNonisolated(log: addLog)
    }
}

// MARK: - Separate struct to demonstrate nonisolated vs @concurrent
extension NonisolatedPropertyView {
    struct NonisolatedExample {
        func demonstrateNonisolated(log: @escaping LogCallback) async {
            // Locally defined actor
            actor UserService {
                private var userData: [String: Any] = [:]
                
                // ✅ nonisolated = synchronous access without isolation
                nonisolated let serviceID = UUID()
                nonisolated var serviceName: String { "UserService" }
                
                // ⚠️ Normal property = isolated access with await
                var userCount: Int {
                    return userData.count
                }
                
                func addUser(_ name: String) {
                    userData[name] = ["created": Date()]
                }
            }
            
            let service = UserService()
            
            // Test nonisolated (direct access)
            let serviceName = service.serviceName  // No await!
            let serviceID = service.serviceID      // No await!
            log("Service: \(serviceName)", .output)
            log("ID: \(serviceID)", .output)
            
            // Test normal property (isolation)
            let userCount = await service.userCount  // await required
            log("Users: \(userCount)", .output)
            
            // Add a user to show the difference
            await service.addUser("Alice")
            let newCount = await service.userCount
            log("Users after addition: \(newCount)", .output)
        }
    }
}

#Preview {
    NavigationStack { NonisolatedPropertyView() }
}
