// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FeedKit",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .watchOS(.v8),
    .tvOS(.v15),
    .visionOS(.v1)
  ],
  products: [
    .library(
      name: "FeedKit",
      targets: [
        "FeedKit"
      ]
    ),
    .library(
      name: "XMLKit",
      targets: [
        "XMLKit"
      ]
    )
  ],
  targets: [
    .target(
      name: "XMLKit"
    ),
    .testTarget(
      name: "XMLKitTests",
      dependencies: ["XMLKit"],
      resources: [
        .process("Resources/xml/Sample.xml")
      ]
    ),
    .target(
      name: "FeedKit",
      dependencies: [
        "XMLKit"
      ]
    ),
    .testTarget(
      name: "FeedKitTests",
      dependencies: [
        "FeedKit"
      ],
      resources: [
        .process("Resources/json/feed.json"),
        .process("Resources/xml/Ampersand.xml"),
        .process("Resources/xml/Atom + XHTML.xml"),
        .process("Resources/xml/Atom.xml"),
        .process("Resources/xml/AtomMedia.xml"),
        .process("Resources/xml/Content.xml"),
        .process("Resources/xml/FeedNotFound.xml"),
        .process("Resources/xml/RSS.xml"),
        .process("Resources/xml/RSSDC.xml"),
        .process("Resources/xml/AtomDC.xml"),
        .process("Resources/xml/RSSAtom.xml"),
        .process("Resources/xml/Media.xml"),
        .process("Resources/xml/Syndication.xml"),
        .process("Resources/xml/iTunes.xml"),
        .process("Resources/xml/YouTube.xml")
      ]
    )
  ]
)
