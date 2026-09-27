//
// XMLReader.swift
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
#if canImport(FoundationXML)
  import FoundationXML
#endif

class XMLReader: NSObject {
  // MARK: Lifecycle

  /// Initializes the wrapper with XML data.
  /// - Parameter data: The XML data to parse.
  init(data: Data) {
    parser = XMLParser(data: data)
    stack = XMLStack()
    super.init()
    parser.delegate = self
  }

  // MARK: Internal

  /// The XML Parser.
  let parser: XMLParser
  /// A stack of `XMLNode` instances representing the current hierarchy
  /// of XML elements during parsing.
  /// - New elements are pushed to the stack as they are encountered.
  /// - When an element ends, it is popped from the stack and added to its
  ///   parent’s children, building a tree structure. After parsing completes,
  ///   only the root element remains in the stack, representing the entire XML
  ///   document.
  var stack: XMLStack
  /// A parsing error, if any.
  var error: XMLError?
  /// A boolean indicating whether the XML parsing process has completed.
  /// Set to `true` when parsing is finished; otherwise, `false`.
  var isComplete = false

  /// Parses the XML data and returns a `Result` indicating success or failure.
  /// - Returns: A `Result` with the parsed document on success, or an error.
  func read() -> Result<XMLDocument, XMLError> {
    // Starts the parsing process. If parsing fails or an error occurs,
    // returns a failure result with the existing error or an unknown error.
    guard
      parser.parse(),
      error == nil,
      let root = stack.pop()
    else {
      let error = error ?? .unexpected(reason: "An unknown error occurred or the parsing operation aborted.")
      return .failure(error)
    }

    // If parsing completes successfully,
    // returns the a document wrapped in a success result.

    return .success(.init(root: root))
  }

  /// Maps character data by appending it to the current element's text variable.
  /// `map(_ string:)` may be called multiple times for the same element.
  /// - Parameter string: The character data found in the XML.
  func map(_ string: String) {
    // Get the working element
    guard let element = stack.top() else {
      return
    }
    guard !string.isEmpty else {
      return
    }
    element.text = element.text?.appending(string) ?? string
  }

  // MARK: Private

  /// Trims whitespace and newlines from an attribute value.
  ///
  /// `XMLParser` does not sanitize attribute values, and real-world documents
  /// may pad them with whitespace, e.g. `length="169600320 "`. Element text is
  /// trimmed when its element ends; attributes are sanitized here so that a
  /// typed attribute decodes regardless of its surrounding whitespace.
  /// - Parameter attributeValue: The raw attribute value reported by the parser.
  /// - Returns: The attribute value without surrounding whitespace.
  private static func sanitize(attributeValue: String) -> String {
    trimmed(attributeValue) ?? ""
  }

  /// `text` without leading or trailing whitespace, or `nil` when nothing is
  /// left of it.
  ///
  /// The text that arrives from the parser is nearly always one of two things: a
  /// value with no whitespace around it, as `<title>Title</title>` carries, or
  /// the indentation between two elements. Both are answered here without
  /// building the string `trimmingCharacters(in:)` would, which is a copy of the
  /// whole value — a `<description>` can be tens of kilobytes — or, for
  /// indentation, an allocation that is thrown away.
  ///
  /// - Parameter text: The text of the element that just ended.
  /// - Returns: The text to keep, or `nil`.
  private static func trimmed(_ text: String?) -> String? {
    guard let text, !text.isEmpty else {
      return nil
    }
    guard let first = text.unicodeScalars.first, let last = text.unicodeScalars.last else {
      return nil
    }

    let whitespace: CharacterSet = .whitespacesAndNewlines
    guard whitespace.contains(first) || whitespace.contains(last) else {
      // Nothing to trim.
      return text
    }
    guard !text.unicodeScalars.allSatisfy({ whitespace.contains($0) }) else {
      // Nothing but whitespace, as the indentation between elements is.
      return nil
    }

    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}

// MARK: - XMLParserDelegate

extension XMLReader: XMLParserDelegate {
  func parser(
    _: XMLParser,
    didStartElement elementName: String,
    namespaceURI _: String?,
    qualifiedName _: String?,
    attributes attributeDict: [String: String] = [:]
  ) {
    // Determine prefix and namespace. The delimiter is looked for in the UTF-8
    // bytes: the name arrives from the parser as a bridged string, over which a
    // search by `Character` costs far more than a search by byte, and a byte of a
    // multi-byte character can never be the colon.
    var prefix: String?
    if let prefixDelimiterIndex = elementName.utf8.firstIndex(of: UInt8(ascii: ":")) {
      prefix = String(elementName[..<prefixDelimiterIndex])
    }

    // Check if the element contains XHTML. If so, avoid building a tree.
    // Instead, we append a single node with the XHTML content and mark it as isXhtml.
    let isXhtml = attributeDict["type"] == "xhtml"
    if isXhtml {
      // Entering an XHTML element; create a single node for it.
      stack.push(.init(
        prefix: prefix,
        name: elementName,
        isXhtml: isXhtml,
        children: [
          .init(
            name: "@attributes",
            children: attributeDict.map {
              .init(
                name: $0,
                text: Self.sanitize(attributeValue: $1)
              )
            }
          )
        ]
      ))
    } else if let node = stack.top(), node.isXhtml {
      // If inside an XHTML element, treat the current start element as plain text.
      node.text = node.text?.appending("<\(elementName)") ?? "<\(elementName)"
      // Append it's attributes
      for (key, value) in attributeDict {
        node.text! += " \(key)=\"\(value)\""
      }
      node.text = node.text?.appending(">") ?? node.text
    } else {
      // If it's not an XHTML element, and no attributes are present, create a
      // node with the element name.
      if attributeDict.isEmpty {
        stack.push(.init(
          prefix: prefix,
          name: elementName
        ))
      } else {
        // If attributes are found, treat them as child nodes of the element.
        // Each attribute is added as a child node with its key and value.
        stack.push(.init(
          prefix: prefix,
          name: elementName,
          children: [
            .init(
              name: "@attributes",
              children: attributeDict.map {
                .init(
                  name: $0,
                  text: Self.sanitize(attributeValue: $1)
                )
              }
            )
          ]
        ))
      }
    }
  }

  func parser(
    _: XMLParser,
    foundCharacters string: String
  ) {
    map(string)
  }

  func parser(
    _ parser: XMLParser,
    foundCDATA CDATABlock: Data
  ) {
    // Attempts to decode a CDATA block to an encoding, ordered by priority
    for encoding in XMLReader.encodings {
      if let string = String(data: CDATABlock, encoding: encoding) {
        map(string)
        return
      }
    }

    // If decoding fails, report an error and abort parsing
    error = .cdataDecoding(element: stack.top()?.name ?? "")
    parser.abortParsing()
  }

  func parser(
    _: XMLParser,
    didEndElement elementName: String,
    namespaceURI _: String?,
    qualifiedName _: String?
  ) {
    guard let node = stack.top() else {
      return
    }

    // If exiting an XHTML element, close it as plain text.
    if node.isXhtml, node.name != elementName {
      node.text = (node.text ?? "") + "</\(elementName)>"
      return
    }

    // Sanitize the node's text by trimming whitespace and newlines.
    // If the resulting text is empty, set it to nil.
    node.text = Self.trimmed(node.text)

    guard stack.count > 1, let node = stack.pop() else {
      isComplete = true
      return
    }

    stack.top()?.addChild(node)
  }

  func parserDidEndDocument(
    _: XMLParser
  ) {
    #if DEBUG
      if !isComplete {
        print("Parsing ended without reaching the root path.")
      }
    #endif
  }

  func parser(
    _: XMLParser,
    parseErrorOccurred parseError: Error
  ) {
    // Ignore errors reported once the root element has been closed: the tree is
    // as complete as the document made it, and what follows the XML — a stray
    // "[]", a truncated tail — cannot change it.
    guard !isComplete, error == nil else {
      return
    }
    error = .unexpected(reason: parseError.localizedDescription)
  }
}

// MARK: - Encodings

extension XMLReader {
  /// The encodings a CDATA block is decoded with, in the order they are tried
  private static let encodings: [String.Encoding] = [
    .utf8, // Most common encoding
    .isoLatin1, // ISO-8859-1 (Latin-1) is common for Western European languages
    .windowsCP1252, // Common in Western European Windows environments
    .shiftJIS, // Common for Japanese text
    .utf16, // UTF-16 for documents that use 2-byte encoding
    .utf16LittleEndian, // Little-endian UTF-16 encoding
    .utf16BigEndian, // Big-endian UTF-16 encoding
    .isoLatin2, // ISO-8859-2 for Central and Eastern European languages
    .windowsCP1250, // Windows-1250 for Central European languages
    .windowsCP1251 // Windows-1251 for Cyrillic-based languages
  ]
}
