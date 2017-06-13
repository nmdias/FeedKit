
# FeedKit

An RSS, Atom and JSON Feed parser written in Swift
## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To give `FeedKit` a try with an example project, run the following command: 

```bash
$ pod try FeedKit
```

To integrate `FeedKit` into your Xcode project, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'FeedKit', '~> 6.0'
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
To integrate FeedKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "nmdias/FeedKit" ~> 6.0
```
Build the framework:

```bash
$ carthage update
```
Then, drag the built `FeedKit.framework` into your Xcode project.

### Manually

Drag `FeedKit.xcodeproj` into your Xcode project.

 > It should appear nested underneath your application's blue project icon.
 
Click on the `+` button under the "Embedded Binaries" section of your app's target and select the `FeedKit.framework` that matches the desired platform.

## License

FeedKit is released under the MIT license. See [LICENSE](https://github.com/nmdias/FeedKit/blob/master/LICENSE) for details.



