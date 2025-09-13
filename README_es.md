# Swift Concurrency Demo - iOS

🌐 **[English](README.md)** | **[Français](README_fr.md)** | **[Deutsch](README_de.md)** | **[日本語](README_ja.md)** | **[Português BR](README_pt-BR.md)**

Aplicación de demostración interactiva para conceptos de concurrencia Swift en iOS con Swift 6.2.

## 🎯 Estructura del Proyecto

El proyecto está organizado por secciones, cada ejemplo tiene su propia vista dedicada con:
- Visualización del código fuente
- Registros de ejecución en tiempo real
- Puntos de validación
- Indicadores de hilo (🟢 Main / 🔴 Background)

```
Concurrency/
├── ConcurrencyApp.swift           # Punto de entrada
├── MainMenuView.swift             # Menú de navegación principal
├── Common/                        # Componentes compartidos
│   ├── Models/
│   │   └── LogEntry.swift        # Modelo de registro
│   └── Views/
│       ├── CodeView.swift        # Visualización de código
│       └── LogsView.swift        # Visualización de registros
└── Examples/                      # Ejemplos organizados por sección
    ├── Basics/
    ├── Tasks/
    └── Actors/
```

## 📱 Secciones Disponibles

### 1. Conceptos Básicos
- **async let Parallel** : Mostrar operaciones estructuradas concurrentes
- **MainActor Isolation** : Entender la herencia de MainActor

### 2. Tareas
- **Task Lifecycle** : Creación, ejecución y finalización de tareas
- **Task vs Detached** : Entender la herencia de aislamiento
- **Cooperative Cancellation** : Gestionar la cancelación de tareas
- **TaskGroup Parallel** : Ejecutar múltiples tareas en paralelo

### 3. Actores
- **Actor Data Race** : Protección contra carreras de datos
- **Concurrent MainActor** : Trabajar con aislamiento de MainActor
- **Nonisolated Property** : Acceso síncrono en un actor
- **Isolated Deinit** : Limpieza segura

## 🚀 Requisitos

- Xcode 15.0+
- iOS 17.0+
- Swift 6.2

## 💡 Uso

1. Abra el proyecto en Xcode
2. Ejecute la aplicación en un simulador o dispositivo
3. Navegue por los diferentes ejemplos a través del menú principal
4. Toque "Ejecutar" para ver el código en acción
5. Observe los registros en tiempo real con indicadores de hilo

## 🎓 Puntos Clave de Aprendizaje

- **async/await** : Sintaxis moderna para programación asíncrona
- **Actors** : Protección automática contra carreras de datos
- **nonisolated** : Salir del aislamiento para acceso síncrono
- **Concurrencia Estructurada** : Gestión segura de tareas hijas
- **Diagnósticos** : Herramientas para detectar y resolver problemas

## 🌐 Idiomas Soportados

Esta aplicación soporta 6 idiomas con localización 100%:
- 🇬🇧 Inglés
- 🇫🇷 Francés
- 🇩🇪 Alemán
- 🇪🇸 Español
- 🇯🇵 Japonés
- 🇧🇷 Portugués (Brasil)