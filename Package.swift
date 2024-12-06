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
        .process("Resources/json/feed.json"),
        .process("Resources/xml/Ampersand.xml"),
        .process("Resources/xml/Atom + XHTML.xml"),
        .process("Resources/xml/Atom.xml"),
        .process("Resources/xml/AtomMedia.xml"),
        .process("Resources/xml/Content.xml"),
        .process("Resources/xml/FeedNotFound.xml"),
        .process("Resources/xml/RDF.xml"),
        .process("Resources/xml/RDFDC.xml"),
        .process("Resources/xml/RSS.xml"),
        .process("Resources/xml/RSSDC.xml"),
        .process("Resources/xml/RSSMedia.xml"),
        .process("Resources/xml/Sample.xml"),
        .process("Resources/xml/Syndication.xml"),
        .process("Resources/xml/iTunesPodcast.xml"),
      ]
    ),
  ]
)
