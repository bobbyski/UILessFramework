/// Platform-independent target for an event.
public enum EventTarget: Codable, Equatable, UILessObject {
    /// Event targets the application as a whole.
    case application(ApplicationID)

    /// Event targets a flow.
    case flow(FlowID)

    /// Event targets a step.
    case step(StepID)

    /// Event targets a resource.
    case resource(ResourceID)

    /// Event targets a platform adapter.
    case platform(PlatformID)

    /// Event has no specific target.
    case none
}
