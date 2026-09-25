#!/bin/bash
#
# bench.sh — measure FeedKit parsing and record the result in PERFORMANCE.md.
#
#   ./bench.sh                      measure this checkout
#   ./bench.sh 10.5.0 10.9.3        measure release tags (git worktrees)
#   ./bench.sh --sweeps 100 main    more samples
#   ./bench.sh --clean              remove the worktrees
#
# Each run appends one row to ../PERFORMANCE.md: median milliseconds to parse
# one feed from Benchmarks/corpus, plus the ratio against the previous row for
# the same machine.
#
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
TRACKER="$ROOT/PERFORMANCE.md"

SWEEPS=50
WARMUP=5
REFS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --sweeps) SWEEPS="$2"; shift 2 ;;
    --warmup) WARMUP="$2"; shift 2 ;;
    --clean)
      git -C "$ROOT" worktree list --porcelain | awk '/^worktree /{print $2}' | while read -r path; do
        case "$path" in "$HERE/.worktrees/"*) git -C "$ROOT" worktree remove --force "$path" 2>/dev/null || true ;; esac
      done
      rm -rf "$HERE/.worktrees"
      echo "Removed $HERE/.worktrees"
      exit 0
      ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) REFS+=("$1"); shift ;;
  esac
done

MACHINE="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m) ($(sysctl -n hw.physicalcpu 2>/dev/null || echo '?')c)"
SWIFT="$(swift --version 2>/dev/null | head -1 | sed -E 's/.*version ([0-9]+\.[0-9.]+).*/\1/')"
[ -n "$SWIFT" ] || SWIFT="unknown"

slugify() { echo "$1" | tr -c 'A-Za-z0-9._-' '-' | sed 's/-\{2,\}/-/g; s/^-//; s/-$//'; }

mkdir -p "$HERE/.build"

# Build the benchmark against one checkout and run it. Prints the report to
# stdout; the last line is "RESULT<TAB>label<TAB>ms/feed<TAB>items<TAB>min ms".
measure() {
  path="$1"
  label="$2"
  scratch="$HERE/.build/$(slugify "$label")"
  mkdir -p "$scratch"

  if ! FEEDKIT_PATH="$path" swift build --package-path "$HERE" --scratch-path "$scratch" -c release \
      > "$scratch/build.log" 2>&1; then
    echo "build failed for $label — last lines of $scratch/build.log:" >&2
    tail -20 "$scratch/build.log" >&2
    exit 1
  fi

  "$scratch/release/bench" --corpus "$HERE/corpus" --label "$label" --warmup "$WARMUP" --sweeps "$SWEEPS"
}

# Append one Markdown row for a measured checkout.
record() {
  path="$1"
  label="$2"
  output="$3"

  result="$(echo "$output" | grep '^RESULT' | tail -1)"
  ms="$(echo "$result" | cut -f3)"
  items="$(echo "$result" | cut -f4)"
  commit="$(git -C "$path" rev-parse --short HEAD 2>/dev/null || echo '?')"

  # Ratio against the last row recorded for this machine (a new machine simply
  # starts its own baseline: "—").
  previous="$(grep -F "| $MACHINE |" "$TRACKER" 2>/dev/null | tail -1 | awk -F'|' '{gsub(/ /, "", $7); print $7}' || true)"
  if [ -n "$previous" ]; then
    ratio="$(awk -v a="$previous" -v b="$ms" 'BEGIN { if (a + 0 > 0) printf "%.2fx", b / a; else print "—" }')"
  else
    ratio="—"
  fi

  date_utc="$(date -u +%Y-%m-%d)"
  printf '| %s | %s | `%s` | %s | %s | %s | %s | %s |\n' \
    "$date_utc" "$label" "$commit" "$MACHINE" "$SWIFT" "$ms" "$items" "$ratio" >> "$TRACKER"

  echo "recorded: $label  $ms ms/feed  ($items items, vs previous $ratio)"
  echo
}

# --- measure the current checkout, or each requested ref --------------------

if [ ${#REFS[@]} -eq 0 ]; then
  measure "$ROOT" "$(git -C "$ROOT" describe --tags --always --dirty 2>/dev/null || echo unknown)" > "$HERE/.build/last-run.txt"
  cat "$HERE/.build/last-run.txt"
  record "$ROOT" "$(git -C "$ROOT" describe --tags --always --dirty 2>/dev/null || echo unknown)" "$(cat "$HERE/.build/last-run.txt")"
else
  mkdir -p "$HERE/.worktrees"
  git -C "$ROOT" worktree prune >/dev/null 2>&1 || true

  for ref in "${REFS[@]}"; do
    path="$HERE/.worktrees/$(slugify "$ref")"
    if [ -d "$path" ]; then git -C "$ROOT" worktree remove --force "$path" >/dev/null 2>&1 || true; fi
    rm -rf "$path"
    if ! git -C "$ROOT" worktree add --detach "$path" "$ref" >/dev/null 2>&1; then
      echo "cannot check out '$ref'" >&2
      exit 1
    fi
    echo "=== $ref (worktree $path) ==="
    measure "$path" "$ref" > "$HERE/.build/last-run.txt"
    cat "$HERE/.build/last-run.txt"
    record "$path" "$ref" "$(cat "$HERE/.build/last-run.txt")"
  done
fi

echo "Updated $TRACKER"
