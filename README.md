![FeedKit](/FeedKit.png?raw=true)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnmdias%2FFeedKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nmdias/FeedKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnmdias%2FFeedKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nmdias/FeedKit)

FeedKit is a Swift library for Parsing and Generating RSS, Atom, and JSON feeds.

## Features

- [x] [Atom](https://tools.ietf.org/html/rfc4287)
- [x] RSS [0.90](http://www.rssboard.org/rss-0-9-0), [0.91](http://www.rssboard.org/rss-0-9-1), [1.00](http://web.resource.org/rss/1.0/spec), [2.00](http://cyber.law.harvard.edu/rss/rss.html)
- [x] JSON [1.0](https://jsonfeed.org/version/1)
- [x] Namespaces
  - [x] [Atom](http://www.w3.org/2005/Atom)
  - [x] [Dublin Core](http://purl.org/dc/elements/1.1/)
  - [x] [Syndication](http://purl.org/rss/1.0/modules/syndication/)
  - [x] [Content](http://purl.org/rss/1.0/modules/content/)
  - [x] [Media RSS](http://search.yahoo.com/mrss/)
  - [x] [Geo RSS](http://www.georss.org/georss)
  - [x] [GML](http://www.opengis.net/gml)
  - [x] [iTunes](http://www.itunes.com/dtds/podcast-1.0.dtd)
  - [x] [YouTube](http://www.youtube.com/xml/schemas/2015)
- [x] Examples
- [x] Documentation
- [x] Unit Tests

### FeedKit v10 :warning:

FeedKit `v10` is currently in **beta**. It should be stable enough :eyes:, but if stable enough is not enough, consider using **[`v9`](https://github.com/nmdias/FeedKit/releases/tag/9.1.2)** for now. The beta version includes a new parsing engine, features and improvements, and may contain bugs that still need to be ironed out and unit tested.

## Usage

The `RSSFeed`, `AtomFeed` and `JSONFeed` structs makes it easy to fetch and parse feeds from a URL. Here's how to use it:

```swift
try await RSSFeed(urlString: "https://developer.apple.com/news/rss/news.rss")
```

## Universal Feed Parser

The `Feed` enum allows you to handle various feed formats, including `RSS`, `Atom`, `RDF`, and `JSON` feeds. This makes it a versatile solution for parsing any type of feed.

```swift
// Initialize and parse a feed
let feed = try await Feed(urlString: "https://example.com/feed")

// Use a switch to handle different feeds explicitly
switch feed {
case let .atom(feed):   // Atom Syndication Format Feed Model
case let .rss(feed):    // Really Simple Syndication Feed Model
case let .json(feed):   // JSON Feed Model
// ...
}

// Or through optional properties
feed.rssFeed // feed.atomFeed, feed.jsonFeed, ...
```

## Feed Generation

To generate XML for a Feed, create an instance of an `RSSFeed`, `AtomFeed` or `JSONFeed` and populate it with the necessary data.

```swift
let feed = RSSFeed(
  channel: .init(
    title: "Breaking News",
    link: "http://www.breakingnews.com/",
    description: "Get the latest updates as they happen.",
    // ...
    items: [
      .init(
        title: "Breaking News: All Hearts are Joyful",
        link: "http://breakingnews.com/2025/01/09/joyful-hearts",
        description: "A heartwarming story of unity and celebration."
        // ...
      ),
    ]
  )
)
```

Then call `toXMLString(formatted:)` to generate an XML string.

```swift
let xmlString = try feed.toXMLString(formatted: true)
```

<details>
  <summary>Output</summary>

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>Breaking News</title>
    <link>http://www.breakingnews.com/</link>
    <description>Get the latest updates as they happen.</description>
    <item>
      <title>Breaking News: All Hearts are Joyful</title>
      <link>http://breakingnews.com/2025/01/09/joyful-hearts</link>
      <description>A heartwarming story of unity and celebration.</description>
    </item>
  </channel>
</rss>
```

</details>

## Initializers

All Feed types, `Feed`, `RSSFeed`, `JSON...` provide various initializers for flexibility in loading and parsing feed data.

<details>
  <summary>Show</summary>

From a URL `String`:

```swift
init(urlString: String) async throws
```

From a `URL`, handling both local file URLs and remote URLs:

```swift
init(url: URL) async throws
```

From a local file `URL`:

```swift
init(fileURL url: URL) throws
```

From a remote `URL`:

```swift
init(remoteURL url: URL) async throws
```

From an XML or JSON `String`:

```swift
init(string: String) throws
```

From raw `Data`:

```swift
init(data: Data) throws
```

These initializers provide a flexible way to load feeds from the most common sources.

</details>

## Feed Models

The `RSS`, `Atom`, and `JSON` feed models are highly comprehensive, especially when combined with the supported namespaces. Below is just a small preview of what’s available.

<details>
<summary>Preview</summary>

#### RSS

```swift
feed.title
feed.link
feed.description
feed.language
feed.copyright
feed.managingEditor
feed.webMaster
feed.pubDate
feed.lastBuildDate
feed.categories
feed.generator
feed.docs
feed.cloud
feed.rating
feed.ttl
feed.image
feed.textInput
feed.skipHours
feed.skipDays
//...
feed.dublinCore
feed.syndication
feed.iTunes
// ...

let item = feed.items?.first

item?.title
item?.link
item?.description
item?.author
item?.categories
item?.comments
item?.enclosure
item?.guid
item?.pubDate
item?.source
//...
item?.dublinCore
item?.content
item?.iTunes
item?.media
// ...
```

#### Atom

```swift
feed.title
feed.subtitle
feed.links
feed.updated
feed.authors
feed.contributors
feed.id
feed.generator
feed.icon
feed.logo
feed.rights
// ...

let entry = feed.entries?.first

entry?.title
entry?.summary
entry?.authors
entry?.contributors
entry?.links
entry?.updated
entry?.categories
entry?.id
entry?.content
entry?.published
entry?.source
entry?.rights
// ...
```

#### JSON

```swift
feed.version
feed.title
feed.homePageURL
feed.feedUrl
feed.description
feed.userComment
feed.nextUrl
feed.icon
feed.favicon
feed.author
feed.expired
feed.hubs
feed.extensions
// ...

let item = feed.items?.first

item?.id
item?.url
item?.externalUrl
item?.title
item?.contentText
item?.contentHtml
item?.summary
item?.image
item?.bannerImage
item?.datePublished
item?.dateModified
item?.author
item?.url
item?.tags
item?.attachments
item?.extensions
// ...
```

</details>

## Installation

To add FeedKit to your Xcode project, follow these steps:

- Open your project in Xcode and go to the "File" menu.
- Select "Add Package Dependencies…"
- Enter the "Package URL": https://github.com/nmdias/FeedKit
- Select "Add Package"

## License

FeedKit is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedKit/blob/master/LICENSE) for details.
