import SwiftUI

struct CodeView: View {
    let code: String
    @State private var showCopiedMessage = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(SwiftSyntaxHighlighter.highlight(code))
                .font(.system(.caption, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
                .textSelection(.enabled)
        }
    }
    
    @ViewBuilder
    var copyButton: some View {
        Button(action: copyCode) {
            Image(systemName: showCopiedMessage ? "checkmark" : "doc.on.doc")
                .font(.caption)
                .foregroundColor(showCopiedMessage ? .green : .blue)
                .scaleEffect(showCopiedMessage ? 1.3 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showCopiedMessage)
        }
    }
    
    private func copyCode() {
        UIPasteboard.general.string = code
        
        // Success haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Entry animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showCopiedMessage = true
        }
        
        // Hide message after 2 seconds with modern Task
        Task {
            try? await Task.sleep(for: .seconds(2))
            await MainActor.run {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showCopiedMessage = false
                }
            }
        }
    }
}
