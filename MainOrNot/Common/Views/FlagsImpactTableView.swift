import SwiftUI

struct FlagsImpactTableView: View {
    let headers: [String]
    let rows: [[String]]
    let notes: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Table
            VStack(spacing: 0) {
                // Headers
                HStack(spacing: 1) {
                    ForEach(headers.indices, id: \.self) { index in
                        Text(headers[index])
                            .font(.system(.caption, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.2))
                    }
                }
                
                // Rows
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: 1) {
                        ForEach(rows[rowIndex].indices, id: \.self) { cellIndex in
                            Text(rows[rowIndex][cellIndex])
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity)
                                .background(rowIndex % 2 == 0 ? Color.orange.opacity(0.05) : Color.orange.opacity(0.1))
                        }
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(6)
            
            // Notes
            if !notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(notes, id: \.self) { note in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .font(.system(.caption2, weight: .medium))
                                .foregroundColor(.orange)
                            Text(note)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
    }
}

// Typealias for the closure that generates the table view
typealias FlagsTableBuilder = () -> Swift6FlagsTableView

// Specialized variant for Swift 6 flags
struct Swift6FlagsTableView: View {
    let acFalseNonisolated: String
    let acTrueNonisolated: String
    let acFalseMainActor: String
    let acTrueMainActor: String
    let description: String
    let notes: [String]
    
    var body: some View {
        FlagsImpactTableView(
            headers: ["AC", "DAI", description],
            rows: [
                ["false", "nonisolated", acFalseNonisolated],
                ["true", "nonisolated", acTrueNonisolated],
                ["false", "MainActor", acFalseMainActor],
                ["true", "MainActor", acTrueMainActor]
            ],
            notes: notes
        )
    }
}

#Preview {
    VStack {
        Swift6FlagsTableView(
            acFalseNonisolated: "false / false",
            acTrueNonisolated: "true / false", 
            acFalseMainActor: "true / true",
            acTrueMainActor: "true / true",
            description: "fetch / parse",
            notes: [
                "AC (Approachable Concurrency) = GlobalActorIsolatedTypesUsability",
                "DAI (Default Actor Isolation) = MainActor ou nonisolated",
                String(localized: "table.note.detached")
            ]
        )
        .padding()
    }
}