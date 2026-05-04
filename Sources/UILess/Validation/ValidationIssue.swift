/// Severity for a validation issue.
public enum ValidationSeverity: String, Codable, Comparable, UILessObject {
    /// Informational validation note.
    case note

    /// Suspicious condition that can usually continue.
    case warning

    /// Invalid condition that should fail strict validation.
    case error

    /// Orders severities by seriousness.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand severity.
    ///   - rhs: Right-hand severity.
    /// - Returns: `true` when `lhs` is less serious than `rhs`.
    public static func < (lhs: ValidationSeverity, rhs: ValidationSeverity) -> Bool {
        lhs.rank < rhs.rank
    }

    private var rank: Int {
        switch self {
        case .note: 0
        case .warning: 1
        case .error: 2
        }
    }
}

/// One validation finding.
public struct ValidationIssue: Codable, Equatable, Identifiable, UILessObject {
    /// Stable identity for this validation issue.
    public var id: EventID

    /// Issue severity.
    public var severity: ValidationSeverity

    /// Stable validation rule identifier.
    public var ruleID: String

    /// Human-readable validation message.
    public var message: String

    /// Component target that produced the issue, when known.
    public var target: EventTarget

    /// Creates a validation issue.
    ///
    /// - Parameters:
    ///   - id: Stable identity for this validation issue.
    ///   - severity: Issue severity.
    ///   - ruleID: Stable validation rule identifier.
    ///   - message: Human-readable validation message.
    ///   - target: Component target that produced the issue.
    public init(
        id: EventID = EventID(),
        severity: ValidationSeverity,
        ruleID: String,
        message: String,
        target: EventTarget = .none
    ) {
        self.id = id
        self.severity = severity
        self.ruleID = ruleID
        self.message = message
        self.target = target
    }
}

/// Result from one validation pass.
public struct ValidationResult: Codable, Equatable, UILessObject {
    /// Mode used for validation.
    public var mode: ValidationMode

    /// Issues produced by validation.
    public var issues: [ValidationIssue]

    /// Whether validation found no errors.
    public var isSuccessful: Bool {
        !issues.contains { $0.severity == .error }
    }

    /// Creates a validation result.
    ///
    /// - Parameters:
    ///   - mode: Mode used for validation.
    ///   - issues: Issues produced by validation.
    public init(mode: ValidationMode, issues: [ValidationIssue] = []) {
        self.mode = mode
        self.issues = issues
    }
}
