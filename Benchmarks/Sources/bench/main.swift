//
// main.swift — FeedKit parse benchmark.
//
// One measurement: how long does it take to parse a fixed corpus of real feeds?
// Prints a per-format table for a human, then one RESULT line that bench.sh
// records in PERFORMANCE.md.
//
// It deliberately uses only API that has existed across the whole 10.x line
// (AtomFeed/RSSFeed/JSONFeed `init(data:)`), so this single file can measure
// any release tag with the same protocol.
//
// Usage:
//   bench --corpus Benchmarks/corpus --label 10.9.3 [--warmup 5] [--sweeps 50]
//

import FeedKit
import Foundation

// MARK: - Arguments

var options: [String: String] = [:]
var argumentIndex = 1
while argumentIndex < CommandLine.arguments.count {
  let token = CommandLine.arguments[argumentIndex]
  if token.hasPrefix("--"), argumentIndex + 1 < CommandLine.arguments.count {
    options[String(token.dropFirst(2))] = CommandLine.arguments[argumentIndex + 1]
    argumentIndex += 2
  } else {
    argumentIndex += 1
  }
}

func option(_ key: String, _ fallback: String) -> String { options[key] ?? fallback }
func option(_ key: String, _ fallback: Int) -> Int { options[key].flatMap(Int.init) ?? fallback }

let corpusDirectory = option("corpus", "corpus")
let label = option("label", "unlabeled")
let warmupSweeps = option("warmup", 5)
let timedSweeps = option("sweeps", 50)

// MARK: - Corpus

struct Document {
  let name: String
  let format: String
  let data: Data
}

struct BenchmarkError: Error, CustomStringConvertible {
  let description: String
  init(_ description: String) { self.description = description }
}

let fileManager = FileManager.default
let fileNames = (try? fileManager.contentsOfDirectory(atPath: corpusDirectory))?
  .filter { $0.hasSuffix(".xml") || $0.hasSuffix(".json") }
  .sorted() ?? []
guard !fileNames.isEmpty else {
  FileHandle.standardError.write(Data("no .xml or .json feed files in \(corpusDirectory)\n".utf8))
  exit(2)
}

var documents: [Document] = []
for fileName in fileNames {
  // Files are named <format>-<something>.xml, e.g. atom-youtube-ltt.xml.
  let format = fileName.split(separator: "-").first.map(String.init) ?? ""
  let url = URL(fileURLWithPath: corpusDirectory).appendingPathComponent(fileName)
  documents.append(Document(name: fileName, format: format, data: try Data(contentsOf: url)))
}

// MARK: - The measured operation

/// Parses one document with the initializer for its format and reports how many
/// items came back, so a version that silently decodes less is visible.
func parse(_ document: Document) throws -> Int {
  switch document.format {
  case "atom": return try AtomFeed(data: document.data).entries?.count ?? 0
  case "rss": return try RSSFeed(data: document.data).channel?.items?.count ?? 0
  case "json": return try JSONFeed(data: document.data).items?.count ?? 0
  default: throw BenchmarkError("unknown format prefix '\(document.format)' in \(document.name)")
  }
}

let clock = ContinuousClock()

func milliseconds(_ duration: Duration) -> Double {
  let parts = duration.components
  return Double(parts.seconds) * 1000 + Double(parts.attoseconds) / 1e15
}

func median(_ values: [Double]) -> Double {
  let sorted = values.sorted()
  return sorted.isEmpty ? .nan : sorted[sorted.count / 2]
}

// MARK: - Verify, warm up, measure

// One untimed pass first: proves every file parses and records the item count.
var itemCount = 0
for document in documents {
  itemCount += try parse(document)
}

for _ in 0 ..< warmupSweeps {
  for document in documents { _ = try parse(document) }
}

var sweepTimes: [Double] = []
var perDocument: [String: [Double]] = [:]
var perFormat: [String: [Double]] = [:]

for _ in 0 ..< timedSweeps {
  let sweepStart = clock.now
  for document in documents {
    let start = clock.now
    _ = try parse(document)
    let elapsed = milliseconds(clock.now - start)
    perDocument[document.name, default: []].append(elapsed)
    perFormat[document.format, default: []].append(elapsed)
  }
  sweepTimes.append(milliseconds(clock.now - sweepStart))
}

// MARK: - Report

func pad(_ text: String, _ width: Int, right: Bool = false) -> String {
  guard text.count < width else { return text }
  let padding = String(repeating: " ", count: width - text.count)
  return right ? padding + text : text + padding
}

func rounded(_ value: Double) -> String { String(format: "%.3f", value) }

let totalBytes = documents.reduce(0) { $0 + $1.data.count }
let medianSweep = median(sweepTimes)
let minSweep = sweepTimes.min() ?? .nan

print("FeedKit parse benchmark — \(label)")
print("corpus \(documents.count) feeds, \(totalBytes) bytes · \(timedSweeps) sweeps (warm-up \(warmupSweeps)) · release build")
print("")
print("\(pad("feed", 34)) \(pad("format", 7)) \(pad("median ms", 10, right: true)) \(pad("min ms", 10, right: true))")
print(String(repeating: "-", count: 65))
for document in documents {
  let samples = perDocument[document.name] ?? []
  print("\(pad(document.name, 34)) \(pad(document.format, 7)) \(pad(rounded(median(samples)), 10, right: true)) \(pad(rounded(samples.min() ?? .nan), 10, right: true))")
}
print(String(repeating: "-", count: 65))
for format in perFormat.keys.sorted() {
  let samples = perFormat[format] ?? []
  print("\(pad(format, 34)) \(pad("", 7)) \(pad(rounded(median(samples)), 10, right: true)) \(pad(rounded(samples.min() ?? .nan), 10, right: true))")
}
print("")
print("whole corpus, one sweep: median \(rounded(medianSweep)) ms, min \(rounded(minSweep)) ms")
print("")

// Consumed by bench.sh: label, median ms per feed, items decoded, min sweep ms.
print("RESULT\t\(label)\t\(rounded(medianSweep / Double(documents.count)))\t\(itemCount)\t\(rounded(minSweep))")
