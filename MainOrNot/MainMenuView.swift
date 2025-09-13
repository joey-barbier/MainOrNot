import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(String(localized: "1. Basics")) {
                    NavigationLink(destination: MainActorIsolationView()) {
                        MenuItemView(
                            title: String(localized: "menu.mainactor.title"),
                            description: String(localized: "menu.mainactor.description")
                        )
                    }
                    
                    NavigationLink(destination: AsyncLetParallelView()) {
                        MenuItemView(
                            title: String(localized: "menu.asynclet.title"),
                            description: String(localized: "menu.asynclet.description")
                        )
                    }
                    
                    NavigationLink(destination: TaskMainActorChainView()) {
                        MenuItemView(
                            title: String(localized: "menu.taskchain.title"),
                            description: String(localized: "menu.taskchain.description")
                        )
                    }
                }
                
                Section(String(localized: "2. Tasks")) {
                    NavigationLink(destination: TaskVsDetachedView()) {
                        MenuItemView(
                            title: String(localized: "menu.taskdetached.title"),
                            description: String(localized: "menu.taskdetached.description")
                        )
                    }
                    
                    NavigationLink(destination: CooperativeCancellationView()) {
                        MenuItemView(
                            title: String(localized: "menu.cancellation.title"),
                            description: String(localized: "menu.cancellation.description")
                        )
                    }
                    
                    NavigationLink(destination: TaskGroupParallelView()) {
                        MenuItemView(
                            title: String(localized: "menu.taskgroup.title"),
                            description: String(localized: "menu.taskgroup.description")
                        )
                    }
                    
                    NavigationLink(destination: TaskLifecycleView()) {
                        MenuItemView(
                            title: String(localized: "menu.lifecycle.title"),
                            description: String(localized: "menu.lifecycle.description")
                        )
                    }
                }
                
                Section(String(localized: "3. Actors")) {
                    NavigationLink(destination: ActorDataRaceView()) {
                        MenuItemView(
                            title: String(localized: "menu.datarace.title"),
                            description: String(localized: "menu.datarace.description")
                        )
                    }
                    
                    NavigationLink(destination: NonisolatedPropertyView()) {
                        MenuItemView(
                            title: String(localized: "menu.nonisolated.title"),
                            description: String(localized: "menu.nonisolated.description")
                        )
                    }
                    
                    NavigationLink(destination: ConcurrentMainActorView()) {
                        MenuItemView(
                            title: String(localized: "menu.concurrent.title"),
                            description: String(localized: "menu.concurrent.description")
                        )
                    }
                    
                    NavigationLink(destination: IsolatedDeinitView()) {
                        MenuItemView(
                            title: String(localized: "menu.deinit.title"),
                            description: String(localized: "menu.deinit.description")
                        )
                    }
                    
                    NavigationLink(destination: ThreadHoppingOptimizationView()) {
                        MenuItemView(
                            title: String(localized: "menu.threadhopping.title"),
                            description: String(localized: "menu.threadhopping.description")
                        )
                    }
                    
                    NavigationLink(destination: SendableExplainedView()) {
                        MenuItemView(
                            title: String(localized: "menu.sendable.title"),
                            description: String(localized: "menu.sendable.description")
                        )
                    }
                }
            }
            .navigationTitle(String(localized: "Swift Concurrency"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Link(destination: URL(string: "https://github.com/joey-barbier/MainOrNot")!) {
                        Image(systemName: "link")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct MenuItemView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MainMenuView()
}
