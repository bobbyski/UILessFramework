import Foundation

/// One structured log entry emitted by a logger.
public struct LogRecord: Codable, Equatable, Identifiable, Sendable {
    /// Stable identity for the log record.
    public var id: UUID

    /// Time when the log record was created.
    public var timestamp: Date

    /// Severity or purpose level.
    public var level: LogLevel

    /// Optional subsystem, such as `UILess.Runtime` or `UILess.TUI`.
    public var subsystem: String?

    /// Optional category within the subsystem.
    public var category: String?

    /// Human-readable log message.
    public var message: String

    /// Low-volume structured metadata.
    public var metadata: [String: String]

    /// Source location where the record was emitted.
    public var source: LogSource

    /// Creates a log record.
    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        level: LogLevel,
        subsystem: String? = nil,
        category: String? = nil,
        message: String,
        metadata: [String: String] = [:],
        source: LogSource
    ) {
        self.id = id
        self.timestamp = timestamp
        self.level = level
        self.subsystem = subsystem
        self.category = category
        self.message = message
        self.metadata = metadata
        self.source = source
    }
}

/// Source-code location for a log record.
public struct LogSource: Codable, Equatable, Sendable {
    /// Compiler-provided file identifier.
    public var fileID: String

    /// Compiler-provided function name.
    public var function: String

    /// Compiler-provided line number.
    public var line: Int

    /// Creates a source location.
    public init(fileID: String, function: String, line: Int) {
        self.fileID = fileID
        self.function = function
        self.line = line
    }
}
