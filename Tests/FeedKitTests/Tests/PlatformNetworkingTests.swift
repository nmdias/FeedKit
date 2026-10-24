//
// PlatformNetworkingTests.swift
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

@testable import FeedKit
import Foundation
import Testing

/// FeedKit's local parsing surface must not depend on networking. Only the
/// URL-fetching initializers are allowed to require `URLSession`, which WASI's
/// Foundation does not provide.
struct PlatformNetworkingTests: FeedKitTestable {
  // MARK: Internal

  @Test
  func parsesFromDataWithoutNetworking() throws {
    // Given
    let data: Data = .init(atomXML.utf8)

    // When
    let feed = try Feed(data: data)

    // Then
    #expect(feed.atom?.title?.text == "FeedKit")
  }

  @Test
  func parsesFromStringWithoutNetworking() throws {
    // When
    let feed = try Feed(string: atomXML)

    // Then
    #expect(feed.atom?.title?.text == "FeedKit")
  }

  #if !os(WASI)
    @Test
    func parsesFromLocalFileURLWithoutNetworking() throws {
      // Given
      let fileURL = url(resource: "Atom", withExtension: "xml")

      // When
      let feed = try Feed(fileURL: fileURL)

      // Then
      #expect(feed.atom != nil)
    }

    @Test
    func localFileURLStringDoesNotUseTheTransport() async throws {
      // Given
      let fileURL = url(resource: "Atom", withExtension: "xml")

      // When
      let feed = try await Feed(urlString: fileURL.absoluteString)

      // Then
      #expect(feed.atom != nil)
    }

    /// The URL-fetching initializers stay available wherever networking exists.
    /// Referencing them as function values is a compile-time check and makes no
    /// network request.
    @Test
    func networkingInitializersRemainAvailable() {
      let _: (String) async throws -> Feed = Feed.init(urlString:)
      let _: (URL) async throws -> Feed = Feed.init(url:)
      let _: (URL) async throws -> Feed = Feed.init(remoteURL:)
    }
  #else
    /// WASI has no `URLSession`. This suite is compiled for WASI by the Wasm CI
    /// job; if a networking symbol leaks back into the local surface, that job
    /// fails to build before this test can run.
    @Test
    func parsesFromDataOnWASI() throws {
      let feed = try Feed(data: Data(atomXML.utf8))
      #expect(feed.atom?.title?.text == "FeedKit")
    }
  #endif

  // MARK: Private

  /// A minimal Atom feed kept inline so the local parsing tests do not depend
  /// on bundled resources.
  private let atomXML = """
  <?xml version="1.0" encoding="UTF-8"?>
  <feed xmlns="http://www.w3.org/2005/Atom">
    <title>FeedKit</title>
    <id>https://example.com/</id>
    <updated>2026-01-01T00:00:00Z</updated>
  </feed>
  """
}
