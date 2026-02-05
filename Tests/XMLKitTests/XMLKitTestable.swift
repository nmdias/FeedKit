//
// XMLKitTestable.swift
//
// Copyright (c) 2016 - 2026 Nuno Dias
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Testing

protocol XMLKitTestable {
  /// Loads a resource from the bundle and returns its data.
  /// - Parameters:
  ///   - resource: The name of the resource file.
  ///   - ext: The file extension of the resource.
  /// - Returns: Data loaded from the resource file.
  /// - Throws: Fatal error if the resource cannot be found or loaded.
  func data(resource: String, withExtension ext: String) -> Data

  /// Saves the expected and actual objects to the documents directory for
  /// debugging purposes. This method is helpful for comparing expected and
  /// actual objects when debugging test failures.
  /// - Parameters:
  ///   - expected: The expected object, which will be saved as a JSON file.
  ///   - actual: The actual object, which will be saved as a JSON file if
  ///     it is not nil.
  func saveToDocuments<T: Codable>(expected: T, actual: T?)

  /// Saves a given object to a specified directory as a JSON file.
  /// - Parameters:
  ///   - object: The object to be saved, which must conform to the `Codable`
  ///     protocol.
  ///   - directory: The directory in which the file will be saved (e.g.,
  ///     `.documentDirectory`).
  ///   - fileName: The name of the file to be saved.
  func save(_ object: some Codable, to directory: FileManager.SearchPathDirectory, as fileName: String)
}

extension XMLKitTestable {
  func url(resource: String, withExtension ext: String) -> URL {
    guard let fileURL = Bundle.module.url(forResource: resource, withExtension: ext) else {
      fatalError("Error: Could not find file \(resource).\(ext) in bundle.")
    }
    return fileURL
  }

  func string(resource: String, withExtension ext: String) -> String {
    guard let fileURL = Bundle.module.url(forResource: resource, withExtension: ext) else {
      fatalError("Error: Could not find file \(resource).\(ext) in bundle.")
    }
    do {
      return try String(contentsOf: fileURL, encoding: .utf8)
    } catch {
      fatalError("Error: Failed to load string from \(fileURL): \(error)")
    }
  }

  func data(resource: String, withExtension ext: String) -> Data {
    guard let fileURL = Bundle.module.url(forResource: resource, withExtension: ext) else {
      fatalError("Error: Could not find file \(resource).\(ext) in bundle.")
    }
    do {
      return try Data(contentsOf: fileURL)
    } catch {
      fatalError("Error: Failed to load data from \(fileURL): \(error)")
    }
  }

  func saveToDocuments<T: Codable>(expected: T, actual: T?) {
    save(expected, to: .documentDirectory, as: "expected.json")

    if let actual {
      save(actual, to: .documentDirectory, as: "actual.json")
    } else {
      print("Actual is nil, skipping file creation.")
    }
  }

  func save(_ object: some Codable, to directory: FileManager.SearchPathDirectory, as fileName: String) {
    do {
      // Convert object to JSON data
      let encoder: JSONEncoder = .init()
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
      let jsonData = try encoder.encode(object)

      // Get the directory path
      if let directoryURL = FileManager.default.urls(for: directory, in: .userDomainMask).first {
        let fileURL = directoryURL.appendingPathComponent(fileName)

        // Delete the existing file if it exists
        if FileManager.default.fileExists(atPath: fileURL.path) {
          do {
            try FileManager.default.removeItem(at: fileURL)
          } catch {
            print("Failed to delete existing file: \(error)")
          }
        }

        // Write the new JSON data to the file
        try jsonData.write(to: fileURL)
        print("File saved to: \(fileURL.path)")
      }
    } catch {
      print("Failed to write \(fileName): \(error)")
    }
  }
}
