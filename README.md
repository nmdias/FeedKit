# IrisKit

An RSS/Atom feed parser

[![Build Status](https://travis-ci.org/nmdias/IrisKit.svg)](https://travis-ci.org/nmdias/IrisKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/IrisKit.svg)](https://cocoapods.org/pods/IrisKit)
[![Platform](https://img.shields.io/cocoapods/p/IrisKit.svg?style=flat)](http://cocoadocs.org/docsets/IrisKit)

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+
- Xcode 7.3+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate IrisKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'IrisKit', '~> 1.1'
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
To integrate IrisKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "nmdias/IrisKit" ~> 1.1
```
Build the framework:

```bash
$ carthage update
```
Then, drag the built `IrisKit.framework` into your Xcode project.

## License

IrisKit is released under the MIT license. See LICENSE for details.



