/// Supplies dependencies to UILess components without coupling them to concrete types.
public protocol UILessDependencyProviding: UILessObject {
    /// Resolves a registered dependency by type.
    ///
    /// - Parameter type: Dependency type to resolve.
    /// - Returns: The registered dependency value.
    /// - Throws: `UILessDependencyError` if the dependency is missing or registered with an incompatible type.
    func resolve<Value: Sendable>(_ type: Value.Type) async throws -> Value
}

/// Typed dependency container for application startup and platform providers.
public actor UILessDependencyContainer: UILessDependencyProviding {
    private var registrations: [ObjectIdentifier: @Sendable () async throws -> any Sendable] = [:]

    /// Creates an empty dependency container.
    public init() {}

    /// Registers a dependency value by type.
    ///
    /// - Parameters:
    ///   - type: Type key used to resolve the value later.
    ///   - value: Value to register.
    public func register<Value: Sendable>(_ type: Value.Type = Value.self, value: Value) {
        registrations[ObjectIdentifier(type)] = { value }
    }

    /// Registers a dependency factory by type.
    ///
    /// - Parameters:
    ///   - type: Type key used to resolve the value later.
    ///   - factory: Factory invoked each time the dependency is resolved.
    public func register<Value: Sendable>(
        _ type: Value.Type = Value.self,
        factory: @escaping @Sendable () async throws -> Value
    ) {
        registrations[ObjectIdentifier(type)] = factory
    }

    /// Resolves a registered dependency by type.
    ///
    /// - Parameter type: Dependency type to resolve.
    /// - Returns: The registered dependency value.
    /// - Throws: `UILessDependencyError.missing` or `UILessDependencyError.typeMismatch`.
    public func resolve<Value: Sendable>(_ type: Value.Type = Value.self) async throws -> Value {
        guard let registration = registrations[ObjectIdentifier(type)] else {
            throw UILessDependencyError.missing(String(describing: type))
        }

        let value = try await registration()

        guard let typedValue = value as? Value else {
            throw UILessDependencyError.typeMismatch(String(describing: type))
        }

        return typedValue
    }
}

/// Dependency resolution failures.
public enum UILessDependencyError: Error, Equatable, Sendable {
    /// No value or factory was registered for the requested type.
    case missing(String)

    /// A value was registered under the requested key but could not be cast to the requested type.
    case typeMismatch(String)
}
