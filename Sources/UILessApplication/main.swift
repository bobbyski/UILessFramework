import Foundation
import UILess

@main
struct Main {
    static func main() async throws {
        let runtime = UILessRuntime(application: StarterApplication())
        let snapshot = try await runtime.start()
        let data = try JSONEncoder.uilessPrettyPrinted.encode(snapshot)

        FileHandle.standardOutput.write(data)
        FileHandle.standardOutput.write(Data("\n".utf8))
    }
}

private struct StarterApplication: UILessApplication {
    let id: ApplicationID = "uiless.starter"
    let displayName = "UILess Starter"

    func initialFlow() async throws -> Flow {
        Flow(
            id: "starter-flow",
            title: "Starter Flow",
            steps: [
                FlowStep(
                    id: "welcome",
                    title: "Welcome",
                    role: .presentInformation,
                    resources: [
                        ResourceRequest(
                            id: "message",
                            kind: .text,
                            purpose: "Describe the first platform-independent flow."
                        ),
                    ],
                    transitions: [
                        FlowTransition(title: "Continue", destination: "complete"),
                    ]
                ),
                FlowStep(
                    id: "complete",
                    title: "Complete",
                    role: .complete
                ),
            ]
        )
    }
}

private extension JSONEncoder {
    static var uilessPrettyPrinted: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
