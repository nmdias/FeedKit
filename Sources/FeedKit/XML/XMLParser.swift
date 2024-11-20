//
//  XMLParser.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

class XMLParser: NSObject {
  /// The XML Parser.
  let parser: Foundation.XMLParser
  /// A stack of `XMLElement` instances representing the current hierarchy
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

  /// Initializes the wrapper with XML data.
  /// - Parameter data: The XML data to parse.
  init(data: Data) {
    parser = Foundation.XMLParser(data: data)
    stack = XMLStack()
    super.init()
    parser.delegate = self

  }

  /// Parses the XML data and returns a `Result` indicating success or failure.
  /// - Returns: A `Result` with the parsed document on success, or an error.
  func parse() -> Result<XMLDocument, XMLError> {
    // Starts the parsing process. If parsing fails or an error occurs,
    // returns a failure result with the existing error or an unknown error.
    guard
      parser.parse(),
      error == nil,
      let root = stack.pop() else {
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
    guard let element = stack.top() else { return }
    let trim = string.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trim.isEmpty else { return }
    if let text = element.text {
      element.text = text + trim
    } else {
      element.text = trim
    }
  }
}

// MARK: - XMLParserDelegate

extension XMLParser: XMLParserDelegate {
  func parser(
    _ parser: Foundation.XMLParser,
    didStartElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?,
    attributes attributeDict: [String: String] = [:]) {
    if attributeDict.isEmpty {
      stack.push(.init(name: elementName))
    } else {
      stack.push(.init(name: elementName, attributes: attributeDict))
    }
  }

  func parser(
    _ parser: Foundation.XMLParser,
    foundCharacters string: String) {
    map(string)
  }

  func parser(
    _ parser: Foundation.XMLParser,
    foundCDATA CDATABlock: Data) {
    // Attempts to decode a CDATA block to a UTF-8 string.
    // If decoding fails, records a decoding error and aborts parsing.
    guard let string = String(data: CDATABlock, encoding: .utf8) else {
      error = .cdataDecoding(element: stack.top()?.name ?? "")
      parser.abortParsing()
      return
    }
    map(string)
  }

  func parser(
    _ parser: Foundation.XMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?) {
    guard stack.count > 1, let element = stack.pop() else {
      isComplete = true
      return
    }
    stack.top()?.children.append(element)
  }

  func parserDidEndDocument(
    _ parser: Foundation.XMLParser) {
    #if DEBUG
      if !isComplete {
        print("Parsing ended without reaching the root path.")
      }
    #endif
  }

  func parser(
    _ parser: Foundation.XMLParser,
    parseErrorOccurred parseError: Error) {
    // Ignore errors that occur after a feed is successfully parsed. Some
    // real-world feeds contain junk such as "[]" after the XML segment;
    // just ignore this stuff.
    // https://github.com/nmdias/FeedKit/pull/53
    guard !isComplete, error == nil else { return }
    error = .unexpected(reason: parseError.localizedDescription)
  }
}
