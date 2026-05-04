/// Severity or purpose level for a log record.
public enum LogLevel: Int, Codable, CaseIterable, Comparable, UILessObject {
    /// Very detailed diagnostic information.
    case trace = 0

    /// Debug information useful while developing.
    case debug = 10

    /// General informational message.
    case info = 20

    /// Command being executed.
    case command = 25

    /// Result from a command.
    case result = 26

    /// Communication or transport diagnostic.
    case communication = 27

    /// Raw or decoded data diagnostic.
    case data = 28

    /// Object identity or object-state diagnostic.
    case object = 29

    /// Warning that does not stop execution.
    case warning = 30

    /// Error that should be visible to developers or diagnostics.
    case error = 40

    /// Critical failure.
    case critical = 50

    /// Logging disabled.
    case off = 100

    /// Orders log levels by severity value.
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Human-readable fixed label for console and text log destinations.
    public var label: String {
        switch self {
        case .trace: "TRACE"
        case .debug: "DEBUG"
        case .info: "INFO"
        case .command: "COMMAND"
        case .result: "RESULT"
        case .communication: "COMM"
        case .data: "DATA"
        case .object: "OBJECT"
        case .warning: "WARNING"
        case .error: "ERROR"
        case .critical: "CRITICAL"
        case .off: "OFF"
        }
    }

    /// Whether this level should ever be emitted.
    public var isLoggable: Bool {
        self != .off
    }
}
