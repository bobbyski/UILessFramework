import Foundation

public protocol LogDestination: Sendable {
    func write(_ record: LogRecord) async
}

public struct LogRoute: Sendable {
    public var minimumLevel: LogLevel
    public var acceptedCategories: Set<String>?
    public var destination: any LogDestination

    public init(
        minimumLevel: LogLevel = .trace,
        acceptedCategories: Set<String>? = nil,
        destination: any LogDestination
    ) {
        self.minimumLevel = minimumLevel
        self.acceptedCategories = acceptedCategories
        self.destination = destination
    }

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

public struct ClosureLogDestination: LogDestination {
    private let writer: @Sendable (LogRecord) async -> Void

    public init(writer: @escaping @Sendable (LogRecord) async -> Void) {
        self.writer = writer
    }

    public func write(_ record: LogRecord) async {
        await writer(record)
    }
}

public struct ConsoleLogDestination: LogDestination {
    public var formatter: LogRecordFormatter

    public init(formatter: LogRecordFormatter = .standard) {
        self.formatter = formatter
    }

    public func write(_ record: LogRecord) async {
        print(formatter.format(record))
    }
}

public actor MemoryLogDestination: LogDestination {
    public private(set) var records: [LogRecord] = []
    public var maximumRecordCount: Int

    public init(maximumRecordCount: Int = 200) {
        self.maximumRecordCount = maximumRecordCount
    }

    public func write(_ record: LogRecord) {
        records.append(record)

        while records.count > maximumRecordCount {
            records.removeFirst()
        }
    }

    public func clear() {
        records.removeAll()
    }
}

public struct LogRecordFormatter: Sendable {
    private let formatter: @Sendable (LogRecord) -> String

    public init(formatter: @escaping @Sendable (LogRecord) -> String) {
        self.formatter = formatter
    }

    public func format(_ record: LogRecord) -> String {
        formatter(record)
    }

    public static let standard = LogRecordFormatter { record in
        let timestamp = ISO8601DateFormatter.uIlessLogger.string(from: record.timestamp)
        let category = record.category.map { " [\($0)]" } ?? ""
        let subsystem = record.subsystem.map { " \($0)" } ?? ""
        let location = " \(record.source.fileID):\(record.source.line)"

        return "\(timestamp) [\(record.level.label)]\(subsystem)\(category) \(record.message)\(location)"
    }
}

private extension ISO8601DateFormatter {
    nonisolated(unsafe) static let uIlessLogger: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
