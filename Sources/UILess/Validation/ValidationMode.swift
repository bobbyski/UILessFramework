/// Controls how much validation the framework performs.
public enum ValidationMode: String, Codable, CaseIterable, UILessObject {
    /// Maximum validation, intended for debug builds and development tooling.
    case strict

    /// Lower-cost validation, intended for alpha and beta builds.
    case light

    /// Non-blocking validation, intended for release builds.
    case permissive

    /// Validation disabled.
    ///
    /// This should be reserved for special-case tests or performance experiments.
    case off

    /// Default validation mode for the current build configuration.
    public static var defaultMode: ValidationMode {
        #if DEBUG
        .strict
        #else
        .permissive
        #endif
    }
}
