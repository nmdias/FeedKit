---
name: benchmark
description: Measure FeedKit parsing speed and record the result in PERFORMANCE.md. Use when asked to benchmark, to check for a parse performance regression, or to update the performance tracker.
---

# FeedKit parse benchmark

One command measures how long FeedKit takes to parse a frozen corpus of real
feeds and appends a row to `PERFORMANCE.md`.

Details live in `Benchmarks/README.md` (paths here are relative to the FeedKit
repository root); this is the operating procedure.

## Run

```sh
cd Benchmarks               # <repo>/Benchmarks
./bench.sh                  # this checkout
./bench.sh 10.5.0 10.9.3    # old releases, via git worktrees
./bench.sh --sweeps 100     # more samples (default 50)
./bench.sh --clean          # remove the worktrees afterwards
```

About 30–40 s per version plus a release build. No network.

## Report back

- The new row: `ms/feed`, and **`vs prev`** — the ratio against the previous row
  for the same machine. Above ~1.15x is a regression worth investigating;
  below ~0.85x is an improvement.
- The per-format table the run prints (atom / rss / json). It names which format
  moved, which is most of the diagnosis.
- **`items` must be unchanged** between rows. If it changed, the library is
  decoding something different and the timing is not a valid comparison — say
  so instead of reporting the ratio.
- `min` vs `median` in the run output. If the median is well above the min, the
  machine was busy; recommend a re-run rather than reporting the number.

## Rules

- Rows are only ever added by `bench.sh`. Never hand-edit the table.
- `Benchmarks/Sources/bench/main.swift` must keep using only API that exists in
  the oldest version to be measured (`AtomFeed`/`RSSFeed`/`JSONFeed`
  `init(data:)`). Reaching for newer API silently breaks measurement of old tags.
- Never edit `Benchmarks/corpus/` — frozen bytes are what make rows comparable.
- Measure on a quiet machine; do not run other heavy work in parallel.
