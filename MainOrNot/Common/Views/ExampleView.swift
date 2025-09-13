import SwiftUI

struct ExampleView: View {
    let title: String
    let objective: String
    let code: String
    let validationPoints: [String]
    let execution: (@escaping  LogCallback) async throws -> Void
    
    // New optional parameter for flags information
    var flagsImpact: String? = nil
    var flagsTableBuilder: FlagsTableBuilder? = nil
    var productionNotes: String? = nil
    
    @State private var logs: [LogEntry] = []
    @State private var isRunning = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Code tab
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Objective
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Objective", systemImage: "target")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text(objective)
                            .font(.callout)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(8)
                    }
                    
                    // Optional section for flags impact
                    if let flagsTableBuilder = flagsTableBuilder {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Swift 6 flags impact", systemImage: "flag.fill")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            flagsTableBuilder()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.orange.opacity(0.08))
                                .cornerRadius(8)
                        }
                    } else if let flagsImpact = flagsImpact {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Swift 6 flags impact", systemImage: "flag.fill")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            Text(flagsImpact)
                                .font(.system(.caption, design: .monospaced))
                                .lineSpacing(2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.orange.opacity(0.08))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Optional section for production notes
                    if let productionNotes = productionNotes {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Production notes", systemImage: "exclamationmark.triangle.fill")
                                .font(.headline)
                                .foregroundColor(.red)
                            
                            Text(productionNotes)
                                .font(.callout)
                                .lineSpacing(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Code
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Spacer()
                            CodeView(code: code).copyButton
                        }
                        CodeView(code: code)
                    }
                    
                    // Validation points
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Validation points", systemImage: "checkmark.circle")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(validationPoints, id: \.self) { point in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.callout)
                                    Text(point)
                                        .font(.callout)
                                        .lineSpacing(2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.green.opacity(0.08))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .tabItem {
                Image(systemName: "doc.text")
                Text("Code")
            }
            .tag(0)
            
            // Logs tab
            VStack(spacing: 0) {
                LogsView(logs: logs)
                
                Button(action: runExample) {
                    HStack {
                        if isRunning {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "play.fill")
                        }
                        Text(isRunning ? "Running..." : "Execute")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRunning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isRunning)
                }
                .padding()
            }
            .tabItem {
                Image(systemName: "terminal")
                Text("Logs")
            }
            .tag(1)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isRunning) {
            // Automatically switch to Logs tab when execution begins
            guard isRunning  else { return }
            selectedTab = 1
        }
    }
    
    private func runExample() {
        isRunning = true
        logs.removeAll()
        
        Task {
            addLog("🚀 Execution started", type: .info)
            
            do {
                try await execution(addLog)
                addLog("✅ Execution completed", type: .success)
            } catch {
                addLog("❌ Error: \(error.localizedDescription)", type: .error)
            }
            
            await MainActor.run {
                isRunning = false
            }
        }
    }
    
    nonisolated private func addLog(_ message: String, type: LogType) {
        let threadInfo = LogEntry.threadInfo()
        let entry = LogEntry(
            message: message,
            type: type,
            threadInfo: threadInfo,
            timestamp: Date()
        )
        Task { @MainActor in
            logs.append(entry)
        }
    }
}
