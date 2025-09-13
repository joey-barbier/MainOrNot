# Swift Concurrency Demo - iOS

🌐 **[English](README.md)** | **[Français](README_fr.md)** | **[Deutsch](README_de.md)** | **[Español](README_es.md)** | **[日本語](README_ja.md)**

Aplicativo de demonstração interativa para conceitos de concorrência Swift no iOS com Swift 6.2.

## 🎯 Estrutura do Projeto

O projeto é organizado por seções, cada exemplo tendo sua própria visualização dedicada com:
- Exibição do código fonte
- Logs de execução em tempo real
- Pontos de validação
- Indicadores de thread (🟢 Main / 🔴 Background)

```
Concurrency/
├── ConcurrencyApp.swift           # Ponto de entrada
├── MainMenuView.swift             # Menu de navegação principal
├── Common/                        # Componentes compartilhados
│   ├── Models/
│   │   └── LogEntry.swift        # Modelo de log
│   └── Views/
│       ├── CodeView.swift        # Exibição de código
│       └── LogsView.swift        # Exibição de logs
└── Examples/                      # Exemplos organizados por seção
    ├── Basics/
    ├── Tasks/
    └── Actors/
```

## 📱 Seções Disponíveis

### 1. Básicos
- **async let Parallel** : Mostrar operações estruturadas concorrentes
- **MainActor Isolation** : Entender herança do MainActor

### 2. Tarefas
- **Task Lifecycle** : Criação, execução e conclusão de tarefas
- **Task vs Detached** : Entender herança de isolamento
- **Cooperative Cancellation** : Gerenciar cancelamento de tarefas
- **TaskGroup Parallel** : Executar múltiplas tarefas em paralelo

### 3. Atores
- **Actor Data Race** : Proteção contra corridas de dados
- **Concurrent MainActor** : Trabalhando com isolamento MainActor
- **Nonisolated Property** : Acesso síncrono em um ator
- **Isolated Deinit** : Limpeza segura

## 🚀 Requisitos

- Xcode 15.0+
- iOS 17.0+
- Swift 6.2

## 💡 Uso

1. Abra o projeto no Xcode
2. Execute o aplicativo em um simulador ou dispositivo
3. Navegue pelos diferentes exemplos através do menu principal
4. Toque em "Executar" para ver o código em ação
5. Observe logs em tempo real com indicadores de thread

## 🎓 Pontos-Chave de Aprendizado

- **async/await** : Sintaxe moderna para programação assíncrona
- **Actors** : Proteção automática contra corridas de dados
- **nonisolated** : Sair do isolamento para acesso síncrono
- **Concorrência Estruturada** : Gerenciamento seguro de tarefas filhas
- **Diagnósticos** : Ferramentas para detectar e resolver problemas

## 🌐 Idiomas Suportados

Este aplicativo suporta 6 idiomas com 100% de localização:
- 🇬🇧 Inglês
- 🇫🇷 Francês
- 🇩🇪 Alemão
- 🇪🇸 Espanhol
- 🇯🇵 Japonês
- 🇧🇷 Português (Brasil)