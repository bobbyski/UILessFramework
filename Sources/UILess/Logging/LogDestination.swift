import Foundation

/// A destination that can receive log records.
public protocol LogDestination: UILessObject {
    /// Writes one log record.
    ///
    /// - Parameter record: Record to write to the destination.
    func write(_ record: LogRecord) async
}

/// A filtered route from a logger to one destination.
public struct LogRoute: UILessObject {
    /// Minimum level this route accepts.
    public var minimumLevel: LogLevel

    /// Accepted categories, or `nil` to accept all categories.
    public var acceptedCategories: Set<String>?

    /// Destination for accepted records.
    public var destination: any LogDestination

    /// Creates a route to a log destination.
    ///
    /// - Parameters:
    ///   - minimumLevel: Minimum level this route accepts.
    ///   - acceptedCategories: Accepted categories, or `nil` to accept all categories.
    ///   - destination: Destination for accepted records.
    public init(
        minimumLevel: LogLevel = .trace,
        acceptedCategories: Set<String>? = nil,
        destination: any LogDestination
    ) {
        self.minimumLevel = minimumLevel
        self.acceptedCategories = acceptedCategories
        self.destination = destination
    }

    /// Returns whether this route accepts a record.
    ///
    /// - Parameter record: Record to evaluate.
    /// - Returns: `true` when this route should receive the record.
    public func accepts(_ record: LogRecord) -> Bool {
        guard minimumLevel != .off, record.level.isLoggable, record.level >= minimumLevel else {
            return false
        }

        guard let acceptedCategories else {
            return true
        }

        guard let category = record.category else {
            return false
        }

        return acceptedCategories.contains(category)
    }
}

/// Log destination backed by an async closure.
public struct ClosureLogDestination: LogDestination {
    private let writer: @Sendable (LogRecord) async -> Void

    /// Creates a closure destination.
    ///
    /// - Parameter writer: Async closure invoked for each accepted record.
    public init(writer: @escaping @Sendable (LogRecord) async -> Void) {
        self.writer = writer
    }

    /// Writes one record by invoking the closure.
    ///
    /// - Parameter record: Record to write.
    public func write(_ record: LogRecord) async {
        await writer(record)
    }
}

/// Log destination that writes formatted records to standard output.
public struct ConsoleLogDestination: LogDestination {
    /// Formatter used to turn records into text.
    public var formatter: LogRecordFormatter

    /// Creates a console destination.
    ///
    /// - Parameter formatter: Formatter used to turn records into text.
    public init(formatter: LogRecordFormatter = .standard) {
        self.formatter = formatter
    }

    /// Writes one formatted record with `print`.
    ///
    /// - Parameter record: Record to write.
    public func write(_ record: LogRecord) async {
        print(formatter.format(record))
    }
}

/// In-memory destination useful for app diagnostics and unit tests.
public actor MemoryLogDestination: LogDestination {
    /// Captured records.
    public private(set) var records: [LogRecord] = []

    /// Maximum number of records retained.
    public var maximumRecordCount: Int

    /// Creates an in-memory destination.
    ///
    /// - Parameter maximumRecordCount: Maximum number of records retained.
    public init(maximumRecordCount: Int = 200) {
        self.maximumRecordCount = maximumRecordCount
    }

    /// Stores one record, trimming older records when needed.
    ///
    /// - Parameter record: Record to store.
    public func write(_ record: LogRecord) {
        records.append(record)

        while records.count > maximumRecordCount {
            records.removeFirst()
        }
    }

    /// Removes all retained records.
    public func clear() {
        records.removeAll()
    }
}

/// Formats a log record into text.
public struct LogRecordFormatter: UILessObject {
    private let formatter: @Sendable (LogRecord) -> String

    /// Creates a formatter from a closure.
    ///
    /// - Parameter formatter: Closure that converts a record to text.
    public init(formatter: @escaping @Sendable (LogRecord) -> String) {
        self.formatter = formatter
    }

    /// Formats one log record.
    ///
    /// - Parameter record: Record to format.
    /// - Returns: Text representation of the record.
    public func format(_ record: LogRecord) -> String {
        formatter(record)
    }

    /// Standard single-line formatter.
    public static let standard = LogRecordFormatter { record in
        let timestamp = ISO8601DateFormatter.uIlessLogger.string(from: record.timestamp)
        let category = record.category.map { " [\($0)]" } ?? ""
        let subsystem = record.subsystem.map { " \($0)" } ?? ""
        let location = " \(record.source.fileID):\(record.source.line)"

        return "\(timestamp) [\(record.level.label)]\(subsystem)\(category) \(record.message)\(location)"
    }
}

private extension ISO8601DateFormatter {
    // ISO8601DateFormatter is comparatively expensive to create and the standard
    // formatter only reads from this instance after initialization.
    nonisolated(unsafe) static let uIlessLogger: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
