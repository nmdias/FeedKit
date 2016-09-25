# Change Log

## [5.0.0](https://github.com/nmdias/FeedParser/releases/tag/5.0.0)
### Added
- Support for Swift 3.0

## [4.1.0](https://github.com/nmdias/FeedParser/releases/tag/4.1.0)
### Added
- Support for Xcode 8 (Swift 2.3)

## [4.0.0](https://github.com/nmdias/FeedParser/releases/tag/4.0.0)
The `FeedParser` framework has been renamed `FeedKit` to prevent conflicts between the `FeedParser` module and the `FeedParser` class naming

## [3.1.0](https://github.com/nmdias/FeedParser/releases/tag/3.1.0)
### Added
- Dates support
 - RFC822
 - RFC3999
 - ISO8601

## [3.0.0](https://github.com/nmdias/FeedParser/releases/tag/3.0.0)
### Added
- Support for Atom feeds according to RFC 4287
- Unit tests for the Atom specification
- Parse error handling
- Parse error handling unit tests
- NSData initializer
- NSInputStream initializer
- Parse performance unit tests

### Updated
- Unit tests for the RSS specification
- Unit tests for the Content Module specification
- Unit tests for the Dublin Core Module specification
- Unit tests for the Syndication Module specification
- Tracking of the current XML DOM element being parsed with improved type safety
- Consistent use of integer values to aid code interoperability
- Syndication module Update Period mapping reliability
- Consistency to the `Given`, `When`, `Then` unit test pattern

### Removed
- Types of the RSS feed model dropped the explicit version `2` 
- Internal helper `Debug.log(_)`
- Usage of `assertionFailure(_)`

### Fixed
- Issue where the `module 'FeedParser' was not compiled for testing` when testing Release builds
- Issue where both Atom and RSS models were initialized despite the type of feed being parsed
- Issue where the `syndication` namespace was not initialized properly causing child elements to also be `nil`

## [2.1.0](https://github.com/nmdias/FeedParser/releases/tag/2.1.0)
### Added
- watchOS Support
- Automated Tests and Builds for Travic-CI
- Copyright notices 
- Improved README instructions and readability

### Fixed
- An issue where Tests would fail when running in release mode

## [2.0.0](https://github.com/nmdias/FeedParser/releases/tag/2.0.0)
Iris has been renamed `FeedParser` to better reflect it's purpose and discoverability.

## [1.1.1](https://github.com/nmdias/FeedParser/releases/tag/1.1.1)
### Added
- Tests for the `RSS2` model
- Tests for the `Content Module` model
- Tests for the `DublinCore Module` model
- Tests for the `Syndication Module` model

## [1.1.0](https://github.com/nmdias/FeedParser/releases/tag/1.1.0)
### Added
- Support for SPM
- Support for Cocoapods

## [1.0.0](https://github.com/nmdias/FeedParser/releases/tag/1.0.0)
### Added
- Initial Release of Iris
