import SwiftUI

struct SwiftSyntaxHighlighter {
    static func highlight(_ code: String) -> AttributedString {
        var attributedString = AttributedString(code)
        
        // Define colors (Xcode style)
        let keywordColor = Color(red: 0.666, green: 0.058, blue: 0.568) // Violet Swift
        let stringColor = Color(red: 0.768, green: 0.102, blue: 0.086)  // Rouge string
        let commentColor = Color(red: 0.425, green: 0.475, blue: 0.537) // Gris commentaire
        let functionColor = Color(red: 0.270, green: 0.352, blue: 0.588) // Bleu fonction
        let typeColor = Color(red: 0.062, green: 0.404, blue: 0.515)     // Bleu-vert type
        let numberColor = Color(red: 0.156, green: 0.156, blue: 0.999)   // Bleu nombre
        
        // Swift keywords
        let keywords = [
            "func", "var", "let", "async", "await", "Task", "struct", "class", "enum",
            "if", "else", "for", "while", "switch", "case", "default", "return",
            "import", "public", "private", "internal", "static", "nonisolated",
            "@MainActor", "@concurrent", "actor", "isolated", "try", "catch", "throw",
            "true", "false", "nil", "self", "Self", "init", "deinit", "extension"
        ]
        
        // Common Swift types
        let types = [
            "String", "Int", "Double", "Bool", "Array", "Dictionary", "Set",
            "Thread", "Task", "MainActor", "ContinuousClock", "Duration"
        ]
        
        // Common functions
        let functions = [
            "print", "sleep", "detached", "checkCancellation"
        ]
        
        // First find all comment zones to exclude them
        let commentRegex = "//.*$"
        let commentRanges = code.ranges(of: commentRegex, options: .regularExpression)
        
        // Helper function to check if a range is inside a comment
        func isInComment(_ range: Range<String.Index>) -> Bool {
            return commentRanges.contains { commentRange in
                commentRange.contains(range.lowerBound) || commentRange.overlaps(range)
            }
        }
        
        // Color keywords (excluding comments)
        for keyword in keywords {
            let ranges = code.ranges(of: "\\b\(keyword)\\b", options: .regularExpression)
            for range in ranges {
                if !isInComment(range), let attributedRange = Range(range, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = keywordColor
                    attributedString[attributedRange].font = .system(.caption, design: .monospaced).weight(.semibold)
                }
            }
        }
        
        // Color types (excluding comments)
        for type in types {
            let ranges = code.ranges(of: "\\b\(type)\\b", options: .regularExpression)
            for range in ranges {
                if !isInComment(range), let attributedRange = Range(range, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = typeColor
                    attributedString[attributedRange].font = .system(.caption, design: .monospaced).weight(.medium)
                }
            }
        }
        
        // Color functions (excluding comments)
        for function in functions {
            let ranges = code.ranges(of: "\(function)\\(", options: .regularExpression)
            for range in ranges {
                let functionRange = NSRange(location: range.lowerBound.utf16Offset(in: code), 
                                          length: function.count)
                if let swiftRange = Range(functionRange, in: code),
                   !isInComment(swiftRange),
                   let attributedRange = Range(swiftRange, in: attributedString) {
                    attributedString[attributedRange].foregroundColor = functionColor
                    attributedString[attributedRange].font = .system(.caption, design: .monospaced).weight(.medium)
                }
            }
        }
        
        // Color strings (excluding comments)
        let stringRegex = "\"[^\"]*\""
        let stringRanges = code.ranges(of: stringRegex, options: .regularExpression)
        for range in stringRanges {
            if !isInComment(range), let attributedRange = Range(range, in: attributedString) {
                attributedString[attributedRange].foregroundColor = stringColor
            }
        }
        
        // Color comments LAST so they are not overwritten
        for range in commentRanges {
            if let attributedRange = Range(range, in: attributedString) {
                attributedString[attributedRange].foregroundColor = commentColor
                attributedString[attributedRange].font = .system(.caption, design: .monospaced).italic()
            }
        }
        
        // Color numbers
        let numberRegex = "\\b\\d+(\\.\\d+)?\\b"
        let numberRanges = code.ranges(of: numberRegex, options: .regularExpression)
        for range in numberRanges {
            if let attributedRange = Range(range, in: attributedString) {
                attributedString[attributedRange].foregroundColor = numberColor
            }
        }
        
        return attributedString
    }
}

// Extension to simplify range searching
extension String {
    func ranges(of searchString: String, options: CompareOptions = []) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: searchString, options: options, range: searchStartIndex..<self.endIndex) {
            ranges.append(range)
            searchStartIndex = range.upperBound
        }
        
        return ranges
    }
}
