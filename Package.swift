// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "FeedKit",
    products: [
        .library(name: "FeedKit", targets: ["FeedKit"]),
    ],
    targets: [
        .target(name: "FeedKit", dependencies: []),
    ]
)
