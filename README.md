# Swift Concurrency Demo - iOS

Application de démonstration interactive des concepts de concurrence dans iOS avec Swift 6.2.

## 🎯 Structure du projet

Le projet est organisé par sections, chaque exemple ayant sa propre vue dédiée avec :
- Code source affiché
- Logs d'exécution en temps réel
- Points de validation
- Indicateurs de thread (🟢 Main / 🔴 Background)

```
Concurrency/
├── ConcurrencyApp.swift           # Point d'entrée
├── MainMenuView.swift             # Menu de navigation principal
├── Common/                        # Composants partagés
│   ├── Models/
│   │   └── LogEntry.swift        # Modèle pour les logs
│   └── Views/
│       ├── CodeView.swift        # Affichage du code
│       └── LogsView.swift        # Affichage des logs
└── Examples/                      # Exemples organisés par section
    ├── 1_BasicsMainActor/
    ├── 2_TasksPriorities/
    ├── 3_IsolationActors/
    ├── 4_ExitingMainActor/
    ├── 5_StructuredConcurrency/
    └── 6_ToolsDiagnostic/
```

## 📱 Sections disponibles

### 1. Bases & Main Actor
- **Deux async enchaînées** : Héritage du MainActor entre fonctions
- **Callback → async/await** : Moderniser les callbacks

### 2. Tasks & Priorités
- **Task vs Task.detached** : Comprendre l'héritage d'isolation
- **Annulation coopérative** : Gérer l'annulation des tâches

### 3. Isolation & Actors
- **Actor simple** : Protection contre les data races
- **Propriété nonisolated** : Accès synchrone dans un actor
- **isolated deinit** : Cleanup sécurisé

### 4. Sortir du Main Actor
- **nonisolated vs isolation** : Comment sortir de l'isolation
- **nonisolated dans un actor** : Accès synchrone aux membres
- **Task.detached vs nonisolated** : Différentes approches

### 5. Concurrence Structurée
- **Comprendre la concurrence** : Séquentiel vs concurrent
- **TaskGroup parallèle** : Exécuter plusieurs tâches en parallèle
- **TaskGroup avec timeout** : Limiter le temps d'exécution

### 6. Outils & Diagnostic
- **Instruments Profiling** : Visualiser les tâches concurrentes
- **Avertissements de compilation** : Détecter les data races

## 🚀 Configuration requise

- Xcode 15.0+
- iOS 17.0+
- Swift 6.2

## 💡 Utilisation

1. Ouvrez le projet dans Xcode
2. Lancez l'application sur un simulateur ou appareil
3. Naviguez dans les différents exemples via le menu principal
4. Appuyez sur "Exécuter" pour voir le code en action
5. Observez les logs en temps réel avec indicateurs de thread

## 🎓 Points clés d'apprentissage

- **async/await** : Syntaxe moderne pour la programmation asynchrone
- **Actors** : Protection automatique contre les data races
- **nonisolated** : Sortir de l'isolation pour l'accès synchrone
- **Concurrence structurée** : Gestion sûre des tâches enfants
- **Diagnostic** : Outils pour détecter et résoudre les problèmes