// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UILessFramework",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "UILess",
            targets: ["UILess"]
        ),
        .executable(
            name: "UILessApplication",
            targets: ["UILessApplication"]
        ),
    ],
    targets: [
        .target(
            name: "UILess"
        ),
        .executableTarget(
            name: "UILessApplication",
            dependencies: ["UILess"]
        ),
        .testTarget(
            name: "UILessTests",
            dependencies: ["UILess"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
