# Swift Concurrency Demo - iOS

🌐 **[English](README.md)** | **[Français](README_fr.md)** | **[Español](README_es.md)** | **[日本語](README_ja.md)** | **[Português BR](README_pt-BR.md)**

Interaktive Demonstrationsanwendung für Swift-Nebenläufigkeitskonzepte in iOS mit Swift 6.2.

## 🎯 Projektstruktur

Das Projekt ist in Abschnitte unterteilt, wobei jedes Beispiel eine eigene dedizierte Ansicht hat mit:
- Quellcode-Anzeige
- Echtzeit-Ausführungsprotokolle
- Validierungspunkte
- Thread-Indikatoren (🟢 Main / 🔴 Background)

```
Concurrency/
├── ConcurrencyApp.swift           # Einstiegspunkt
├── MainMenuView.swift             # Haupt-Navigationsmenü
├── Common/                        # Geteilte Komponenten
│   ├── Models/
│   │   └── LogEntry.swift        # Log-Modell
│   └── Views/
│       ├── CodeView.swift        # Code-Anzeige
│       └── LogsView.swift        # Log-Anzeige
└── Examples/                      # Beispiele nach Abschnitten organisiert
    ├── Basics/
    ├── Tasks/
    └── Actors/
```

## 📱 Verfügbare Abschnitte

### 1. Grundlagen
- **async let Parallel** : Nebenläufige strukturierte Operationen zeigen
- **MainActor Isolation** : MainActor-Vererbung verstehen

### 2. Aufgaben
- **Task Lifecycle** : Task-Erstellung, -Ausführung und -Vollendung
- **Task vs Detached** : Isolationsvererbung verstehen
- **Cooperative Cancellation** : Task-Abbruch verwalten
- **TaskGroup Parallel** : Mehrere Tasks parallel ausführen

### 3. Akteure
- **Actor Data Race** : Schutz vor Data Races
- **Concurrent MainActor** : Mit MainActor-Isolation arbeiten
- **Nonisolated Property** : Synchroner Zugriff in einem Actor
- **Isolated Deinit** : Sichere Bereinigung

## 🚀 Anforderungen

- Xcode 15.0+
- iOS 17.0+
- Swift 6.2

## 💡 Verwendung

1. Öffnen Sie das Projekt in Xcode
2. Starten Sie die App auf einem Simulator oder Gerät
3. Navigieren Sie durch die verschiedenen Beispiele über das Hauptmenü
4. Tippen Sie auf "Ausführen", um den Code in Aktion zu sehen
5. Beobachten Sie Echtzeit-Logs mit Thread-Indikatoren

## 🎓 Wichtige Lernpunkte

- **async/await** : Moderne Syntax für asynchrone Programmierung
- **Actors** : Automatischer Schutz vor Data Races
- **nonisolated** : Isolation für synchronen Zugriff verlassen
- **Strukturierte Nebenläufigkeit** : Sichere Verwaltung von untergeordneten Tasks
- **Diagnostik** : Werkzeuge zur Erkennung und Lösung von Problemen

## 🌐 Unterstützte Sprachen

Diese App unterstützt 6 Sprachen mit 100% Lokalisierung:
- 🇬🇧 Englisch
- 🇫🇷 Französisch
- 🇩🇪 Deutsch
- 🇪🇸 Spanisch
- 🇯🇵 Japanisch
- 🇧🇷 Portugiesisch (Brasilien)