# FeedKit performance

Parsing speed of FeedKit, measured the same way on every release, so that a
regression is caught by a number instead of by a user. The 10.5.1
date-decoding regression doubled parse time and went unnoticed for five
releases; this table is the fix for that.

## What is measured

One operation: **parse the feeds in [`Benchmarks/corpus`](Benchmarks/corpus)**
— 2 Atom, 3 RSS 2.0 and 1 JSON Feed, 409 KB of real-world bytes, frozen —
with `AtomFeed(data:)`, `RSSFeed(data:)` and `JSONFeed(data:)`.

- **ms/feed** — median time to parse one feed, over 50 sweeps of the whole
  corpus after 5 warm-up sweeps, release build, monotonic clock.
- **items** — entries/items decoded. If this changes between rows, the library
  is not extracting the same content and the timings are not comparable.
- **vs prev** — ratio against the previous row *for the same machine*.
  Absolute milliseconds are only comparable within one machine, so a new
  machine starts its own baseline.

The run itself also prints the per-feed and per-format breakdown, plus the
`min` next to each median. A median far above the min means the machine was
busy and the row should be re-run.

## How to run

```sh
cd Benchmarks
./bench.sh                      # measure this checkout and add a row
./bench.sh 10.5.0 10.9.2        # measure older releases (git worktrees)
./bench.sh --sweeps 100         # more samples
```

Requires macOS, a Swift 6 toolchain, and no network.

## Results

| Date | Version | Commit | Machine | Swift | ms/feed | items | vs prev |
|---|---|---|---|---|---|---|---|
| 2026-09-25 | 10.5.0 | `fbae69b` | Apple M1 (8c) | 6.4 | 20.575 | 133 | — |
| 2026-09-25 | 10.5.1 | `5ba9588` | Apple M1 (8c) | 6.4 | 39.347 | 133 | 1.91x |
| 2026-09-25 | 10.9.2 | `6c42231` | Apple M1 (8c) | 6.4 | 39.764 | 133 | 1.01x |
| 2026-09-25 | 10.9.3 | `d2d61b5` | Apple M1 (8c) | 6.4 | 21.991 | 133 | 0.55x |
