![FeedKit](/FeedKit.png?raw=true)

[![build status](https://travis-ci.org/nmdias/FeedKit.svg)](https://travis-ci.org/nmdias/FeedKit)
[![cocoapods compatible](https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg)](https://cocoapods.org/pods/FeedKit)
[![carthage compatible](https://img.shields.io/badge/carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![language](https://img.shields.io/badge/spm-compatible-brightgreen.svg)](https://swift.org)
[![swift](https://img.shields.io/badge/swift-4.2-orange.svg)](https://github.com/nmdias/DefaultsKit/releases)

## Features

- [x] [Atom](https://tools.ietf.org/html/rfc4287)
- [x] RSS [0.90](http://www.rssboard.org/rss-0-9-0), [0.91](http://www.rssboard.org/rss-0-9-1), [1.00](http://web.resource.org/rss/1.0/spec), [2.00](http://cyber.law.harvard.edu/rss/rss.html)
- [x] [JSON](https://jsonfeed.org/version/1)  
- [x] Namespaces
    - [x] [Dublin Core](http://web.resource.org/rss/1.0/modules/dc/)
    - [x] [Syndication](http://web.resource.org/rss/1.0/modules/syndication/)
    - [x] [Content](http://web.resource.org/rss/1.0/modules/content/)
    - [x] [Media RSS](http://www.rssboard.org/media-rss)
    - [x] [iTunes Podcasting Tags](https://help.apple.com/itc/podcasts_connect/#/itcb54353390)
- [x] [Documentation](http://cocoadocs.org/docsets/FeedKit)
- [x] Unit Test Coverage

## Requirements

![xcode](https://img.shields.io/badge/xcode-10.1%2b-lightgrey.svg)
![ios](https://img.shields.io/badge/ios-8.0%2b-lightgrey.svg)
![tvos](https://img.shields.io/badge/tvos-9.0%2b-lightgrey.svg)
![watchos](https://img.shields.io/badge/watchos-2.0%2b-lightgrey.svg)
![mac os](https://img.shields.io/badge/mac%20os-10.10%2b-lightgrey.svg)
![mac os](https://img.shields.io/badge/ubuntu-16.04+-lightgrey.svg)

Installation >> [`instructions`](https://github.com/nmdias/FeedKit/blob/master/INSTALL.md) <<

## Usage

Build a URL pointing to an RSS, Atom or JSON Feed.
```swift
let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!
```

Get an instance of `FeedParser`
```swift
let parser = FeedParser(URL: feedURL) // or FeedParser(data: data) or FeedParser(xmlStream: stream)
```

Then call `parse` or `parseAsync` to start parsing the feed...

> A **common scenario** in UI environments would be parsing a feed **asynchronously** from a user initiated action, such as the touch of a button. e.g.

```swift
// Parse asynchronously, not to block the UI.
parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
    // Do your thing, then back to the Main thread
    DispatchQueue.main.async {
        // ..and update the UI
    }
}
```     

Remember, you are responsible to manually bring the result closure to whichever queue is apropriate. Usually to the Main thread, for UI apps, by calling `DispatchQueue.main.async` .

Alternatively, you can also parse synchronously.

```swift
let result = parser.parse()
```

## Parse Result

Whichever the case, if parsing succeeds you should now have a `Strongly Typed Model` of an `RSS`, `Atom` or `JSON Feed`.
```swift
switch result {
case let .atom(feed):       // Atom Syndication Format Feed Model
case let .rss(feed):        // Really Simple Syndication Feed Model
case let .json(feed):       // JSON Feed Model
case let .failure(error):   
}
```


#### Parse Success
You can check if a Feed was `successfully` parsed or not.
```swift
result.isSuccess    // If parsing was a success
result.isFailure    // If parsing failed
result.error        // An error, if any
```

## Model Preview
Safely bind a feed of your choosing:
> You may find the example bellow useful, if you're dealing with only a single type of feed.
```swift
guard let feed = result.rssFeed, result.isSuccess else {
    print(result.error)
    return
}
```
Then go through it's properties:

> The RSS and Atom feed Models are rather extensive throughout the supported namespaces. These are just a preview of what's available.

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

> Refer to the [`documentation`](http://cocoadocs.org/docsets/FeedKit) for the complete model properties and descriptions

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

> Refer to the [`documentation`](http://cocoadocs.org/docsets/FeedKit) for the complete model properties and descriptions

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

> Refer to the [`documentation`](http://cocoadocs.org/docsets/FeedKit) for the complete model properties and descriptions

## License

FeedKit is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedKit/blob/master/LICENSE) for details.



