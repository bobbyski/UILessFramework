import Testing
@testable import UILess

@Test func example() async throws {
    let runtime = UILessRuntime(application: ExampleApplication())
    let snapshot = try await runtime.start()

    #expect(snapshot.applicationID == "example")
    #expect(snapshot.currentFlow.steps.count == 1)
}

private struct ExampleApplication: UILessApplication {
    let id: ApplicationID = "example"
    let displayName = "Example"

    func initialFlow() async throws -> Flow {
        Flow(
            id: "hello",
            title: "Hello",
            steps: [
                FlowStep(
                    id: "start",
                    title: "Start",
                    role: .presentInformation
                ),
            ]
        )
    }
}
