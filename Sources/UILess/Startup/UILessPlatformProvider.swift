/// Platform support capable of launching and presenting a UILess application.
public protocol UILessPlatformProvider: UILessObject {
    /// Stable identity for this platform provider.
    var id: PlatformID { get }

    /// Human-readable platform provider name.
    var displayName: String { get }

    /// Starts a UILess application on this platform.
    ///
    /// - Parameters:
    ///   - application: Platform-independent application being launched.
    ///   - runtime: Runtime capability for producing snapshots and handling future state.
    ///   - dependencies: Dependency provider available to the platform.
    /// - Returns: The first platform-independent snapshot produced during startup.
    /// - Throws: Any startup or platform presentation error.
    func start(
        application: any UILessApplication,
        runtime: any UILessRuntimeProtocol,
        dependencies: any UILessDependencyProviding
    ) async throws -> ApplicationSnapshot
}

/// Coordinates dependency-driven UILess application startup.
public struct UILessStartup: UILessObject {
    /// Dependencies used to resolve the application and platform provider.
    public var dependencies: any UILessDependencyProviding

    /// Creates a startup coordinator.
    ///
    /// - Parameter dependencies: Dependency provider containing startup registrations.
    public init(dependencies: any UILessDependencyProviding) {
        self.dependencies = dependencies
    }

    /// Resolves the application and platform provider, then starts the platform.
    ///
    /// - Returns: The first snapshot produced by platform startup.
    /// - Throws: Dependency resolution, runtime, or platform startup errors.
    public func start() async throws -> ApplicationSnapshot {
        let application = try await dependencies.resolve((any UILessApplication).self)
        let platformProvider = try await dependencies.resolve((any UILessPlatformProvider).self)
        let runtime = UILessRuntime(application: application)

        return try await platformProvider.start(
            application: application,
            runtime: runtime,
            dependencies: dependencies
        )
    }
}
