<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/nmdias/FeedKit/raw/main/Assets/FeedKit-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/nmdias/FeedKit/raw/main/Assets/FeedKit.svg">
  <img width="500px" alt="FeedKit Logo" src="https://github.com/nmdias/FeedKit/raw/main/Assets/FeedKit.svg">
</picture>

<p/>  

[![CI](https://github.com/nmdias/FeedKit/actions/workflows/ci.yml/badge.svg)](https://github.com/nmdias/FeedKit/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnmdias%2FFeedKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nmdias/FeedKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnmdias%2FFeedKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nmdias/FeedKit)

FeedKit is a Swift library for Reading and Generating RSS, Atom, and JSON feeds.

# Features

- [x] [Atom](https://tools.ietf.org/html/rfc4287)
- [x] [RSS](http://cyber.law.harvard.edu/rss/rss.html)
- [x] [JSON](https://jsonfeed.org)
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
- [x] [Documentation](https://swiftpackageindex.com/nmdias/FeedKit/main/documentation/feedkit)
- [x] Unit Tests

## Feed Reader

Feed reading can be made with a **dedicated** type, such as `RSSFeed`, `AtomFeed` and `JSONFeed`, or a **universal** type `Feed`.

### Dedicated

When you know the type of feed to be read, use a dedicated type.

```swift
try await RSSFeed(urlString: "https://developer.apple.com/news/rss/news.rss")
```

### Universal

When you don't know the type of feed, use the universal `Feed` enum type.

The `Feed` enum type handles **RSS**, **Atom** and **JSON** feeds and will determine the type of feed before reading, parsing and decoding occurs.

```swift
// Read any type of feed
let feed = try await Feed(urlString: "https://surprise.me/feed")

// Use a switch to get the resulting feed model
switch feed {
case let .atom(feed): // An AtomFeed instance
case let .rss(feed): // An RSSFeed instance
case let .json(feed): // A JSONFeed instance
}
```

#### Manual Feed Type Detection

The universal `Feed` enum above automatically determines the feed type, so you generally don't need to do it manually. However, using a `FeedType` enum can be helpful when you want to **identify the type of feed without
the overhead of parsing and decoding**.

<details>
  <summary>Show</summary>

```swift
let feedType = try FeedType(data: data)

// Detect feed type
switch feedType {
case .rss: // RSS feed detected
case .atom: // Atom feed detected
case .json: // JSON feed detected
}

// Or feed content type
if feedType.isXML {
  // XML feed detected
} else if feedType.isJson {
  // JSON feed detected
}
```

</details>

### Initializers

All feed types conform to `FeedInitializable`, sharing multiple common initializers. They provide a flexible way to read feeds from the most common sources.

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

</details>

## Feed Generator

### XML

To generate an XML string for any given XML feed, create an instance of an `RSSFeed` or `AtomFeed` and populate it with the necessary data.

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

Then call `toXMLString(formatted:)` to generate the XML string.

```swift
try feed.toXMLString(formatted: true)
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

### JSON

In the same way, you can create an instance of a `JSONFeed`, populate it, and then call `toJSONString(formatted:)` to generate a JSON string.

```swift
try feed.toJSONString(formatted: true)
```

## Feed Models

The **RSS**, **Atom**, and **JSON** feed models are highly comprehensive, especially when combined with all the supported namespaces. Below is a small preview of what’s available.

<details>
<summary>Preview</summary>

#### RSS

```swift
channel.title
channel.link
channel.description
channel.language
channel.copyright
channel.managingEditor
channel.webMaster
channel.pubDate
channel.lastBuildDate
channel.categories
channel.generator
channel.docs
channel.cloud
channel.rating
channel.ttl
channel.image
channel.textInput
channel.skipHours
channel.skipDays
// ...
channel.dublinCore
channel.syndication
channel.iTunes
channel.atom
// ...

let item = channel.items?.first

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
entry?.media
entry?.youTube
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
