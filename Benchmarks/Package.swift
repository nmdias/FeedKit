// swift-tools-version: 6.0
//
// This is a separate, 25-line SwiftPM package whose only job is to let one
// benchmark file be compiled against ANY FeedKit checkout — the one you are
// standing in, or an old release tag.
//
// The library under test is selected by FEEDKIT_PATH. bench.sh sets it.
//
import Foundation
import PackageDescription

guard let feedKitPath = ProcessInfo.processInfo.environment["FEEDKIT_PATH"], !feedKitPath.isEmpty else {
  fatalError("""
  Set FEEDKIT_PATH to the FeedKit checkout to measure, e.g.
      FEEDKIT_PATH="$(git rev-parse --show-toplevel)" swift build -c release
  bench.sh does this for you.
  """)
}

let package = Package(
  name: "FeedKitBenchmark",
  platforms: [
    .macOS(.v13) // ContinuousClock, used for monotonic timing.
  ],
  dependencies: [
    .package(name: "FeedKit", path: feedKitPath)
  ],
  targets: [
    .executableTarget(
      name: "bench",
      dependencies: [
        .product(name: "FeedKit", package: "FeedKit")
      ],
      path: "Sources/bench",
      swiftSettings: [
        .swiftLanguageMode(.v5) // A measurement tool; no concurrency ceremony.
      ]
    )
  ]
)
