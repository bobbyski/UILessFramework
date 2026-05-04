public protocol PlatformEventBridge: Sendable {
    associatedtype NativeEvent: Sendable

    var platformID: PlatformID { get }

    func decode(_ nativeEvent: NativeEvent) async throws -> [UILessEvent]
    func encode(_ event: UILessEvent) async throws -> [NativeEvent]
}

public protocol PlatformEventSink: Sendable {
    func receive(_ event: UILessEvent) async throws
}

public protocol PlatformEventSource: Sendable {
    associatedtype NativeEvent: Sendable
    associatedtype Bridge: PlatformEventBridge where Bridge.NativeEvent == NativeEvent

    var eventBridge: Bridge { get }

    func startForwardingEvents(to sink: any PlatformEventSink) async throws
}

public enum EventBridgeError: Error, Equatable, Sendable {
    case unsupportedNativeEvent(String)
    case unsupportedUILessEvent(EventType)
    case missingTarget
}
