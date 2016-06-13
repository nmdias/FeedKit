# FeedParser

An RSS and Atom feed parser written in Swift

[![build status](https://travis-ci.org/nmdias/FeedParser.svg)](https://travis-ci.org/nmdias/FeedParser)
[![carthage compatible](https://img.shields.io/badge/carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![cocoapods compatible](https://img.shields.io/badge/cocoapods-compatible-brightgreen.svg)](https://cocoapods.org/pods/FeedParser)
[![cocoapods compatible](https://img.shields.io/cocoapods/v/FeedParser.svg)](https://img.shields.io/cocoapods/v/FeedParser.svg)
[![language](https://img.shields.io/badge/swift-v2.2-orange.svg)](https://swift.org)
[![documentation](https://img.shields.io/cocoapods/metrics/doc-percent/FeedParser.svg)](http://cocoadocs.org/docsets/FeedParser/)

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

![ios](https://img.shields.io/badge/ios-8.0%2b-lightgrey.svg)
![tvos](https://img.shields.io/badge/tvos-9.0%2b-lightgrey.svg)
![watchos](https://img.shields.io/badge/watchos-2.0%2b-lightgrey.svg)
![mac os](https://img.shields.io/badge/mac%20os-10.9%2b-lightgrey.svg)
![xcode](https://img.shields.io/badge/xcode-7.3%2b-lightgrey.svg)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To give `FeedParser` a try with an example project, run the following command: 

```bash
$ pod try FeedParser
```

To integrate `FeedParser` into your Xcode project, specify it in your `Podfile`:

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

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a dependency manager that builds your dependencies and provides you with binary frameworks.

To install Carthage with [Homebrew](http://brew.sh/) use the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate FeedParser into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "nmdias/FeedParser" ~> 3.0
```
Build the framework:

```bash
$ carthage update
```
Then, drag the built `FeedParser.framework` into your Xcode project.

## Usage

### Feed Parsing
    
#### RSS
    
```swift
import FeedParser

let URL = NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

FeedParser(URL: URL)?.parse({ (result) in
    result.rssFeed // An `RSSFeed` model
})
```

#### Atom
    
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
        print(rssFeed) // An `RSSFeed` model
    case .Atom(let atomFeed):
        print(atomFeed) // An `AtomFeed` model
    case .Failure(let error):
        print(error) // An `NSError` object
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
> Refer to the [`RSSFeed`](http://cocoadocs.org/docsets/FeedParser) documentation for the complete model properties and description

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
> Refer to the [`AtomFeed`](http://cocoadocs.org/docsets/FeedParser) documentation for the complete model properties and description

### Background Parsing

```swift
dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
    // Run parsing in a background thread
    FeedParser(URL: URL)?.parse({ (result) in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Perform updates to the UI
        })
    })
})
```     

## License

FeedParser is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedParser/blob/master/LICENSE) for details.



