# Swift Concurrency Demo - iOS

🌐 **[Français](README_fr.md)** | **[Deutsch](README_de.md)** | **[Español](README_es.md)** | **[日本語](README_ja.md)** | **[Português BR](README_pt-BR.md)**

Interactive demonstration app for Swift concurrency concepts in iOS with Swift 6.2.

## 🎯 Project Structure

The project is organized by sections, each example having its own dedicated view with:
- Source code display
- Real-time execution logs
- Validation points
- Thread indicators (🟢 Main / 🔴 Background)

```
Concurrency/
├── ConcurrencyApp.swift           # Entry point
├── MainMenuView.swift             # Main navigation menu
├── Common/                        # Shared components
│   ├── Models/
│   │   └── LogEntry.swift        # Log model
│   └── Views/
│       ├── CodeView.swift        # Code display
│       └── LogsView.swift        # Log display
└── Examples/                      # Examples organized by section
    ├── Basics/
    ├── Tasks/
    └── Actors/
```

## 📱 Available Sections

### 1. Basics
- **async let Parallel** : Show concurrent structured operations
- **MainActor Isolation** : Understanding main actor inheritance

### 2. Tasks
- **Task Lifecycle** : Task creation, execution and completion
- **Task vs Detached** : Understanding isolation inheritance
- **Cooperative Cancellation** : Managing task cancellation
- **TaskGroup Parallel** : Execute multiple tasks in parallel

### 3. Actors
- **Actor Data Race** : Protection against data races
- **Concurrent MainActor** : Working with main actor isolation
- **Nonisolated Property** : Synchronous access in an actor
- **Isolated Deinit** : Safe cleanup

## 🚀 Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 6.2

## 💡 Usage

1. Open the project in Xcode
2. Run the app on a simulator or device
3. Navigate through the different examples via the main menu
4. Tap "Execute" to see the code in action
5. Observe real-time logs with thread indicators

## 🎓 Key Learning Points

- **async/await** : Modern syntax for asynchronous programming
- **Actors** : Automatic protection against data races
- **nonisolated** : Exit isolation for synchronous access
- **Structured Concurrency** : Safe management of child tasks
- **Diagnostics** : Tools to detect and resolve issues

## 🌐 Supported Languages

This app supports 6 languages with 100% localization:
- 🇬🇧 English
- 🇫🇷 French
- 🇩🇪 German
- 🇪🇸 Spanish
- 🇯🇵 Japanese
- 🇧🇷 Portuguese (Brazil)