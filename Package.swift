// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FeedKit",
  products: [
    .library(
      name: "FeedKit",
      targets: ["FeedKit"]
    ),
    .library(
      name: "XMLKit",
      targets: ["XMLKit"]
    ),
  ],
  targets: [
    .target(
      name: "FeedKit",
      dependencies: [
        "XMLKit",
      ]
    ),
    .target(
      name: "XMLKit",
      dependencies: []
    ),
    .testTarget(
      name: "FeedKitTests",
      dependencies: ["FeedKit"]
    ),
    .testTarget(
      name: "XMLKitTests",
      dependencies: ["XMLKit"],
      resources: [
        .process("Resources/XML.xml"),
      ]
    ),
  ]
)
