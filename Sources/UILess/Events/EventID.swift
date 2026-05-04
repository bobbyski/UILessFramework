import Foundation

/// Stable identity for an event.
public struct EventID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable identifier value.
    public let rawValue: String

    /// Creates an event identity.
    ///
    /// If no value is provided, a UUID string is generated.
    public init(_ rawValue: String = UUID().uuidString) {
        self.rawValue = rawValue
    }

    /// Creates an event identity from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Stable identity for a platform or platform adapter.
public struct PlatformID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable identifier value.
    public let rawValue: String

    /// Creates a platform identity.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a platform identity from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Stable semantic type for a UILess event.
public struct EventType: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable event type value.
    public let rawValue: String

    /// Creates an event type.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates an event type from a string literal.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Standard event types used by the core and platform bridges.
public extension EventType {
    /// Application lifecycle event.
    static let lifecycle: EventType = "lifecycle"

    /// Keyboard input event.
    static let keyboard: EventType = "keyboard"

    /// Pointer, mouse, touch, or indirect pointing event.
    static let pointer: EventType = "pointer"

    /// Focus change event.
    static let focus: EventType = "focus"

    /// Command activation event.
    static let command: EventType = "command"

    /// Value change event.
    static let valueChanged: EventType = "valueChanged"

    /// Selection change event.
    static let selectionChanged: EventType = "selectionChanged"

    /// Submit event.
    static let submit: EventType = "submit"

    /// Cancel event.
    static let cancel: EventType = "cancel"

    /// Navigation event.
    static let navigate: EventType = "navigate"

    /// Custom event outside the current standard set.
    static let custom: EventType = "custom"
}
