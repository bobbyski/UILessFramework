/// Marker protocol for UILess framework components.
///
/// UILess uses this as a lightweight common ancestor for core components,
/// platform providers, services, and framework extension points. It intentionally
/// has no requirements so each concrete implementation can stay independent.
public protocol UILessObject: Sendable {}
