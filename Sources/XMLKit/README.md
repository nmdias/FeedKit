# XMLKit

The XML engine: tokenizer, parser, document model, namespace resolution,
serialiser and the `Codable` bridge. `FeedKit` reads feed documents through it,
and it is published as a product of this package in its own right.

## Provenance

This directory is the standalone XMLKit project's `Sources/XMLKit/`, vendored
rather than depended upon so that the package keeps its zero-dependency
manifest. Upstream declares a macOS 13 / iOS 16 / tvOS 16 / watchOS 9 floor and
a Swift 6.2 tools version; FeedKit supports macOS 12 / iOS 15 / tvOS 15 /
watchOS 8 and builds with Swift 6.0, so a handful of local adaptations keep
those promises. They are listed below and are the only differences from
upstream.

`.swiftformat` excludes this directory: swiftformat's type-inference rules
rewrite annotations here into forms that do not compile (`let x: Int = .min(a, b)`
becomes `let x: Swift = …`), so the engine keeps its own layout.

## Updating

1. Copy `Sources/XMLKit/**` from the upstream project over this directory.
2. Re-apply the adaptations below. `grep -rn 'unsafe ' Sources/XMLKit`,
   `grep -rn 'markupKey\|attributeTrimming' Sources/XMLKit` and a build for the
   deployment targets are enough to find every site.
3. Build for every platform FeedKit supports — see below — and run
   `swift test`.

## Adaptations

| Adaptation | Why |
|---|---|
| `FeedKitDeploymentCompatibility.swift` | Upstream's only macOS 13 / iOS 16 API use is `TimeZone.gmt` in `XMLEncoder.swift`; this file declares the same time zone so FeedKit keeps its deployment targets and the vendored sources stay otherwise untouched. |
| Seven `unsafe` expression keywords removed | Swift 6.2 syntax that a Swift 6.0 toolchain cannot parse. The expressions are unchanged, and the marker only has an effect under `-strict-memory-safety`, which this package does not enable. |
| `XMLAttributeTrimming` (default `.none`) | Some feeds pad attribute values — `length="169600320 "` — and a padded number is not a number. Default `.none` keeps upstream behaviour for every other consumer; FeedKit opts in. |
| `#markup` decoding key | `Codable` has no vocabulary for mixed content, so an element whose children *are* its value (Atom's `type="xhtml"` content) had no way to reach it. The key yields the element's inner XML; `XMLElement.innerMarkup()` is the same view from the DOM. |
| Namespace-URI key matching, and prefix scope tracking on encoding | Upstream documents `XMLNamespaceStrategy.uri` as matching `"uri localName"` keys against resolved namespaces, and its encoder assigns prefixes for keys written that way; the matching and the "declare once, at the outermost element that needs it" side were the missing halves. |
| A repeated element read as a scalar prefers the sibling that carries text | `<link rel="self" href="…"/><link>https://example.com/</link>` is a real pattern; a scalar wants the repetition that holds a value. |

## Verifying the deployment targets

```sh
SDK=$(xcrun --show-sdk-path)
swiftc -typecheck -swift-version 6 -target arm64-apple-macos12.0 -sdk "$SDK" \
  $(find Sources/XMLKit -name '*.swift' | sort)
```

and likewise for `arm64-apple-ios15.0` (`--sdk iphoneos`),
`arm64-apple-tvos15.0` (`--sdk appletvos`),
`arm64_32-apple-watchos8.0` (`--sdk watchos`) and `arm64-apple-xros1.0`
(`--sdk xros`).
