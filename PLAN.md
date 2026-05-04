# UILess Framework Plan

This is the living implementation checklist for the UILess core framework.

## Big Picture Goals

UILess is intended to become a family of Swift frameworks for building
platform-independent programs with platform-specific runtime support.

The user should be able to create one platform-independent program, then build
that program through separate targets for each supported platform.

The framework family should be structured around:

- [ ] A core shared framework that defines the platform-independent programming
      model.
- [ ] A supporting framework for each platform or platform family.
- [ ] Application targets that combine the shared program with the appropriate
      platform framework.
- [ ] Tooling that eventually helps users customize and author UI behavior
      without losing platform independence.

## Framework Family

- [ ] `UILess`: shared core framework.
- [ ] `UILessMacCLI`: macOS command-line platform support using a TUI
      presentation approach.
- [ ] `UILessMacGUI`: macOS graphical platform support.
- [ ] `UILessiOS`: iOS and iPadOS platform support.
- [ ] `UILessCarPlay`: CarPlay platform support.
- [ ] `UILessMacAudio`: macOS audio-only platform support.
- [ ] `UILessiOSAudio`: iOS audio-only platform support.
- [ ] `UILessVisionOS`: visionOS platform support.
- [ ] `UILessTVOS`: tvOS platform support.
- [ ] Future Windows command-line support framework.
- [ ] Future Linux command-line support framework.
- [ ] Future Linux/Pi platform support framework.
- [ ] Future Windows GUI/platform support framework.
- [ ] Future stand-alone UI customization tool.
- [ ] Future OmegaIDE integration.

Names are provisional. We can rename these once the platform boundaries are
clearer.

## Phases

- [ ] Phase I: macOS command-line TUI, macOS GUI, and iOS/iPadOS visual
      targets.
- [ ] Phase II: Windows command line and Linux command line.
- [ ] Phase III: CarPlay plus macOS and iOS audio-only targets.
- [ ] Phase IV: visionOS and tvOS.
- [ ] Phase V: Linux/Pi support.
- [ ] Phase VI: Windows support.
- [ ] Phase VII: stand-alone UI customization tools app.
- [ ] Phase VIII: integrate the UI customization tools into OmegaIDE.

## Milestone 1

- [ ] Get every Phase I target to start up.
- [ ] Present a first view in every Phase I target.
- [ ] Present the macOS command-line target through a TUI.
- [ ] Keep the shared application program platform-independent.
- [ ] Keep unit tests current as each core feature is added.
- [ ] Defer UI tests until later phases when the visual target structure is
      stable enough to test meaningfully.

## Design Principles

- [ ] Keep application logic platform-independent by default.
- [ ] Keep the public authoring interface easy to use, with as little
      boilerplate as possible.
- [ ] Prefer protocol-defined capabilities and reference them through protocols
      wherever there may be multiple implementations.
- [ ] Keep concrete classes, structs, actors, and platform adapters independent
      from one another by depending on protocols at framework boundaries.
- [ ] Keep the core framework free of AppKit, UIKit, SwiftUI, visionOS, tvOS,
      Windows, and Linux UI dependencies.
- [ ] Put platform-specific idioms behind supporting frameworks.
- [ ] Make visual, command-line, and audio-only targets first-class platform
      idioms.
- [ ] Let the implementation evolve piece by piece as terminology and constructs
      become clearer.

## Current Structure

- [x] Create `Code/UILessFramework` as the core Swift package.
- [x] Export the platform-independent `UILess` library product.
- [x] Add a platform-independent `UILessApplication` executable target.
- [x] Set the minimum package platform to macOS 15.
- [x] Add the first smoke test target.
- [x] Add core logging primitives with routed destinations.
- [x] Add core event primitives and platform event bridge protocols.
- [x] Add typed dependency injection container.
- [x] Add platform provider startup boundary.
- [x] Add initial macOS TUI framework target.

## Core Framework Checklist

- [x] Define initial application, flow, step, resource, transition, snapshot, and runtime primitives.
- [x] Define initial logging framework.
- [x] Define initial platform-independent event framework.
- [x] Define initial dependency injection and startup framework.
- [x] Define initial validation framework.
- [ ] Refine terminology against the research documents.
- [ ] Decide what belongs in the core versus future adapter frameworks.
- [ ] Define the event model for user intent and system-driven changes.
- [ ] Define state storage and mutation rules.
- [x] Define validation and error reporting primitives.
- [ ] Define serialization format guarantees for flows and snapshots.

## Platform Independence Checklist

- [x] Keep the core free of AppKit, UIKit, SwiftUI, and platform UI dependencies.
- [ ] Create adapter protocol boundaries for renderers.
- [x] Create adapter protocol boundaries for platform events.
- [ ] Add a CLI renderer for early flow testing.
- [ ] Add a SwiftUI renderer after the core flow/event model settles.
- [ ] Add Apple app packaging strategy for future App Store builds.

## Tests Checklist

- [x] Add a basic runtime smoke test.
- [ ] Maintain unit tests continuously as implementation grows.
- [ ] Add focused tests for flow construction.
- [ ] Add focused tests for resource requests.
- [ ] Add focused tests for transitions.
- [ ] Add focused tests for runtime snapshots.
- [ ] Split test targets by subsystem as the framework grows.
- [ ] Add UI tests in later phases after visual platform targets stabilize.

## Documentation Checklist

- [x] Add initial package README.
- [x] Add this planning checklist.
- [x] Add documentation comments to the initial public API surface.
- [ ] Maintain documentation comments for all public and framework-facing APIs.
- [ ] Add internal comments for unusual, complex, or non-obvious implementation details.
- [ ] Summarize architecture ideas from the `Documents` folder.
- [ ] Write glossary for core UILess terms.
- [ ] Document package and future framework boundaries.

## Near-Term Discussion

- [ ] Clarify whether "Flow" or "Workflow" should be the public API term.
- [ ] Clarify the smallest complete UILess application lifecycle.
- [ ] Clarify what a "resource" means in the core model.
- [ ] Clarify how platform-specific idioms should be selected.
- [ ] Clarify whether flows are authored in Swift, data files, a designer tool, or all three.
