//
//  ThreadHoppingOptimizationView.swift
//  ConcurrencyDemo
//
//  Objective: demonstrate best practices to avoid thread hopping
//  and stay on the same thread throughout a chain of operations.
//

import SwiftUI

struct ThreadHoppingOptimizationView: View {
    
    // MARK: – Metadata for ExampleView -------------------------------
    
    private let title = String(localized: "example.threadhopping.title")
    
    private let objective = String(localized: "example.threadhopping.objective")
    
    private let code = #"""
// ❌ BAD: Each call goes back to MainActor
@MainActor
class BadViewModel {
    private let userUseCase = UserUseCase()
    private let postUseCase = PostUseCase() 
    private let friendUseCase = FriendUseCase()
    
    func loadProfile() async {
        let user = await userUseCase.getUser()       // Main → Background → Main
        let posts = await postUseCase.getPosts()     // Main → Background → Main  
        let friends = await friendUseCase.getFriends() // Main → Background → Main
        updateUI(user, posts, friends)
    }
}

// ✅ PATTERN 1: Actor coordinator (keeps layers separate)
actor ProfileCoordinator {
    private let userUseCase = UserUseCase()
    private let postUseCase = PostUseCase()
    private let friendUseCase = FriendUseCase()
    
    func fetchProfile() async -> ProfileData {
        // All calls stay on actor thread
        let user = await userUseCase.getUser()
        let posts = await postUseCase.getPosts(for: user.id)
        let friends = await friendUseCase.getFriends(for: user.id)
        return ProfileData(user, posts, friends)
    }
}

// ✅ PATTERN 2: @concurrent for background batching
@MainActor
class OptimizedViewModel {
    @concurrent
    private func fetchAllData() async -> ProfileData {
        // Concurrent execution in background
        async let user = userUseCase.getUser()
        async let posts = postUseCase.getPosts()
        async let friends = friendUseCase.getFriends()
        return await ProfileData(user, posts, friends)
    }
    
    func loadProfile() async {
        let profile = await fetchAllData()  // Single switch to background
        updateUI(profile)                   // Back to main
    }
}
"""#
    
    private let validationPoints = [
        String(localized: "threadhopping.validation.1"),
        String(localized: "threadhopping.validation.2"),
        String(localized: "threadhopping.validation.3"),
        String(localized: "threadhopping.validation.4"),
        String(localized: "threadhopping.validation.5")
    ]
    
    private let flagsImpact = String(localized: "threadhopping.flags")
    
    // MARK: – View ---------------------------------------------------------
    
    var body: some View {
        ExampleView(
            title: title,
            objective: objective,
            code: code,
            validationPoints: validationPoints,
            execution: runExample,
            flagsImpact: flagsImpact,
            productionNotes: String(localized: "threadhopping.production")
        )
    }
    
    // MARK: – Example implementation --------------------------------
    
    private func runExample(addLog: @escaping LogCallback) async throws {
        await ThreadHoppingExample().demonstrateThreadOptimization(log: addLog)
    }
}

// MARK: - Example implementation
extension ThreadHoppingOptimizationView {
    struct ThreadHoppingExample {
        func demonstrateThreadOptimization(log: @escaping LogCallback) async {
            log("🎯 Clean Architecture Patterns for Thread Optimization", .info)
            log("", .info)
            
            // Bad example
            log("❌ BAD: Each UseCase call returns to MainActor", .error)
            await demonstrateBadPattern(log: log)
            
            log("", .info)
            log("", .info)
            
            // Pattern 1: Actor coordinator
            log("✅ PATTERN 1: Actor coordinator (keeps layers clean)", .success)
            await demonstrateActorPattern(log: log)
            
            log("", .info)
            log("", .info)
            
            // Pattern 2: @concurrent
            log("✅ PATTERN 2: @concurrent for background batching", .success)
            await demonstrateConcurrentPattern(log: log)
            
            log("", .info)
            log("🔍 Clean Architecture Analysis:", .info)
            log("• Bad: 6 thread switches (VM→UC→VM for each call)", .error)
            log("• Actor Pattern: 2 thread switches, layers preserved", .success)
            log("• @concurrent Pattern: 2 thread switches, async let optimization", .success)
            log("• Both keep clean separation of concerns", .output)
            log("", .info)
            log("💡 Apple Guidelines (WWDC):", .info)
            log("• Background thread changes = OK (system optimized)", .output)
            log("• Main ↔ Background frequent switches = expensive", .error)
            log("• Use actors to reduce main actor contention", .success)
            log("• 'It doesn't matter which background thread a task runs on'", .output)
        }
        
        private func demonstrateBadPattern(log: @escaping LogCallback) async {
            let viewModel = BadPattern.ViewModel(log: log) // <=== Swift 6.2
            // let viewModel = await BadPattern.ViewModel(log: log)
            await viewModel.loadProfile()
        }
        
        private func demonstrateActorPattern(log: @escaping LogCallback) async {
             let viewModel = GoodPattern.ActorPattern.ViewModel(log: log) // <=== Swift 6.2
//            let viewModel = await GoodPattern.ActorPattern.ViewModel(log: log)
            await viewModel.loadProfile()
        }
        
        private func demonstrateConcurrentPattern(log: @escaping LogCallback) async {
            let viewModel = GoodPattern.ConcurrentPattern.ViewModel(log: log) // <=== Swift 6.2
//            let viewModel = await GoodPattern.ConcurrentPattern.ViewModel(log: log)
            await viewModel.loadProfile()
        }
    }
    
    // ❌ BAD PATTERN: No optimization, multiple thread switches
    enum BadPattern {
        @MainActor
        class ViewModel {
            private let userUseCase = UserUseCase()
            private let postUseCase = PostUseCase()
            private let friendUseCase = FriendUseCase()
            private let logCallback: LogCallback
            
            init(log: @escaping LogCallback) {
                self.logCallback = log
            }
            
            func loadProfile() async {
                logCallback("🏃 BadPattern.ViewModel on: \(currentThreadStatus())", .output)
                
                // Each call switches: Main → Background → Main
                let user = await userUseCase.getUser(log: logCallback)
                logCallback("👤 Back to ViewModel: \(currentThreadStatus())", .output)
                
                _ = await postUseCase.getUserPosts(userId: user, log: logCallback)
                logCallback("📝 Back to ViewModel: \(currentThreadStatus())", .output)
                
                _ = await friendUseCase.getFriends(userId: user, log: logCallback)
                logCallback("👥 Back to ViewModel: \(currentThreadStatus())", .output)
            }
        }
        
        // Standard use cases (inherit @MainActor by default - Swift 6.2)
        struct UserUseCase {
            private let repository = Repository()
            
            func getUser(log: LogCallback) async -> String {
                log("    🏗️ BadPattern.UserUseCase on: \(currentThreadStatus())", .output)
                return await repository.fetchUser(log: log)
            }
        }
        
        struct PostUseCase {
            private let apiClient = APIClient()
            
            func getUserPosts(userId: String, log: LogCallback) async -> [String] {
                log("    🏗️ BadPattern.PostUseCase on: \(currentThreadStatus())", .output)
                return await apiClient.fetchPosts(userId: userId, log: log)
            }
        }
        
        struct FriendUseCase {
            private let repository = Repository()
            
            func getFriends(userId: String, log: LogCallback) async -> [String] {
                log("    🏗️ BadPattern.FriendUseCase on: \(currentThreadStatus())", .output)
                return await repository.fetchFriends(userId: userId, log: log)
            }
        }
    }
    
    // ✅ GOOD PATTERN: Optimized with proper isolation annotations
    enum GoodPattern {
        // Pattern 1: Actor coordinator
        enum ActorPattern {
            actor ProfileCoordinator {
                private let userUseCase = UserUseCase()
                private let postUseCase = PostUseCase()
                private let friendUseCase = FriendUseCase()
                
                func fetchProfile(log: @escaping LogCallback) async -> ProfileData {
                    log("🎭 Actor coordinator on: \(currentThreadStatus())", .output)
                    
                    // All use cases stay on same actor thread
                    let user = await userUseCase.getUser(log: log)
                    log("  → User UseCase on same thread", .output)
                    
                    let posts = await postUseCase.getUserPosts(userId: user, log: log)
                    log("  → Post UseCase on same thread", .output)
                    
                    let friends = await friendUseCase.getFriends(userId: user, log: log)
                    log("  → Friend UseCase on same thread", .output)
                    
                    return ProfileData(user: user, posts: posts, friends: friends)
                }
            }
            
            @MainActor
            class ViewModel {
                private let coordinator = ProfileCoordinator()
                private let logCallback: LogCallback
                
                init(log: @escaping LogCallback) {
                    self.logCallback = log
                }
                
                func loadProfile() async {
                    logCallback("🏃 ActorPattern.ViewModel on: \(currentThreadStatus())", .output)
                    
                    // Single departure to actor
                    logCallback("🚀 Calling actor coordinator...", .info)
                    _ = await coordinator.fetchProfile(log: logCallback)
                    
                    // Single return to Main
                    logCallback("📱 Back to ViewModel: \(currentThreadStatus())", .success)
                    logCallback("✅ Profile ready via actor pattern", .success)
                }
            }
            
            // Use cases optimized for actor usage
            nonisolated struct UserUseCase {
                private let repository = Repository()
                
                func getUser(log: LogCallback) async -> String {
                    log("    🏗️ ActorPattern.UserUseCase (nonisolated) on: \(currentThreadStatus())", .output)
                    return await repository.fetchUser(log: log)
                }
            }
            
            nonisolated struct PostUseCase {
                private let apiClient = APIClient()
                
                func getUserPosts(userId: String, log: LogCallback) async -> [String] {
                    log("    🏗️ ActorPattern.PostUseCase (nonisolated) on: \(currentThreadStatus())", .output)
                    return await apiClient.fetchPosts(userId: userId, log: log)
                }
            }
            
            nonisolated struct FriendUseCase {
                private let repository = Repository()
                
                func getFriends(userId: String, log: LogCallback) async -> [String] {
                    log("    🏗️ ActorPattern.FriendUseCase (nonisolated) on: \(currentThreadStatus())", .output)
                    return await repository.fetchFriends(userId: userId, log: log)
                }
            }
        }
        
        // Pattern 2: @concurrent optimization
        enum ConcurrentPattern {
            @MainActor
            class ViewModel {
                private let userUseCase = UserUseCase()
                private let postUseCase = PostUseCase()
                private let friendUseCase = FriendUseCase()
                private let logCallback: LogCallback
                
                init(log: @escaping LogCallback) {
                    self.logCallback = log
                }
                
                @concurrent
                private func fetchAllData(log: @escaping LogCallback) async -> ProfileData {
                    log("🔄 @concurrent method on: \(currentThreadStatus())", .output)
                    
                    // Concurrent execution with async let
                    async let user = userUseCase.getUser(log: log)
                    async let posts = postUseCase.getUserPosts(userId: "user-id", log: log)
                    async let friends = friendUseCase.getFriends(userId: "user-id", log: log)
                    
                    log("  → All async let calls initiated", .output)
                    return await ProfileData(user: user, posts: posts, friends: friends)
                }
                
                func loadProfile() async {
                    logCallback("🏃 ConcurrentPattern.ViewModel on: \(currentThreadStatus())", .output)
                    
                    // Single departure via @concurrent
                    logCallback("🚀 Calling @concurrent method...", .info)
                    _ = await fetchAllData(log: logCallback)
                    
                    // Single return to Main
                    logCallback("📱 Back to ViewModel: \(currentThreadStatus())", .success)
                    logCallback("✅ Profile ready via @concurrent pattern", .success)
                }
            }
            
            // Use cases optimized for @concurrent usage
            nonisolated struct UserUseCase {
                private let repository = Repository()
                
                func getUser(log: LogCallback) async -> String {
                    log("    🏗️ ConcurrentPattern.UserUseCase (nonisolated) on: \(currentThreadStatus())", .output)
                    return await repository.fetchUser(log: log)
                }
            }
            
            nonisolated struct PostUseCase {
                private let apiClient = APIClient()
                
                func getUserPosts(userId: String, log: LogCallback) async -> [String] {
                    log("    🏗️ ConcurrentPattern.PostUseCase (nonisolated) on: \(currentThreadStatus())", .output)
                    return await apiClient.fetchPosts(userId: userId, log: log)
                }
            }
            
            nonisolated struct FriendUseCase {
                private let repository = Repository()
                
                func getFriends(userId: String, log: LogCallback) async -> [String] {
                    log("    🏗️ ConcurrentPattern.FriendUseCase (nonisolated) on: \(currentThreadStatus())", .output)
                    return await repository.fetchFriends(userId: userId, log: log)
                }
            }
        }
    }
    
    // Shared infrastructure (used by all patterns)
    nonisolated struct Repository {
        func fetchUser(log: LogCallback) async -> String {
            log("      💾 Repository.fetchUser on: \(currentThreadStatus())", .output)
            try? await Task.sleep(nanoseconds: 100_000_000)
            return "John Doe"
        }
        
        func fetchFriends(userId: String, log: LogCallback) async -> [String] {
            log("      💾 Repository.fetchFriends on: \(currentThreadStatus())", .output)
            try? await Task.sleep(nanoseconds: 100_000_000)
            return ["Alice", "Bob", "Charlie"]
        }
    }
    
    nonisolated struct APIClient {
        func fetchPosts(userId: String, log: LogCallback) async -> [String] {
            log("      🌐 APIClient.fetchPosts on: \(currentThreadStatus())", .output)
            try? await Task.sleep(nanoseconds: 100_000_000)
            return ["Post 1", "Post 2", "Post 3"]
        }
    }
    
    // Data model
    struct ProfileData {
        let user: String
        let posts: [String]
        let friends: [String]
    }
}

#Preview {
    NavigationStack { ThreadHoppingOptimizationView() }
}
