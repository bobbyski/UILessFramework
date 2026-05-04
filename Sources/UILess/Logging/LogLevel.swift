public enum LogLevel: Int, Codable, CaseIterable, Comparable, Sendable {
    case trace = 0
    case debug = 10
    case info = 20
    case command = 25
    case result = 26
    case communication = 27
    case data = 28
    case object = 29
    case warning = 30
    case error = 40
    case critical = 50
    case off = 100

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

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

    public var isLoggable: Bool {
        self != .off
    }
}
