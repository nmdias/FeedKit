# FeedKit benchmarks

Everything here keeps one number honest: **how long FeedKit takes to parse a
feed**. Results are recorded in [`../PERFORMANCE.md`](../PERFORMANCE.md).

## Files

| Path | What it is |
|---|---|
| `bench.sh` | Builds and runs the benchmark, appends a row to `PERFORMANCE.md` |
| `Sources/bench/main.swift` | The whole measurement: parse the corpus, report the median |
| `Package.swift` | 25 lines of SwiftPM boilerplate so `main.swift` can build against any FeedKit checkout |
| `corpus/` | Six real feeds (2 Atom, 3 RSS, 1 JSON), 409 KB, frozen |

That is all of it. There is no test framework, no results database, no
configuration.

## Run it

```sh
./bench.sh                    # measure this checkout, add a row to the tracker
./bench.sh --sweeps 100       # more samples (default 50)
./bench.sh 10.5.0 10.9.3      # old releases, via git worktrees
./bench.sh --clean            # remove those worktrees
```

Requires macOS and a Swift 6 toolchain. No network. A few seconds per version,
plus the build.

## How it works

`bench.sh` builds `main.swift` against a FeedKit checkout selected by
`FEEDKIT_PATH`. That indirection is the only trick: one benchmark file can be
compiled against the current tree or against release tag `10.5.0` checked out
in a git worktree, so every row in the tracker comes from the same protocol.

`main.swift` then:

1. parses every corpus file once, untimed, and counts the decoded items;
2. runs warm-up sweeps so lazy `DateFormatter`s and caches settle;
3. runs the timed sweeps, timing each feed and each whole sweep with
   `ContinuousClock` (monotonic — never `Date()`);
4. prints a per-feed and per-format table, and a final `RESULT` line that
   `bench.sh` turns into a Markdown row.

It uses only API that has existed across the whole 10.x line
(`AtomFeed`/`RSSFeed`/`JSONFeed` `init(data:)`), which is what lets it measure
old releases. **Adding a newer API to `main.swift` breaks measurement of older
versions** — keep that in mind before reaching for one.

## Reading a run

```
feed                               format   median ms    min ms
rss-arstechnica.xml                rss          6.912     6.845
...
atom                               atom       109.400   108.900
whole corpus, one sweep: median 131.418 ms, min 130.100 ms
```

- **median** is the number to compare; **min** is the machine's best case. If
  the median is far above the min, something else was running — re-run.
- **items** in the tracker row is the total decoded item count. If a row has
  fewer items than the one before it, the library stopped extracting something
  and the timing is not a valid comparison.

## The corpus

Six real feeds downloaded once and committed. Frozen bytes are the whole point:
two runs weeks apart parse identical input, so a timing difference can only come
from the library. Do not edit them; if you ever need to re-freeze, replace the
files and say so in a new tracker section, because rows before and after are not
comparable. Sources:

| File | Source |
|---|---|
| `atom-youtube-ltt.xml` | `https://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw` |
| `atom-youtube-markrober.xml` | `https://www.youtube.com/feeds/videos.xml?channel_id=UCY1kMZp36IQSyNx_9h4mpCg` |
| `rss-arstechnica.xml` | `https://feeds.arstechnica.com/arstechnica/index` |
| `rss-css-tricks.xml` | `https://css-tricks.com/feed/` |
| `rss-hnrss.xml` | `https://hnrss.org/frontpage` |
| `json-daringfireball.json` | `https://daringfireball.net/feeds/json` |

RDF is not in the corpus: `RDFFeed` did not exist before 10.8, and the corpus
has to parse on every version we want to measure. The RSS 1.0 cost is
negligible anyway (~0.4 ms for the feed this replaced).

## Tracking a change

```sh
./bench.sh --sweeps 100              # before
# ...make the change...
./bench.sh --sweeps 100              # after; the row shows "vs prev"
```

For a release sweep, `./bench.sh 10.5.0 10.5.1 10.9.2 10.9.3` reproduces the
history on your machine in one command. Run it on a quiet machine, and prefer
more sweeps over trusting one run.
