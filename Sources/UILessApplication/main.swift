import Foundation
import UILess
import UILessMacTUI

@main
struct Main {
    static func main() async throws {
        let dependencies = UILessDependencyContainer()
        await dependencies.register((any UILessApplication).self, value: StarterApplication())
        await dependencies.register((any UILessPlatformProvider).self, value: MacTUIPlatformProvider())

        let startup = UILessStartup(dependencies: dependencies)
        let snapshot = try await startup.start()
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
