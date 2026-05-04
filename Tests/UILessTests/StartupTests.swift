import Testing
@testable import UILess

@Test func startupResolvesApplicationAndPlatformFromDependencies() async throws {
    let dependencies = UILessDependencyContainer()
    await dependencies.register((any UILessApplication).self, value: StartupTestApplication())
    await dependencies.register((any UILessPlatformProvider).self, value: StartupTestPlatformProvider())

    let startup = UILessStartup(dependencies: dependencies)
    let snapshot = try await startup.start()

    #expect(snapshot.applicationID == "startup.test")
    #expect(snapshot.displayName == "Startup Test")
    #expect(snapshot.currentFlow.id == "startup")
}

@Test func dependencyContainerReportsMissingDependencies() async throws {
    let dependencies = UILessDependencyContainer()

    await #expect(throws: UILessDependencyError.missing("String")) {
        try await dependencies.resolve(String.self)
    }
}

private struct StartupTestApplication: UILessApplication {
    let id: ApplicationID = "startup.test"
    let displayName = "Startup Test"

    func initialFlow() async throws -> Flow {
        Flow(
            id: "startup",
            title: "Startup",
            steps: [
                FlowStep(
                    id: "first",
                    title: "First",
                    role: .presentInformation
                ),
            ]
        )
    }
}

private struct StartupTestPlatformProvider: UILessPlatformProvider {
    let id: PlatformID = "test.platform"
    let displayName = "Test Platform"

    func start(
        application: any UILessApplication,
        runtime: any UILessRuntimeProtocol,
        dependencies: any UILessDependencyProviding
    ) async throws -> ApplicationSnapshot {
        try await runtime.start()
    }
}
