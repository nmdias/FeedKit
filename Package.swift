// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swift-feeds",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "Feeds",
            targets: ["Feeds"]
        ),
    ],
    targets: [
        .target(
            name: "Feeds",
            dependencies: []
        ),
        .testTarget(
            name: "FeedsTests",
            dependencies: ["Feeds"],
            resources: [.process("json"), .process("xml")]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
