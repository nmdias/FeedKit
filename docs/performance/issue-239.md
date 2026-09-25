# Parse performance regression in 10.5.1 (issue #239)

Parsing a feed with FeedKit takes **twice as long** as it did in 10.5.0. The regression is a
single commit — `5ba9588`, *"Fix RSS parsing when a namespace prefix matches an element name
(#215)"*, first shipped in **10.5.1** — which made the XML decoder perform the whole decode
twice.

This document records the measurement, the attribution and the mechanism so that a later
change can address it. It proposes no fix: the duplicated pass exists to keep
`contains(_:)` and `child(for:)` consistent for `<source:markdown>` versus the RSS
`<source>` element, so removing it means replacing that mechanism, not reverting it.

## Impact

| Version | Commit | Run 1 / Run 2 median (ms/feed) | vs 10.5.0 |
|---|---|---|---|
| 10.5.0 | `fbae69b` | 52.00 / 52.02 | 1.00x |
| **10.5.1** | `5ba9588` | **102.65 / 102.85** | **1.97x** |
| 10.5.2 | `38db913` | 102.81 / 103.17 | 1.98x |
| 10.5.3 | `0054c208` | 103.29 / 103.84 | 1.99x |
| 10.6.0 | `c19c359` | 103.56 / 103.92 | 1.99x |
| 10.7.0 | `b4bd409` | 103.91 / 104.37 | 2.00x |
| 10.8.0 | `ffbc158` | 103.53 / 104.13 | 2.00x |
| 10.9.0 | `03e8ac2` | 103.70 / 103.78 | 1.99x |
| 10.9.2 | `6c42231` | 104.11 / 104.36 | 2.00x |
| main | `a5532f2` | 104.05 / 104.38 | 2.00x |

Every version in the range was measured; there is no intermediate step — the cost doubles at
10.5.1 and stays flat afterwards.

**Corpus and method.** 13 real YouTube Atom feeds fetched once and frozen: 410,938 bytes,
195 entries, mean 31.6 KB per feed. Identical bytes parsed in-process by every version
(release build, `-O` + whole-module optimisation, `ContinuousClock`), 20 timed sweeps plus 5
discarded warm-up sweeps, one sample per individual feed parse, n = 260 per process, two
independent processes run with the version order reversed. The two runs agree to within 0.5%
of each other; per-cell CV ≤ 3.04%; spreads do not overlap (10.5.0 max 52.70 ms over five
independent processes, main min 104.05 ms). Every version produced the same digest of the
decoded model (195 entries, 13,387 title/content/id characters), so all versions parsed the
same content.

The two bundled fixtures are far too small to time — `Tests/.../xml/YouTube.xml` is 381 bytes
and `Atom.xml` is 2,774 bytes — which is why a real corpus was frozen for this measurement.

## Attribution

`git bisect run` over the 13 commits in `10.5.0..10.9.2`, with the harness itself as the
predicate, reports `5ba9588` as the first bad commit:

| Step | median (ms/feed) | verdict |
|---|---|---|
| `cb7b624` | 52.19 | fast |
| `5ba9588` | 103.48 | slow |
| `38db913` | 103.76 | slow |
| `c19c359` | 104.48 | slow |

Correlation is not causation, so the commit was also flipped in both directions in disposable
worktrees:

| Control | median (ms/feed) |
|---|---|
| main, unchanged | 104.38 |
| main **− `5ba9588`** | **52.73** |
| 10.5.0, unchanged | 52.00 |
| 10.5.0 **+ `5ba9588`** | **104.04** |
| main − all four parse-path commits in the range | 52.40 |

Removing it from latest restores the 10.5.0 baseline; adding it alone to the 10.5.0 baseline
reproduces the regression in full. The four parse-path commits account for the whole 2x and
`5ba9588` accounts for ~99% of it.

**Suspects ruled out.** `0054c20` (*"Prefer text-bearing elements when decoding repeated
children"*, 10.5.3) rewrote `XMLNode.child(for:)` from a short-circuiting `first(where:)` to
`children?.filter { … } ?? []` plus a second scan, so every key lookup now allocates a
temporary array and always scans all children — and `contains(_:)` and `decode(_:forKey:)`
each call it. It is a real inefficiency but worth only **+0.5%** here (10.5.0 + `0054c20` =
52.44 ms vs 52.00 ms; main − `0054c20` = 103.92 ms vs 104.38 ms; 1.3% of decode samples). It
would matter more on feeds with many repeated siblings, but it is not this regression.
`38db913` (trim attribute values, main − it = 104.38 ms) and `cb7b624` (inspection prefix
256 → 128, main with 128 = 104.02 ms) measured as no-ops.

## Cause

`XMLDecoder.decode(_:from:)` runs the entire decode twice. At `main`
(`Sources/XMLKit/XMLDecoder/XMLDecoder.swift:72-88`):

```swift
let discovery: _XMLDecoder = .init(node: node, codingPath: [],
                                  isDiscoveringNamespaceContainers: true)
discovery.dateDecodingStrategy = dateDecodingStrategy
_ = try? T(from: discovery)          // full decode, result discarded

let decoder: _XMLDecoder = .init(node: node, codingPath: [],
                                 namespaceContainerKeys: discovery.namespaceContainerKeys)
decoder.dateDecodingStrategy = dateDecodingStrategy
return try T(from: decoder)          // full decode, result returned
```

At 10.5.0 the same function was a single pass:

```swift
let decoder: _XMLDecoder = .init(node: node, codingPath: [])
decoder.dateDecodingStrategy = dateDecodingStrategy
return try T(from: decoder)
```

The discovery pass exists only to populate `namespaceContainerKeys` — the
`decoder.namespaceContainerKeys.insert(key.stringValue)` call in
`XMLKeyedDecodingContainer.swift:167` is its entire output. The decoded tree is thrown away.

Because 2x is suspiciously round, the profile was checked rather than assumed. A `sample`
capture of the harness (release build with `-Xswiftc -g`) splits the decode almost exactly in
half at the two call sites:

| | samples | share of decode |
|---|---|---|
| all decode work | 7,900 | 100% |
| discovery pass (`XMLDecoder.swift:79`) | 3,930 | 49.7% |
| authoritative pass (`XMLDecoder.swift:87`) | 3,883 | 49.1% |
| date-formatting subtree | 7,575 | **95.9%** |
| `XMLNode.child(for:)` | 100 | 1.3% |
| `XMLReader` / XMLParser | 82 | 1.0% |

The discovery pass runs essentially to completion rather than throwing early, and the cost it
duplicates is **date parsing**, not tree walking. `FeedDateFormatter` in `.permissive` mode
(`Sources/FeedKit/FeedDateFormatter.swift:286-290`) tries RFC822, then RFC3339, then RFC1123,
then ISO8601; the RFC822 attempt alone walks five `dateFormat` patterns and then three
`permissiveDateFormats` (lines 151-203), each one a Foundation `DateFormatter`/ICU parse. A
YouTube entry carries two dates and the feed one more, so a feed decodes ~31 date values and
each can cost up to eight ICU pattern attempts — all of it paid twice. The 95.7% figure is the
same at 10.5.0, confirming the duplication is what changed, not the date path.

So the responsible change adds no algorithm of its own: it duplicates an already
ICU-bound decode, which is why the measured factor is 1.97–2.01x and not something larger.

## On the reporter's "6 s vs 12 s"

Reproduced, with a caveat. Running the reporter's exact call, `try await AtomFeed(url:)`, over
104 real URLs (13 feeds × 8, interleaved so both versions saw the same network) gives
**5,556 / 5,560 ms on 10.5.0 versus 11,010 / 10,962 ms on main** — about 5.3 s vs 10.6 s per
100 feeds, against their reported 6 s vs 12 s.

That reproduction holds because `URLSession` served the repeated URLs from its own cache
(median fetch 0.6 ms), so the measurement was parse-dominated. Forcing genuinely cold fetches
with a unique query parameter per request gives **13.9 s vs 15.6 s (1.06–1.16x)** for the same
100-feed shape, because ~9 s of the ~14 s is network. The 2x is real but it is a property of
the parser, not of `AtomFeed(url:)` end to end; users on a slow or uncached network will see a
much smaller relative regression. Fetch variance (±70% at p95) dwarfs parse variance (<1%).

## Confidence and limits

**High** for the existence and attribution of the regression: two order-reversed processes,
non-overlapping spreads across five runs per version, a bisect that names one commit, a
two-way control that flips the metric both ways, and a profile that shows the two passes
directly.

What would change the numbers: the corpus is one format (Atom) from one provider, measured on
a single Apple M1 with Swift 6.4. The exact 2.0x is therefore platform- and corpus-specific
even though the existence of the regression is not — a different toolchain shifts the absolute
cost of the ICU date path, and a feed without dates would regress by less. The
`child(for:)` finding in particular is corpus-dependent and would grow on feeds with many
repeated sibling elements. The `cb7b624` control is a proxy rather than the literal upstream
patch, because its revert no longer applies on main; it changes only a 128-byte inspection
prefix, so this is immaterial.

## Reproducing

The measurement harness, the frozen corpus and all raw result files are not kept in this
repository — they are investigation scaffolding rather than library source. They are described
well enough above to rebuild: freeze a set of real feeds, parse the same bytes with
`AtomFeed(data:)` in a release build using `ContinuousClock`, discard warm-up sweeps, and
compare per-feed medians between tags built in separate `git worktree`s with separate
`--scratch-path`s. `git bisect run` over `10.5.0..10.9.2` with that harness as the predicate
reproduces the attribution.
