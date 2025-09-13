import Foundation

nonisolated func isOnMain() -> Bool {
    return Thread.isMainThread
}

/// Function to safely get thread status with thread number
nonisolated func currentThreadStatus() -> String {
    if isOnMain() {
        return "Main Thread"
    } else {
        let threadNumber = pthread_mach_thread_np(pthread_self())
        return "Background Thread #\(threadNumber)"
    }
}

/// Extension to safely access thread info with number
extension LogEntry {
    nonisolated static func threadInfo() -> String {
        if Thread.isMainThread {
            return "🟢 Main Thread"
        } else {
            let threadNumber = pthread_mach_thread_np(pthread_self())
            return "🔴 Background #\(threadNumber)"
        }
    }
}
