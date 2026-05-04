import UILess

/// Starter macOS command-line TUI platform provider.
///
/// This provider establishes the framework boundary for the Phase I TUI target.
/// It does not import TermKit yet; the TermKit renderer and event bridge will be
/// added behind this provider boundary.
public struct MacTUIPlatformProvider: UILessPlatformProvider {
    /// Stable identity for the macOS TUI platform provider.
    public let id: PlatformID

    /// Human-readable platform provider name.
    public let displayName: String

    /// Creates a macOS TUI platform provider.
    ///
    /// - Parameters:
    ///   - id: Stable identity for the provider.
    ///   - displayName: Human-readable provider name.
    public init(
        id: PlatformID = "mac.tui",
        displayName: String = "macOS Terminal UI"
    ) {
        self.id = id
        self.displayName = displayName
    }

    /// Starts a UILess application for the macOS TUI platform.
    ///
    /// - Parameters:
    ///   - application: Platform-independent application being launched.
    ///   - runtime: Runtime used to produce the first snapshot.
    ///   - dependencies: Dependency provider available to the platform.
    /// - Returns: The first application snapshot.
    /// - Throws: Any error thrown by the runtime.
    public func start(
        application: any UILessApplication,
        runtime: any UILessRuntimeProtocol,
        dependencies: any UILessDependencyProviding
    ) async throws -> ApplicationSnapshot {
        try await runtime.start()
    }
}
