import Foundation

/// A platform-independent event that can move between platform adapters and the core runtime.
public struct UILessEvent: Codable, Equatable, Identifiable, Sendable {
    /// Stable identity for this event.
    public var id: EventID

    /// Time when the event was created or received.
    public var timestamp: Date

    /// Platform adapter that produced the event.
    public var source: PlatformID

    /// Semantic event type.
    public var type: EventType

    /// Platform-independent target for the event.
    public var target: EventTarget

    /// Typed event data.
    public var payload: EventPayload

    /// Additional low-volume event metadata for diagnostics or adapter-specific hints.
    public var metadata: [String: String]

    /// Creates a UILess event.
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

/// Typed payload carried by a `UILessEvent`.
public enum EventPayload: Codable, Equatable, Sendable {
    /// Event has no structured payload.
    case none

    /// Application lifecycle payload.
    case lifecycle(LifecycleEvent)

    /// Keyboard input payload.
    case keyboard(KeyboardEvent)

    /// Pointer input payload.
    case pointer(PointerEvent)

    /// Focus change payload.
    case focus(FocusEvent)

    /// Command activation payload.
    case command(CommandEvent)

    /// Value change payload.
    case valueChanged(ValueChangedEvent)

    /// Selection change payload.
    case selectionChanged(SelectionChangedEvent)

    /// Navigation payload.
    case navigation(NavigationEvent)

    /// Custom payload for platform or experimental events.
    case custom(name: String, values: [String: String])
}

/// Application lifecycle events understood by the core.
public enum LifecycleEvent: String, Codable, Equatable, Sendable {
    /// Application is launching.
    case launch

    /// Application is ready for interaction.
    case ready

    /// Application is suspending.
    case suspend

    /// Application is resuming.
    case resume

    /// Application is terminating.
    case terminate
}

/// Platform-independent keyboard event.
public struct KeyboardEvent: Codable, Equatable, Sendable {
    /// Key name or character in platform-normalized form.
    public var key: String

    /// Keyboard modifiers active for the event.
    public var modifiers: EventModifiers

    /// Input phase for this key event.
    public var phase: InputPhase

    /// Creates a keyboard event.
    public init(key: String, modifiers: EventModifiers = [], phase: InputPhase = .pressed) {
        self.key = key
        self.modifiers = modifiers
        self.phase = phase
    }
}

/// Platform-independent pointer event.
public struct PointerEvent: Codable, Equatable, Sendable {
    /// Location in the platform adapter's current coordinate space.
    public var location: EventPoint

    /// Pointer button associated with the event, when any.
    public var button: PointerButton?

    /// Modifiers active during the pointer event.
    public var modifiers: EventModifiers

    /// Input phase for this pointer event.
    public var phase: InputPhase

    /// Creates a pointer event.
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

/// Focus state change for an event target.
public struct FocusEvent: Codable, Equatable, Sendable {
    /// Whether the target gained focus.
    public var focused: Bool

    /// Creates a focus event.
    public init(focused: Bool) {
        self.focused = focused
    }
}

/// Command activation event.
public struct CommandEvent: Codable, Equatable, Sendable {
    /// Stable command name.
    public var command: String

    /// Creates a command event.
    public init(command: String) {
        self.command = command
    }
}

/// Value change event for a resource.
public struct ValueChangedEvent: Codable, Equatable, Sendable {
    /// New platform-independent value.
    public var value: EventValue

    /// Creates a value change event.
    public init(value: EventValue) {
        self.value = value
    }
}

/// Selection change event for list-like resources.
public struct SelectionChangedEvent: Codable, Equatable, Sendable {
    /// Stable selected item identifiers.
    public var selectedIDs: [String]

    /// Creates a selection change event.
    public init(selectedIDs: [String]) {
        self.selectedIDs = selectedIDs
    }
}

/// Navigation event from one step to another.
public struct NavigationEvent: Codable, Equatable, Sendable {
    /// Destination step.
    public var destination: StepID

    /// Creates a navigation event.
    public init(destination: StepID) {
        self.destination = destination
    }
}

/// Two-dimensional integer point for platform-independent events.
public struct EventPoint: Codable, Equatable, Sendable {
    /// Horizontal coordinate.
    public var x: Int

    /// Vertical coordinate.
    public var y: Int

    /// Creates an event point.
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

/// Platform-independent scalar value for event payloads.
public enum EventValue: Codable, Equatable, Sendable {
    /// String value.
    case string(String)

    /// Integer value.
    case integer(Int)

    /// Floating-point value.
    case double(Double)

    /// Boolean value.
    case bool(Bool)

    /// List of string values.
    case stringArray([String])

    /// Absence of a value.
    case none
}

/// Phase of an input event.
public enum InputPhase: String, Codable, Equatable, Sendable {
    /// Input began.
    case began

    /// Input changed.
    case changed

    /// Input was pressed or activated.
    case pressed

    /// Input was released.
    case released

    /// Input ended normally.
    case ended

    /// Input was cancelled.
    case cancelled
}

/// Platform-independent pointer button.
public enum PointerButton: String, Codable, Equatable, Sendable {
    /// Primary pointer button.
    case primary

    /// Secondary pointer button.
    case secondary

    /// Middle pointer button.
    case middle

    /// Other pointer button.
    case other
}

/// Keyboard or input modifiers attached to an event.
public struct EventModifiers: OptionSet, Codable, Equatable, Sendable {
    /// Raw bitset value for the modifiers.
    public let rawValue: Int

    /// Creates a modifier set from its raw bitset.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Shift modifier.
    public static let shift = EventModifiers(rawValue: 1 << 0)

    /// Control modifier.
    public static let control = EventModifiers(rawValue: 1 << 1)

    /// Option or Alt modifier.
    public static let option = EventModifiers(rawValue: 1 << 2)

    /// Command modifier.
    public static let command = EventModifiers(rawValue: 1 << 3)

    /// Function modifier.
    public static let function = EventModifiers(rawValue: 1 << 4)
}
