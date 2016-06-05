# FeedParser

An RSS and Atom feed parser written in Swift

[![Build Status](https://travis-ci.org/nmdias/FeedParser.svg)](https://travis-ci.org/nmdias/FeedParser)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/FeedParser.svg)](https://cocoapods.org/pods/FeedParser)
[![Platform](https://img.shields.io/cocoapods/p/FeedParser.svg?style=flat)](http://cocoadocs.org/docsets/FeedParser)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/FeedParser.svg)](http://cocoadocs.org/docsets/FeedParser/)

## Features

- [x] [Atom Syndication Format](https://tools.ietf.org/html/rfc4287)
- [x] [RSS/RSS2+](http://cyber.law.harvard.edu/rss/rss.html) 
- [x] RSS-DEV Namespaces
 - [x] [Dublin Core](http://web.resource.org/rss/1.0/modules/dc/)
 - [x] [Syndication](http://web.resource.org/rss/1.0/modules/syndication/)
 - [x] [Content](http://web.resource.org/rss/1.0/modules/content/)
- [x] [Documentation](http://cocoadocs.org/docsets/FeedParser)
- [x] Unit Test Coverage

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7.3+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate FeedParser into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'FeedParser', '~> 3.0'
end
```

Then, run the following command:

```bash
$ pod install
```

Or, if you just wish try it out, run the following command:

```bash
$ pod try FeedParser
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a dependency manager that builds your dependencies and provides you with binary frameworks.

To install Carthage with [Homebrew](http://brew.sh/) use the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate FeedParser into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "nmdias/FeedParser" ~> 2.1
```
Build the framework:

```bash
$ carthage update
```
Then, drag the built `FeedParser.framework` into your Xcode project.

## Usage
    
### RSS Feed Parsing
    
```swift
import FeedParser

let URL = NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

FeedParser(URL: URL)?.parse({ (result) in
    result.rssFeed // An `RSSFeed` model
})
```

### Atom Feed Parsing
    
```swift
FeedParser(URL: URL)?.parse({ (result) in
    result.atomFeed // An `AtomFeed` model
})
```

> Aditional initializers can also be found for `NSData` and `NSInputStream` objects.

### Parse Result
Multiple `FeedType`'s and, or `Error handling` can be acomplished using the `Result` enum

```swift
FeedParser(URL: URL)?.parse({ (result) in
    
    switch result {
    case .RSS(let rssFeed):
        print(rssFeed)
    case .Atom(let atomFeed):
        print(atomFeed)
    case .Failure(let error):
        print(error)
    }
    
})
```

### Model Preview

#### RSSFeed

```swift
FeedParser(URL: URL)?.parse({ (result) in
    
    guard let feed = result.rssFeed where result.isSuccess else {
        print(result.error)
        return
    }
    
    print(feed.title)                      // The feed's `Title`
    print(feed.items?.count)               // The number of articles
    print(feed.items?.first?.title)        // The feed's first article `Title`
    print(feed.items?.first?.description)  // The feed's first article `Description`
    print(feed.items?.first?.pubDate)      // The feed's first article `Publication Date`
    
})
```
> Refer to the [`RSSFeed` documentation](http://cocoadocs.org/docsets/FeedParser) for the complete model description

#### AtomFeed

```swift
FeedParser(URL: URL)?.parse({ (result) in
    
    guard let feed = result.atomFeed where result.isSuccess else {
        print(result.error)
        return
    }
    
    print(feed.title)                    // The feed's `Title`
    print(feed.entries?.count)           // The number of articles
    print(feed.entries?.first?.title)    // The feed's first article `Title`
    print(feed.entries?.first?.summary)  // The feed's first article `Summary`
    print(feed.entries?.first?.updated)  // The feed's first article `Updated Date`
    
})
```
> Refer to the [`AtomFeed` documentation](http://cocoadocs.org/docsets/FeedParser) for the complete model description

## License

FeedParser is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedParser/blob/master/LICENSE) for details.



