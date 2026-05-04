public protocol UILessApplication: Sendable {
    var id: ApplicationID { get }
    var displayName: String { get }

    func initialFlow() async throws -> Flow
}

public struct ApplicationID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public struct FlowID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public struct StepID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public struct ResourceID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public struct Flow: Codable, Equatable, Sendable {
    public var id: FlowID
    public var title: String
    public var steps: [FlowStep]

    public init(id: FlowID, title: String, steps: [FlowStep]) {
        self.id = id
        self.title = title
        self.steps = steps
    }
}

public struct FlowStep: Codable, Equatable, Sendable {
    public var id: StepID
    public var title: String
    public var role: StepRole
    public var resources: [ResourceRequest]
    public var transitions: [FlowTransition]

    public init(
        id: StepID,
        title: String,
        role: StepRole,
        resources: [ResourceRequest] = [],
        transitions: [FlowTransition] = []
    ) {
        self.id = id
        self.title = title
        self.role = role
        self.resources = resources
        self.transitions = transitions
    }
}

public enum StepRole: String, Codable, Equatable, Sendable {
    case gatherInput
    case presentInformation
    case chooseAction
    case performWork
    case complete
}

public struct ResourceRequest: Codable, Equatable, Sendable {
    public var id: ResourceID
    public var kind: ResourceKind
    public var purpose: String

    public init(id: ResourceID, kind: ResourceKind, purpose: String) {
        self.id = id
        self.kind = kind
        self.purpose = purpose
    }
}

public enum ResourceKind: String, Codable, Equatable, Sendable {
    case text
    case number
    case choice
    case command
    case document
}

public struct FlowTransition: Codable, Equatable, Sendable {
    public var title: String
    public var destination: StepID

    public init(title: String, destination: StepID) {
        self.title = title
        self.destination = destination
    }
}

public struct ApplicationSnapshot: Codable, Equatable, Sendable {
    public var applicationID: ApplicationID
    public var displayName: String
    public var currentFlow: Flow

    public init(applicationID: ApplicationID, displayName: String, currentFlow: Flow) {
        self.applicationID = applicationID
        self.displayName = displayName
        self.currentFlow = currentFlow
    }
}

public struct UILessRuntime<Application: UILessApplication>: Sendable {
    public var application: Application

    public init(application: Application) {
        self.application = application
    }

    public func start() async throws -> ApplicationSnapshot {
        ApplicationSnapshot(
            applicationID: application.id,
            displayName: application.displayName,
            currentFlow: try await application.initialFlow()
        )
    }
}
