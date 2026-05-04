# UILessFramework

`UILessFramework` is the core Swift package for the UILess programming model.
The Swift module exported by the package is simply `UILess`.

The source folder intentionally does not end in `.framework`. That extension is
reserved for Apple framework bundles, and tools such as Xcode may treat such a
folder as a built framework instead of a Swift package.

## Initial Package Shape

- `UILess`: the platform-independent core library. It defines application,
  flow, step, resource, transition, snapshot, and runtime primitives.
- `UILessApplication`: a platform-independent executable target that proves a
  UILess application can start and produce a flow snapshot without depending on
  AppKit, UIKit, SwiftUI, or any other presentation framework.
- `UILessTests`: a small smoke-test target for the first runtime behavior. More
  focused test targets can be added as the framework boundaries become firmer.

## Proposed Framework Direction

The core framework should stay deliberately small and UI-neutral:

- Application definition: what the program is and what flow it starts with.
- Flow model: the user-visible progression through intent, state, resources,
  transitions, and completion.
- Resource model: abstract requirements such as text, choices, commands, and
  documents, without saying how a platform should render them.
- Runtime model: the coordinator that turns an application definition into a
  current snapshot and later manages events, state updates, and navigation.
- Adapter boundary: future platform frameworks can translate snapshots and
  resource requests into concrete UI idioms.

Likely later packages/frameworks:

- `UILessAdapters`: shared adapter protocols and conformance helpers.
- `UILessSwiftUI`: SwiftUI renderer.
- `UILessWeb`: HTML/browser renderer.
- `UILessCLI`: command-line renderer for early testing and automation.
- `UILessDesigner`: authoring and visualization tools for flows.

The important constraint is that platform frameworks depend on `UILess`, while
`UILess` depends on no platform framework.
