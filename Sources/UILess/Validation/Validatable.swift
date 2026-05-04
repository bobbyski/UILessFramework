/// Component that can validate itself.
public protocol Validatable: UILessObject {
    /// Validates the component for a mode.
    ///
    /// - Parameter mode: Validation mode to apply.
    /// - Returns: Validation issues found by the component.
    func validate(mode: ValidationMode) -> [ValidationIssue]
}

/// Service that validates components.
public protocol Validator: UILessObject {
    /// Validates one component.
    ///
    /// - Parameters:
    ///   - component: Component to validate.
    ///   - mode: Validation mode to apply.
    /// - Returns: Validation result.
    func validate(_ component: any Validatable, mode: ValidationMode) -> ValidationResult
}

/// Default validator for UILess components.
public struct UILessValidator: Validator {
    /// Creates a validator.
    public init() {}

    /// Validates one component.
    ///
    /// - Parameters:
    ///   - component: Component to validate.
    ///   - mode: Validation mode to apply.
    /// - Returns: Validation result.
    public func validate(_ component: any Validatable, mode: ValidationMode = .defaultMode) -> ValidationResult {
        guard mode != .off else {
            return ValidationResult(mode: mode)
        }

        return ValidationResult(mode: mode, issues: component.validate(mode: mode))
    }
}

/// Error thrown when validation fails in a mode that treats issues as blocking.
public struct ValidationError: Error, Equatable, UILessObject {
    /// Validation result that failed.
    public var result: ValidationResult

    /// Creates a validation error.
    ///
    /// - Parameter result: Validation result that failed.
    public init(result: ValidationResult) {
        self.result = result
    }
}
