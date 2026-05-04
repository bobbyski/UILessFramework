/// A platform-independent UILess program definition.
///
/// Platform targets wrap one `UILessApplication` and render its flows through a
/// platform support framework such as a TUI, macOS GUI, iOS app, or audio target.
public protocol UILessApplication: Sendable {
    /// Stable identity for this application.
    var id: ApplicationID { get }

    /// Human-readable application name for platform shells and diagnostics.
    var displayName: String { get }

    /// Creates the first flow the runtime should present when the app starts.
    ///
    /// - Returns: The initial platform-independent flow.
    /// - Throws: Any error that prevents the application from producing its initial flow.
    func initialFlow() async throws -> Flow
}

/// Stable identity for a UILess application.
public struct ApplicationID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable identifier value.
    public let rawValue: String

    /// Creates an application identity.
    ///
    /// - Parameter rawValue: Stable string value for the identity.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates an application identity from a string literal.
    ///
    /// - Parameter value: Stable string value for the identity.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Stable identity for a flow.
public struct FlowID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable identifier value.
    public let rawValue: String

    /// Creates a flow identity.
    ///
    /// - Parameter rawValue: Stable string value for the identity.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a flow identity from a string literal.
    ///
    /// - Parameter value: Stable string value for the identity.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Stable identity for a step within a flow.
public struct StepID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable identifier value.
    public let rawValue: String

    /// Creates a step identity.
    ///
    /// - Parameter rawValue: Stable string value for the identity.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a step identity from a string literal.
    ///
    /// - Parameter value: Stable string value for the identity.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Stable identity for a resource request.
public struct ResourceID: Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    /// The underlying stable identifier value.
    public let rawValue: String

    /// Creates a resource identity.
    ///
    /// - Parameter rawValue: Stable string value for the identity.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a resource identity from a string literal.
    ///
    /// - Parameter value: Stable string value for the identity.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// A platform-independent description of user progression through work.
public struct Flow: Codable, Equatable, Sendable {
    /// Stable identity for the flow.
    public var id: FlowID

    /// Human-readable title for the flow.
    public var title: String

    /// Ordered steps that make up this flow.
    public var steps: [FlowStep]

    /// Creates a flow.
    ///
    /// - Parameters:
    ///   - id: Stable identity for the flow.
    ///   - title: Human-readable title for the flow.
    ///   - steps: Ordered steps that make up the flow.
    public init(id: FlowID, title: String, steps: [FlowStep]) {
        self.id = id
        self.title = title
        self.steps = steps
    }
}

/// One meaningful step in a flow.
public struct FlowStep: Codable, Equatable, Sendable {
    /// Stable identity for the step.
    public var id: StepID

    /// Human-readable title for the step.
    public var title: String

    /// The broad semantic role this step plays in the flow.
    public var role: StepRole

    /// Abstract resources this step needs from the platform or user.
    public var resources: [ResourceRequest]

    /// Available transitions from this step to other steps.
    public var transitions: [FlowTransition]

    /// Creates a flow step.
    ///
    /// - Parameters:
    ///   - id: Stable identity for the step.
    ///   - title: Human-readable title for the step.
    ///   - role: Semantic role the step plays in the flow.
    ///   - resources: Abstract resources this step needs.
    ///   - transitions: Available transitions from this step.
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

/// Semantic role for a flow step.
public enum StepRole: String, Codable, Equatable, Sendable {
    /// The step gathers information from the user or platform.
    case gatherInput

    /// The step presents information without requiring input.
    case presentInformation

    /// The step asks the user or platform to choose a next action.
    case chooseAction

    /// The step performs work.
    case performWork

    /// The step represents completion of a flow.
    case complete
}

/// A platform-independent request for something a step needs.
public struct ResourceRequest: Codable, Equatable, Sendable {
    /// Stable identity for the requested resource.
    public var id: ResourceID

    /// The broad kind of resource being requested.
    public var kind: ResourceKind

    /// Human-readable explanation of why this resource is needed.
    public var purpose: String

    /// Creates a resource request.
    ///
    /// - Parameters:
    ///   - id: Stable identity for the requested resource.
    ///   - kind: Broad kind of resource being requested.
    ///   - purpose: Human-readable explanation of why the resource is needed.
    public init(id: ResourceID, kind: ResourceKind, purpose: String) {
        self.id = id
        self.kind = kind
        self.purpose = purpose
    }
}

/// Broad resource kinds the core can ask platforms to represent.
public enum ResourceKind: String, Codable, Equatable, Sendable {
    /// Textual content or input.
    case text

    /// Numeric content or input.
    case number

    /// A choice from one or more options.
    case choice

    /// A command or action the user can trigger.
    case command

    /// A document-like resource.
    case document
}

/// A possible move from one step to another.
public struct FlowTransition: Codable, Equatable, Sendable {
    /// Human-readable transition title.
    public var title: String

    /// Destination step for this transition.
    public var destination: StepID

    /// Creates a flow transition.
    ///
    /// - Parameters:
    ///   - title: Human-readable title for the transition.
    ///   - destination: Destination step for the transition.
    public init(title: String, destination: StepID) {
        self.title = title
        self.destination = destination
    }
}

/// The current platform-independent state a platform target can render.
public struct ApplicationSnapshot: Codable, Equatable, Sendable {
    /// Identity of the application that produced this snapshot.
    public var applicationID: ApplicationID

    /// Human-readable application name.
    public var displayName: String

    /// The flow currently being presented.
    public var currentFlow: Flow

    /// Creates an application snapshot.
    ///
    /// - Parameters:
    ///   - applicationID: Identity of the application that produced the snapshot.
    ///   - displayName: Human-readable application name.
    ///   - currentFlow: Flow currently being presented.
    public init(applicationID: ApplicationID, displayName: String, currentFlow: Flow) {
        self.applicationID = applicationID
        self.displayName = displayName
        self.currentFlow = currentFlow
    }
}

/// Minimal runtime coordinator for a UILess application.
public struct UILessRuntime<Application: UILessApplication>: Sendable {
    /// The application definition being run.
    public var application: Application

    /// Creates a runtime for an application.
    ///
    /// - Parameter application: Application definition to run.
    public init(application: Application) {
        self.application = application
    }

    /// Starts the application and returns the first renderable snapshot.
    ///
    /// - Returns: The first platform-independent snapshot.
    /// - Throws: Any error thrown while creating the application's initial flow.
    public func start() async throws -> ApplicationSnapshot {
        ApplicationSnapshot(
            applicationID: application.id,
            displayName: application.displayName,
            currentFlow: try await application.initialFlow()
        )
    }
}
