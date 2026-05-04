import Testing
@testable import UILess

@Test func emptyFlowIsWarningInPermissiveMode() throws {
    let flow = Flow(id: "empty", title: "Empty", steps: [])
    let result = UILessValidator().validate(flow, mode: .permissive)

    #expect(result.isSuccessful)
    #expect(result.issues.count == 1)
    #expect(result.issues.first?.severity == .warning)
    #expect(result.issues.first?.ruleID == "flow.steps.empty")
}

@Test func emptyFlowIsErrorInStrictMode() throws {
    let flow = Flow(id: "empty", title: "Empty", steps: [])
    let result = UILessValidator().validate(flow, mode: .strict)

    #expect(!result.isSuccessful)
    #expect(result.issues.count == 1)
    #expect(result.issues.first?.severity == .error)
    #expect(result.issues.first?.ruleID == "flow.steps.empty")
}

@Test func validationOffSkipsIssues() throws {
    let flow = Flow(id: "empty", title: "", steps: [])
    let result = UILessValidator().validate(flow, mode: .off)

    #expect(result.isSuccessful)
    #expect(result.issues.isEmpty)
}

@Test func lightModeDetectsMissingTransitionDestination() throws {
    let flow = Flow(
        id: "broken",
        title: "Broken",
        steps: [
            FlowStep(
                id: "start",
                title: "Start",
                role: .chooseAction,
                transitions: [
                    FlowTransition(title: "Missing", destination: "missing"),
                ]
            ),
        ]
    )

    let result = UILessValidator().validate(flow, mode: .light)

    #expect(!result.isSuccessful)
    #expect(result.issues.map(\.ruleID).contains("flow.transition.destination.missing"))
}

@Test func permissiveModeSkipsStructuralTransitionChecks() throws {
    let flow = Flow(
        id: "draft",
        title: "Draft",
        steps: [
            FlowStep(
                id: "start",
                title: "Start",
                role: .chooseAction,
                transitions: [
                    FlowTransition(title: "Missing", destination: "missing"),
                ]
            ),
        ]
    )

    let result = UILessValidator().validate(flow, mode: .permissive)

    #expect(result.isSuccessful)
    #expect(result.issues.isEmpty)
}
