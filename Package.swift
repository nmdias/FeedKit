// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v12),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "FeedKit", targets: ["FeedKit"]),
    ],
    targets: [
        .target(name: "FeedKit", dependencies: []),
        .testTarget(name: "Tests", dependencies: ["FeedKit"], path: "Tests")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
