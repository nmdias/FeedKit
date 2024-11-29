// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FeedKit",
  products: [
    .library(
      name: "FeedKit",
      targets: ["FeedKit"]
    )
  ],
  targets: [
    .target(
      name: "FeedKit"
    ),
    .testTarget(
      name: "FeedKitTests",
      dependencies: ["FeedKit"],
      resources: [
        .process("Resources/Sample.xml"),
        .process("Resources/Atom.xml"),
        .process("Resources/Atom + XHTML.xml"),
        .process("Resources/RDF.xml"),
        .process("Resources/RSS.xml"),
        .process("Resources/json/feed.json"),
      ]
    ),
  ]
)
