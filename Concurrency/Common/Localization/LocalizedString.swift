import Foundation

// MARK: - Localization Helper
struct LocalizedString {
    static func localized(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    static func localized(_ key: String, args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }
}

// MARK: - Convenience Extensions
extension String {
    var localized: String {
        return LocalizedString.localized(self)
    }
    
    func localized(with args: CVarArg...) -> String {
        return LocalizedString.localized(self, args: args)
    }
}

// MARK: - Localized Keys Structure
enum L10n {
    // Navigation & Menu
    enum Menu {
        static let title = String(localized: "menu.title")
        static let basics = String(localized: "menu.basics")
        static let tasks = String(localized: "menu.tasks")
        static let actors = String(localized: "menu.actors")
    }
    
    // Examples organized by topic
    enum Example {
        enum MainActor {
            static let title = String(localized: "example.mainactor.title")
            static let objective = String(localized: "mainactor.objective")
            static let validation = String(localized: "mainactor.validation")
        }
        
        enum AsyncLet {
            static let title = String(localized: "example.asynclet.title")
            static let objective = String(localized: "asynclet.objective")
            static let validation = String(localized: "asynclet.validation")
        }
        
        enum TaskVs {
            static let title = String(localized: "example.taskvs.title")
            static let objective = String(localized: "taskvs.objective")
            static let validation = String(localized: "taskvs.validation")
        }
        
        enum Cancellation {
            static let title = String(localized: "example.cancellation.title")
            static let objective = String(localized: "cancellation.objective")
            static let validation = String(localized: "cancellation.validation")
        }
        
        enum TaskGroup {
            static let title = String(localized: "example.taskgroup.title")
            static let objective = String(localized: "taskgroup.objective")
            static let validation = String(localized: "taskgroup.validation")
        }
        
        enum Lifecycle {
            static let title = String(localized: "example.lifecycle.title")
            static let objective = String(localized: "lifecycle.objective")
            static let validation = String(localized: "lifecycle.validation")
        }
        
        enum DataRace {
            static let title = String(localized: "example.datarace.title")
            static let objective = String(localized: "datarace.objective")
            static let validation = String(localized: "datarace.validation")
        }
        
        enum Nonisolated {
            static let title = String(localized: "example.nonisolated.title")
            static let objective = String(localized: "nonisolated.objective")
            static let validation = String(localized: "nonisolated.validation")
        }
        
        enum Concurrent {
            static let title = String(localized: "example.concurrent.title")
            static let objective = String(localized: "concurrent.objective")
            static let validation = String(localized: "concurrent.validation")
        }
        
        enum Deinit {
            static let title = String(localized: "example.deinit.title")
            static let objective = String(localized: "deinit.objective")
            static let validation = String(localized: "deinit.validation")
        }
    }
    
    // Section Headers
    enum Section {
        static let objective = "section.objective"
        static let flagsImpact = "section.flags.impact"
        static let productionNotes = "section.production.notes"
        static let code = "section.code"
        static let validation = "section.validation"
        static let logs = "section.logs"
    }
    
    // Actions
    enum Action {
        static let execute = "action.execute"
        static let executing = "action.executing"
        static let copy = "action.copy"
    }
    
    // Log Messages
    enum Log {
        static let start = "log.start"
        static let end = "log.end"
        static let error = "log.error"
    }
    
    // Flags
    enum Flags {
        static let ac = "flags.table.ac"
        static let dai = "flags.table.dai"
        static let `true` = "flags.true"
        static let `false` = "flags.false"
        static let nonisolated = "flags.nonisolated"
        static let mainactor = "flags.mainactor"
    }
    
    // Notes
    enum Note {
        static let acDescription = "note.ac.description"
        static let daiDescription = "note.dai.description"
    }
}
