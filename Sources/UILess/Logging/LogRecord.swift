import Foundation

public struct LogRecord: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var timestamp: Date
    public var level: LogLevel
    public var subsystem: String?
    public var category: String?
    public var message: String
    public var metadata: [String: String]
    public var source: LogSource

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

public struct LogSource: Codable, Equatable, Sendable {
    public var fileID: String
    public var function: String
    public var line: Int

    public init(fileID: String, function: String, line: Int) {
        self.fileID = fileID
        self.function = function
        self.line = line
    }
}
