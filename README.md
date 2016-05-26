# FeedParser

An RSS and Atom feed parser written in Swift

[![Build Status](https://travis-ci.org/nmdias/FeedParser.svg)](https://travis-ci.org/nmdias/FeedParser)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/FeedParser.svg)](https://cocoapods.org/pods/FeedParser)
[![Platform](https://img.shields.io/cocoapods/p/FeedParser.svg?style=flat)](http://cocoadocs.org/docsets/FeedParser)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/FeedParser.svg)](http://cocoadocs.org/docsets/FeedParser/)

## Developer's Notice

FeedParser is under active development and it's `2.1.0` release successfully parses all versions of the RSS specification, from `RSS 0.90` to `RSS 2.0.0`.  Atom feeds support will be made available in version `3.0.0`.

###### 3.0.0

The objectives of the 3.0.0 release are to make `FeedParser` fully documented and thoroughly mappable to a strongly typed model with:

 - [x] 100% RSS compatibility, as defined by the Berkman Center for Internet & Society at Harvard Law School [specification](http://cyber.law.harvard.edu/rss/rss.html) 
 - [ ] 100% extensible to the Module's namespace defined by the [RSS-DEV Working Group](http://web.resource.org/rss/)
  - [x] Dublin Core
  - [x] Syndication
  - [ ] Content
 - [ ] 100% Atom compatibility, as defined by the Atom Syndication Format specification at [RFC 5988](https://tools.ietf.org/html/rfc4287)

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
  pod 'FeedParser', '~> 2.1'
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

## License

FeedParser is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedParser/blob/master/LICENSE) for details.



