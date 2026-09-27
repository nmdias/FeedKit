# XMLKitCore

The XML engine that backs the `XMLKit` product: tokenizer, parser, document
model, namespace resolution, serialiser and a modern `Codable` bridge.

## Provenance

This directory is the standalone XMLKit project's `Sources/XMLKit/`, vendored.
It is vendored rather than depended upon so that FeedKit keeps its
zero-dependency manifest, and it is a separate target rather than part of
`XMLKit` so that its types — which are named `XMLDocument`, `XMLElement`,
`XMLDecoder` and `XMLEncoder`, exactly like the ones `XMLKit` publishes — cannot
collide with the compatibility surface FeedKit's public API promises.

The target is not a product: it is an implementation detail of `XMLKit`, and
nothing outside the package can import it.

Upstream declares a macOS 13 / iOS 16 / tvOS 16 / watchOS 9 floor and a Swift
6.2 tools version. FeedKit supports macOS 12 / iOS 15 / tvOS 15 / watchOS 8 and
builds with Swift 6.0, so two local adaptations keep those promises. Both are
listed below, and both are the only differences from upstream.

## Updating

1. Copy `Sources/XMLKit/**` from the upstream project over this directory.
2. Re-apply the two adaptations below; `grep -rn '\bunsafe\b'` and a build for
   the deployment targets are enough to find every site.
3. Build for every platform FeedKit supports — see below — and run
   `swift test`.

## Adaptation 1 — `FeedKitDeploymentCompatibility.swift`

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

## Adaptation 2 — the `unsafe` expression keyword

Seven expressions are written with Swift 6.2's `unsafe` keyword, which marks an
operation as deliberately outside strict memory safety:

| File | Expressions |
|---|---|
| `Internal/XMLByteUtilities.swift` | three `memcmp` calls, one `xmlValidateUTF8` call, two buffer subscripts |
| `Parsing/XMLTokenizer.swift` | one pointer offset, one `memcmp` |

FeedKit builds with Swift 6.0 (its Linux CI job, and the tools version its
manifest declares), which cannot parse the keyword, so it is removed at those
seven sites. The expressions themselves are unchanged, and removing the marker
changes nothing about what they do: it is a diagnostic annotation that only has
an effect under `-strict-memory-safety`, which FeedKit does not enable for this
target. Users who build with a Swift 6.2 toolchain get exactly the same code.

To find the sites after an upstream update:

```sh
grep -rn 'unsafe ' Sources/XMLKitCore --include='*.swift'
```
