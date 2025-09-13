import SwiftUI

typealias LogCallback = @Sendable (String, LogType) -> Void

struct LogEntry: Identifiable {
    let id = UUID()
    let message: String
    let type: LogType
    let threadInfo: String
    let timestamp: Date
}

enum LogType {
    case info, success, error, output
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .success: return .green
        case .error: return .red
        case .output: return .primary
        }
    }
}
