# FeedKit

An RSS, Atom and JSON Feed parser written in Swift

[![build status](https://travis-ci.org/nmdias/FeedKit.svg)](https://travis-ci.org/nmdias/FeedKit)
[![carthage compatible](https://img.shields.io/badge/carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![cocoapods compatible](https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg)](https://cocoapods.org/pods/FeedKit)
[![cocoapods compatible](https://img.shields.io/cocoapods/v/FeedKit.svg)](https://img.shields.io/cocoapods/v/FeedKit.svg)
[![language](https://img.shields.io/badge/swift-v3.0-orange.svg)](https://swift.org)
[![documentation](https://img.shields.io/cocoapods/metrics/doc-percent/FeedKit.svg)](http://cocoadocs.org/docsets/FeedKit/)

## Features

- [x] [Atom Syndication Format](https://tools.ietf.org/html/rfc4287)
- [x] [RSS2](http://cyber.law.harvard.edu/rss/rss.html) 
- [x] Namespaces
    - [x] [Dublin Core](http://web.resource.org/rss/1.0/modules/dc/)
    - [x] [Syndication](http://web.resource.org/rss/1.0/modules/syndication/)
    - [x] [Content](http://web.resource.org/rss/1.0/modules/content/)
    - [x] [Media RSS](http://www.rssboard.org/media-rss)
    - [x] [iTunes Podcasting Tags](https://help.apple.com/itc/podcasts_connect/#/itcb54353390)
- [x] Dates Support
    - [x] [RFC822](https://www.ietf.org/rfc/rfc0822.txt)
    - [x] [RFC3999](https://www.ietf.org/rfc/rfc3339.txt)
    - [x] [ISO8601](http://www.w3.org/TR/NOTE-datetime)
- [x] [Documentation](http://cocoadocs.org/docsets/FeedKit)
- [x] Unit Test Coverage

## Requirements

![ios](https://img.shields.io/badge/ios-8.0%2b-lightgrey.svg)
![tvos](https://img.shields.io/badge/tvos-9.0%2b-lightgrey.svg)
![watchos](https://img.shields.io/badge/watchos-2.0%2b-lightgrey.svg)
![mac os](https://img.shields.io/badge/mac%20os-10.9%2b-lightgrey.svg)
![xcode](https://img.shields.io/badge/xcode-8.0%2b-lightgrey.svg)

Installation >> [`instructions`](https://github.com/nmdias/FeedKit/blob/master/INSTALL.md) <<

## Usage

Build a URL pointing to an RSS, Atom or JSON Feed.
```swift
let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!
```

FeedKit will do asynchronous parsing on the main queue by default. You can safely update your UI from within the result closure.
```swift
FeedParser(URL: feedURL)?.parseAsync { result in
    // Do your thing
}
```     

If a different queue is specified, you are responsible to manually bring the result closure to whichever queue is apropriate. Usually `DispatchQueue.main.async`. If you're unsure, don't provide the `queue` parameter.
```swift
FeedParser(URL: feedURL)?.parseAsync(queue: myQueue, result: { (result) in 
    // Do your thing
})
```

Alternatively, you can also call `parse` synchronously.
```swift
let result = FeedParser(URL: feedURL)?.parse()
```

#### Initializers

> An aditional initializer can also be found for `Data` objects.
```swift
FeedParser(data: data)
```

#### Feed Models
FeedKit provides `strongly typed` models for `RSS`, `Atom` and `JSON Feed` formats.    
```swift
result.rssFeed      // Really Simple Syndication Feed Model
result.atomFeed     // Atom Syndication Format Feed Model
result.jsonFeed     // JSON Feed Model
```


#### Parsing Success
You can also check if a Feed was successfully parsed or not.
```swift
result.isSuccess    // If parsing was a success
result.isFailure    // If parsing failed
result.error        // An error, if any
```

### Handling Multiple Feeds
Multiple `Feed Types` and `Error` handling can be acomplished using a parse `Result` like this:

```swift
switch result {

case let .atom(feed):       break
case let .rss(feed):        break
case let .json(feed):       break
case let .failure(error):   break

}
```

### Model Preview
Safely bind a feed of your choosing:
```swift
guard let feed = result.rssFeed, result.isSuccess else {
    print(result.error)
    return
}
```
Then go through it's properties. The RSS, Atom and JSON Feed Models are rather extensive. These are just a preview.
#### RSS

```swift
print(feed.title)
print(feed.description)
print(feed.image)
print(feed.pubDate)
// ...

let item = feed.items?.first

print(item?.title)
print(item?.description)
print(item?.pubDate)
// ...
```

> Refer to the [`documentation`](http://cocoadocs.org/docsets/FeedKit) for the complete model properties and description

#### Atom

```swift
print(feed.title)
print(feed.subtitle)
print(feed.logo)
print(feed.updated)
// ...

let entry = feed.entries?.first

print(entry?.title)
print(entry?.summary)
print(entry?.updated)
// ...
```

> Refer to the [`documentation`](http://cocoadocs.org/docsets/FeedKit) for the complete model properties and description

#### JSON

```swift
print(feed.title)
print(feed.description)
print(feed.icon)
print(feed.expired)
// ...

let item = feed.items?.first

print(item?.title)
print(item?.summary)
print(item?.datePublished)
// ...
```

> Refer to the [`documentation`](http://cocoadocs.org/docsets/FeedKit) for the complete model properties and description

Installation >> [`instructions`](https://github.com/nmdias/FeedKit/blob/master/INSTALL.md) <<

## License

FeedKit is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedKit/blob/master/LICENSE) for details.



