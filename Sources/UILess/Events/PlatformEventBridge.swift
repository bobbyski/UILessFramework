/// Translates between native platform events and core UILess events.
///
/// Each platform support framework should provide one or more bridges so the
/// core runtime never needs to import platform-specific UI or input libraries.
public protocol PlatformEventBridge: UILessObject {
    /// Native event type used by the platform framework.
    associatedtype NativeEvent: Sendable

    /// Identity of the platform this bridge represents.
    var platformID: PlatformID { get }

    /// Converts one native platform event into zero or more UILess events.
    ///
    /// - Parameter nativeEvent: Platform-specific event to translate.
    /// - Returns: Zero or more platform-independent events.
    /// - Throws: `EventBridgeError` or another bridge-specific error.
    func decode(_ nativeEvent: NativeEvent) async throws -> [UILessEvent]

    /// Converts a UILess event into zero or more native platform events.
    ///
    /// - Parameter event: Platform-independent event to translate.
    /// - Returns: Zero or more platform-specific events.
    /// - Throws: `EventBridgeError` or another bridge-specific error.
    func encode(_ event: UILessEvent) async throws -> [NativeEvent]
}

/// Receives core UILess events from a platform event source.
public protocol PlatformEventSink: UILessObject {
    /// Receives one platform-independent event.
    ///
    /// - Parameter event: Event received from a platform source.
    /// - Throws: Any error produced while handling the event.
    func receive(_ event: UILessEvent) async throws
}

/// Platform object capable of forwarding native events into a UILess sink.
public protocol PlatformEventSource: UILessObject {
    /// Native event type used by the event source.
    associatedtype NativeEvent: Sendable

    /// Bridge that translates the native event type.
    associatedtype Bridge: PlatformEventBridge where Bridge.NativeEvent == NativeEvent

    /// Bridge used by this source.
    var eventBridge: Bridge { get }

    /// Starts forwarding native platform events to a UILess event sink.
    ///
    /// - Parameter sink: Receiver for decoded UILess events.
    /// - Throws: Any error produced while connecting or forwarding events.
    func startForwardingEvents(to sink: any PlatformEventSink) async throws
}

/// Errors produced by a platform event bridge.
public enum EventBridgeError: Error, Equatable, UILessObject {
    /// The bridge cannot represent the native event.
    case unsupportedNativeEvent(String)

    /// The bridge cannot represent the UILess event as a native event.
    case unsupportedUILessEvent(EventType)

    /// A required event target was absent.
    case missingTarget
}
