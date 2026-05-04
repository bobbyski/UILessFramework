import Foundation
import Testing
@testable import UILess

@Test func bridgeDecodesNativeEventIntoUILessEvent() async throws {
    let bridge = StringEventBridge()
    let events = try await bridge.decode("key:return")

    #expect(events.count == 1)
    #expect(events.first?.source == "test")
    #expect(events.first?.type == .keyboard)
    #expect(events.first?.payload == .keyboard(KeyboardEvent(key: "return")))
}

@Test func bridgeEncodesUILessEventIntoNativeEvent() async throws {
    let bridge = StringEventBridge()
    let event = UILessEvent(
        source: "test",
        type: .command,
        target: .resource("save"),
        payload: .command(CommandEvent(command: "save"))
    )

    let nativeEvents = try await bridge.encode(event)

    #expect(nativeEvents == ["command:save"])
}

@Test func eventModifiersAreCodable() throws {
    let modifiers: EventModifiers = [.shift, .control]
    let data = try JSONEncoder().encode(modifiers)
    let decoded = try JSONDecoder().decode(EventModifiers.self, from: data)

    #expect(decoded == modifiers)
}

private struct StringEventBridge: PlatformEventBridge {
    let platformID: PlatformID = "test"

    func decode(_ nativeEvent: String) async throws -> [UILessEvent] {
        if nativeEvent.hasPrefix("key:") {
            let key = String(nativeEvent.dropFirst("key:".count))
            return [
                UILessEvent(
                    source: platformID,
                    type: .keyboard,
                    payload: .keyboard(KeyboardEvent(key: key))
                ),
            ]
        }

        throw EventBridgeError.unsupportedNativeEvent(nativeEvent)
    }

    func encode(_ event: UILessEvent) async throws -> [String] {
        switch event.payload {
        case .command(let command):
            return ["command:\(command.command)"]
        case .keyboard(let keyboard):
            return ["key:\(keyboard.key)"]
        default:
            throw EventBridgeError.unsupportedUILessEvent(event.type)
        }
    }
}
