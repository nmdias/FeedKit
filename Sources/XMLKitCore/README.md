# XMLKitCore

The XML engine that backs the `XMLKit` product: tokenizer, parser, document
model, namespace resolution, serialiser and a modern `Codable` bridge.

## Provenance

Every file in this directory except `FeedKitDeploymentCompatibility.swift` is
copied **verbatim** from the standalone XMLKit project, `Sources/XMLKit/`. It is
vendored rather than depended upon so that FeedKit keeps its zero-dependency
manifest, and it is a separate target rather than part of `XMLKit` so that its
types — which are named `XMLDocument`, `XMLElement`, `XMLDecoder` and
`XMLEncoder`, exactly like the ones `XMLKit` publishes — cannot collide with the
compatibility surface FeedKit's public API promises.

The target is not a product: it is an implementation detail of `XMLKit`, and
nothing outside the package can import it.

## Updating

1. Copy `Sources/XMLKit/**` from the upstream project over this directory.
2. Re-apply nothing: `FeedKitDeploymentCompatibility.swift` is the only local
   addition, and it lives beside the vendored files rather than inside them.
3. Build for every platform FeedKit supports — see below — and run
   `swift test`.

## `FeedKitDeploymentCompatibility.swift`

XMLKit declares a macOS 13 / iOS 16 / tvOS 16 / watchOS 9 floor. FeedKit supports
macOS 12 / iOS 15 / tvOS 15 / watchOS 8, and exactly one expression in the
vendored sources needs the newer floor: `TimeZone.gmt` in `XMLEncoder.swift`.
The compatibility file declares the same time zone, so the vendored sources stay
byte-for-byte identical to upstream while FeedKit keeps its deployment targets.

Verify the floor after an update:

```sh
SDK=$(xcrun --show-sdk-path)
swiftc -typecheck -swift-version 6 -target arm64-apple-macos12.0 -sdk "$SDK" \
  $(find Sources/XMLKitCore -name '*.swift' | sort)
```

and likewise for `arm64-apple-ios15.0` (`--sdk iphoneos`),
`arm64-apple-tvos15.0` (`--sdk appletvos`),
`arm64_32-apple-watchos8.0` (`--sdk watchos`) and `arm64-apple-xros1.0`
(`--sdk xros`).
