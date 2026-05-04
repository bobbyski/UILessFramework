import Foundation

public struct EventID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String = UUID().uuidString) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public struct PlatformID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public struct EventType: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public extension EventType {
    static let lifecycle: EventType = "lifecycle"
    static let keyboard: EventType = "keyboard"
    static let pointer: EventType = "pointer"
    static let focus: EventType = "focus"
    static let command: EventType = "command"
    static let valueChanged: EventType = "valueChanged"
    static let selectionChanged: EventType = "selectionChanged"
    static let submit: EventType = "submit"
    static let cancel: EventType = "cancel"
    static let navigate: EventType = "navigate"
    static let custom: EventType = "custom"
}
