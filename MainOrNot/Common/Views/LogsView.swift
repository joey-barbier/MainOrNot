import SwiftUI

struct LogsView: View {
    let logs: [LogEntry]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Logs")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemBackground))
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(logs) { log in
                            LogEntryView(entry: log)
                                .id(log.id)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                .onChange(of: logs.count) {
                    if let lastLog = logs.last {
                        withAnimation {
                            proxy.scrollTo(lastLog.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct LogEntryView: View {
    let entry: LogEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 12) {
                Text(entry.threadInfo)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 140, alignment: .leading)
                
                Text(entry.message)
                    .font(.system(.callout, design: .monospaced))
                    .foregroundColor(entry.type.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(entry.timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.leading, 152)
        }
        .padding(.vertical, 2)
    }
}
