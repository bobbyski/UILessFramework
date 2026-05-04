import Foundation

public struct UILessEvent: Codable, Equatable, Identifiable, Sendable {
    public var id: EventID
    public var timestamp: Date
    public var source: PlatformID
    public var type: EventType
    public var target: EventTarget
    public var payload: EventPayload
    public var metadata: [String: String]

    public init(
        id: EventID = EventID(),
        timestamp: Date = Date(),
        source: PlatformID,
        type: EventType,
        target: EventTarget = .none,
        payload: EventPayload = .none,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.timestamp = timestamp
        self.source = source
        self.type = type
        self.target = target
        self.payload = payload
        self.metadata = metadata
    }
}

public enum EventPayload: Codable, Equatable, Sendable {
    case none
    case lifecycle(LifecycleEvent)
    case keyboard(KeyboardEvent)
    case pointer(PointerEvent)
    case focus(FocusEvent)
    case command(CommandEvent)
    case valueChanged(ValueChangedEvent)
    case selectionChanged(SelectionChangedEvent)
    case navigation(NavigationEvent)
    case custom(name: String, values: [String: String])
}

public enum LifecycleEvent: String, Codable, Equatable, Sendable {
    case launch
    case ready
    case suspend
    case resume
    case terminate
}

public struct KeyboardEvent: Codable, Equatable, Sendable {
    public var key: String
    public var modifiers: EventModifiers
    public var phase: InputPhase

    public init(key: String, modifiers: EventModifiers = [], phase: InputPhase = .pressed) {
        self.key = key
        self.modifiers = modifiers
        self.phase = phase
    }
}

public struct PointerEvent: Codable, Equatable, Sendable {
    public var location: EventPoint
    public var button: PointerButton?
    public var modifiers: EventModifiers
    public var phase: InputPhase

    public init(
        location: EventPoint,
        button: PointerButton? = nil,
        modifiers: EventModifiers = [],
        phase: InputPhase
    ) {
        self.location = location
        self.button = button
        self.modifiers = modifiers
        self.phase = phase
    }
}

public struct FocusEvent: Codable, Equatable, Sendable {
    public var focused: Bool

    public init(focused: Bool) {
        self.focused = focused
    }
}

public struct CommandEvent: Codable, Equatable, Sendable {
    public var command: String

    public init(command: String) {
        self.command = command
    }
}

public struct ValueChangedEvent: Codable, Equatable, Sendable {
    public var value: EventValue

    public init(value: EventValue) {
        self.value = value
    }
}

public struct SelectionChangedEvent: Codable, Equatable, Sendable {
    public var selectedIDs: [String]

    public init(selectedIDs: [String]) {
        self.selectedIDs = selectedIDs
    }
}

public struct NavigationEvent: Codable, Equatable, Sendable {
    public var destination: StepID

    public init(destination: StepID) {
        self.destination = destination
    }
}

public struct EventPoint: Codable, Equatable, Sendable {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public enum EventValue: Codable, Equatable, Sendable {
    case string(String)
    case integer(Int)
    case double(Double)
    case bool(Bool)
    case stringArray([String])
    case none
}

public enum InputPhase: String, Codable, Equatable, Sendable {
    case began
    case changed
    case pressed
    case released
    case ended
    case cancelled
}

public enum PointerButton: String, Codable, Equatable, Sendable {
    case primary
    case secondary
    case middle
    case other
}

public struct EventModifiers: OptionSet, Codable, Equatable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let shift = EventModifiers(rawValue: 1 << 0)
    public static let control = EventModifiers(rawValue: 1 << 1)
    public static let option = EventModifiers(rawValue: 1 << 2)
    public static let command = EventModifiers(rawValue: 1 << 3)
    public static let function = EventModifiers(rawValue: 1 << 4)
}
