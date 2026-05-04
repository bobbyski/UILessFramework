# UILess Validation Sketch

This document captures the first validation/contract design for review.

## Goals

- Keep validation protocol-based.
- Allow strict validation during development.
- Allow lighter validation during alpha/beta builds.
- Allow permissive validation in release builds.
- Keep an `off` mode for special tests and performance experiments only.
- Avoid making authoring painful while still catching likely mistakes.

## Modes

```swift
public enum ValidationMode {
    case strict
    case light
    case permissive
    case off
}
```

Suggested intent:

- `strict`: debug and tooling. Treat suspicious model states as blocking errors.
- `light`: alpha/beta. Run important structural checks, but avoid expensive or noisy validation.
- `permissive`: release. Continue whenever possible and use warnings for suspicious but recoverable states.
- `off`: special test/performance cases. Should not be the normal app mode.

## Protocol Shape

```swift
public protocol Validatable: UILessObject {
    func validate(mode: ValidationMode) -> [ValidationIssue]
}

public protocol Validator: UILessObject {
    func validate(_ component: any Validatable, mode: ValidationMode) -> ValidationResult
}
```

The component owns its local rules. The validator owns how validation is invoked
and can later add logging, strict failure, recursive validation, or aggregation.

## Current Example

```swift
let flow = Flow(id: "draft", title: "Draft", steps: [])
let result = UILessValidator().validate(flow, mode: .permissive)

for issue in result.issues {
    print("\(issue.severity): \(issue.message)")
}
```

Current behavior for an empty flow:

- `strict`: error
- `light`: warning
- `permissive`: warning
- `off`: no issue

The runtime can still treat an empty flow as immediately complete. Validation
lets build modes decide whether that is acceptable.

## Possible Startup Usage

```swift
let validator = UILessValidator()
let flow = try await application.initialFlow()
let result = validator.validate(flow, mode: .defaultMode)

if !result.isSuccessful {
    throw ValidationError(result: result)
}
```

We may choose to make this automatic in `UILessRuntime`, or keep it explicit
until the startup model settles.

## Open Questions

- Should `light` treat empty flows as warnings or errors?
- Should `permissive` log warnings automatically, or only return issues?
- Should `strict` throw directly, or should throwing be a separate policy layer?
- Should validation recurse automatically through flows, steps, resources, and transitions?
- Should expensive validations use compile flags in addition to runtime modes?
