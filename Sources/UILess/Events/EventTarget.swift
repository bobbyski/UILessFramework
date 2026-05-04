public enum EventTarget: Codable, Equatable, Sendable {
    case application(ApplicationID)
    case flow(FlowID)
    case step(StepID)
    case resource(ResourceID)
    case platform(PlatformID)
    case none
}
