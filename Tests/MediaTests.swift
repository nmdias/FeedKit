//
//  MediaTests.swift
//
//  Copyright (c) 2017 Nuno Manuel Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
import FeedKit

class MediaTests: BaseTestCase {
    
    func testRSSMedia() {
        
        // Given
        let URL = fileURL("RSSMedia", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let media = parser.parse().rssFeed?.items?.first?.media
        
        // Then
        XCTAssertNotNil(media)
        XCTAssertNotNil(media?.mediaThumbnails)
        XCTAssertNotNil(media?.mediaThumbnails?.first)
        XCTAssertNotNil(media?.mediaThumbnails?.first?.attributes)
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.url, "http://www.foo.com/keyframe1.jpg")
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.width, "75")
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.height, "50")
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.time, "12:05:01.123")
        XCTAssertNotNil(media?.mediaThumbnails?.last)
        XCTAssertNotNil(media?.mediaThumbnails?.last?.attributes)
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.url, "http://www.foo.com/keyframe2.jpg")
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.width, "640")
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.height, "480")
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.time, "12:05:01.123")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaContents?.first?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.url, "http://www.foo.com/song64kbps.mp3")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.fileSize, 1000)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.bitrate,64)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.type, "audio/mpeg")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.isDefault, true)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.expression, "full")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaContents?.last?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.url, "http://www.foo.com/song.wav")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.fileSize, 16000)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.bitrate, nil)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.type, "audio/x-wav")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.expression, "full")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits)
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.first)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.value, "entity name")
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.first?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.attributes?.role, "producer")
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.attributes?.scheme, "urn:ebu")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.last)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.value, "copyright holder of the entity")
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.last?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.attributes?.role, "owner")
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.attributes?.scheme, "urn:yvs")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaCategory)
        XCTAssertEqual(media?.mediaGroup?.mediaCategory?.value, "music/artist name/album/song")
        XCTAssertNotNil(media?.mediaGroup?.mediaCategory?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaCategory?.attributes?.label, "Ace Ventura - Pet Detective")
        XCTAssertEqual(media?.mediaGroup?.mediaCategory?.attributes?.scheme, "http://dmoz.org")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaRating)
        XCTAssertEqual(media?.mediaGroup?.mediaRating?.value, "nonadult")
        XCTAssertNotNil(media?.mediaGroup?.mediaRating?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaRating?.attributes?.scheme, "urn:mpaa")
        
        XCTAssertNotNil(media?.mediaContents)
        XCTAssertNotNil(media?.mediaContents?.first?.attributes)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.url, "http://www.foo.com/video.mov")
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.fileSize, 12216320)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.type, "video/quicktime")
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.expression, "full")
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.bitrate, 128)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.framerate, 25.0)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.samplingrate, 44.1)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.channels, 2)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.duration, 185)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.width, 200)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.height, 300)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.lang, "en")
        
        XCTAssertNotNil(media?.mediaContents)
        XCTAssertNotNil(media?.mediaContents?.last?.attributes)
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.url, "http://www.foo.com/movie.mov")
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.fileSize, 12216320)
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.type, "video/quicktime")
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.expression, "full")
        
        XCTAssertNotNil(media?.mediaCommunity)
        XCTAssertNotNil(media?.mediaCommunity?.mediaStarRating)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.average, 3.5)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.count, 20)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.min, 1)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.max, 10)
        
        XCTAssertNotNil(media?.mediaCommunity?.mediaStatistics)
        XCTAssertNotNil(media?.mediaCommunity?.mediaStatistics?.attributes)
        XCTAssertEqual(media?.mediaCommunity?.mediaStatistics?.attributes?.favorites, 5)
        XCTAssertEqual(media?.mediaCommunity?.mediaStatistics?.attributes?.views, 5)
        
        XCTAssertNotNil(media?.mediaCommunity?.mediaTags)
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[0].tag, "news")
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[0].weight, 5)
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[1].tag, "abc")
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[1].weight, 3)
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[2].tag, "reuters")
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[2].weight, 1)
        
        XCTAssertNotNil(media?.mediaComments)
        XCTAssertEqual(media?.mediaComments?.first, "comment1")
        XCTAssertEqual(media?.mediaComments?.last, "comment2")
        
        XCTAssertNotNil(media?.mediaEmbed)
        XCTAssertNotNil(media?.mediaEmbed?.attributes)
        XCTAssertEqual(media?.mediaEmbed?.attributes?.url, "http://www.foo.com/player.swf")
        XCTAssertEqual(media?.mediaEmbed?.attributes?.width, 512)
        XCTAssertEqual(media?.mediaEmbed?.attributes?.height, 323)
        
        XCTAssertNotNil(media?.mediaEmbed?.mediaParams)
        XCTAssertNotNil(media?.mediaEmbed?.mediaParams?.first?.attributes)
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.first?.attributes?.name, "type")
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.first?.value, "application/x-shockwave-flash")
        XCTAssertNotNil(media?.mediaEmbed?.mediaParams?.last?.attributes)
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.last?.attributes?.name, "flashVars")
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.last?.value, "id=12345&vid=678912i&lang=en-us&intl=us&thumbUrl=http://www.foo.com/thumbnail.jpg")
        
        XCTAssertNotNil(media?.mediaResponses)
        XCTAssertEqual(media?.mediaResponses?.first, "http://www.response1.com")
        XCTAssertEqual(media?.mediaResponses?.last, "http://www.response2.com")
        
        XCTAssertNotNil(media?.mediaBackLinks)
        XCTAssertEqual(media?.mediaBackLinks?.first, "http://www.backlink1.com")
        XCTAssertEqual(media?.mediaBackLinks?.last, "http://www.backlink2.com")
        
        XCTAssertNotNil(media?.mediaStatus)
        XCTAssertNotNil(media?.mediaStatus?.attributes)
        XCTAssertEqual(media?.mediaStatus?.attributes?.reason, "http://www.reasonforblocking.com")
        XCTAssertEqual(media?.mediaStatus?.attributes?.state, "blocked")
        
        XCTAssertNotNil(media?.mediaPrices)
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.type, "rent")
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.price, 19.99)
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.currency, "EUR")
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.info, "http://www.dummy.jp/package_info.html")
        
        XCTAssertNotNil(media?.mediaLicense)
        XCTAssertNotNil(media?.mediaLicense?.attributes)
        XCTAssertEqual(media?.mediaLicense?.attributes?.href, "http://www.licensehost.com/license")
        XCTAssertEqual(media?.mediaLicense?.attributes?.type, "text/html")
        XCTAssertEqual(media?.mediaLicense?.value, "Sample license for a video")
        
        XCTAssertNotNil(media?.mediaSubTitle)
        XCTAssertNotNil(media?.mediaSubTitle?.attributes)
        XCTAssertEqual(media?.mediaSubTitle?.attributes?.href, "http://www.foo.org/subtitle.smil")
        XCTAssertEqual(media?.mediaSubTitle?.attributes?.lang, "en-us")
        XCTAssertEqual(media?.mediaSubTitle?.attributes?.type, "application/smil")
        
        XCTAssertNotNil(media?.mediaPeerLink)
        XCTAssertNotNil(media?.mediaPeerLink?.attributes)
        XCTAssertEqual(media?.mediaPeerLink?.attributes?.href, "http://www.foo.org/sampleFile.torrent")
        XCTAssertEqual(media?.mediaPeerLink?.attributes?.type, "application/x-bittorrent")
        
        XCTAssertNotNil(media?.mediaLocation)
        XCTAssertNotNil(media?.mediaLocation?.attributes)
        XCTAssertEqual(media?.mediaLocation?.attributes?.start, TimeInterval(1))
        XCTAssertEqual(media?.mediaLocation?.attributes?.end, TimeInterval(60))
        XCTAssertEqual(media?.mediaLocation?.attributes?.description, "My house")
        XCTAssertEqual(media?.mediaLocation?.latitude, 35.669998)
        XCTAssertEqual(media?.mediaLocation?.longitude, 139.770004)
        
        XCTAssertNotNil(media?.mediaRestriction)
        XCTAssertNotNil(media?.mediaRestriction?.attributes)
        XCTAssertEqual(media?.mediaRestriction?.attributes?.relationship, "allow")
        XCTAssertEqual(media?.mediaRestriction?.attributes?.type, "country")
        XCTAssertEqual(media?.mediaRestriction?.value, "au us")
        
        XCTAssertNotNil(media?.mediaRestriction)
        XCTAssertEqual(media?.mediaRestriction?.attributes?.relationship, "allow")
        XCTAssertEqual(media?.mediaRestriction?.attributes?.type, "country")
        XCTAssertEqual(media?.mediaRestriction?.value, "au us")
        
        XCTAssertNotNil(media?.mediaScenes)
        XCTAssertEqual(media?.mediaScenes?.first?.sceneTitle, "sceneTitle1")
        XCTAssertEqual(media?.mediaScenes?.first?.sceneDescription, "sceneDesc1")
        XCTAssertEqual(media?.mediaScenes?.first?.sceneStartTime, TimeInterval(15))
        XCTAssertEqual(media?.mediaScenes?.first?.sceneEndTime, TimeInterval(45))
        
    }
    
    func testRSSMediaParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "RSS Media Parsing Performance")
            let URL = self.fileURL("RSSMedia", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parseAsync { (result) in
                
                // Then
                expectation.fulfill()
                
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
    func testAtomMedia() {
        
        // Given
        let URL = fileURL("AtomMedia", type: "xml")
        let parser = FeedParser(URL: URL)!
        
        // When
        let media = parser.parse().atomFeed?.entries?.first?.media
        
        // Then
        XCTAssertNotNil(media)
        XCTAssertNotNil(media?.mediaThumbnails)
        XCTAssertNotNil(media?.mediaThumbnails?.first)
        XCTAssertNotNil(media?.mediaThumbnails?.first?.attributes)
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.url, "http://www.foo.com/keyframe1.jpg")
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.width, "75")
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.height, "50")
        XCTAssertEqual(media?.mediaThumbnails?.first?.attributes?.time, "12:05:01.123")
        XCTAssertNotNil(media?.mediaThumbnails?.last)
        XCTAssertNotNil(media?.mediaThumbnails?.last?.attributes)
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.url, "http://www.foo.com/keyframe2.jpg")
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.width, "640")
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.height, "480")
        XCTAssertEqual(media?.mediaThumbnails?.last?.attributes?.time, "12:05:01.123")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaContents?.first?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.url, "http://www.foo.com/song64kbps.mp3")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.fileSize, 1000)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.bitrate,64)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.type, "audio/mpeg")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.isDefault, true)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.attributes?.expression, "full")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaContents?.last?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.url, "http://www.foo.com/song.wav")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.fileSize, 16000)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.bitrate, nil)
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.type, "audio/x-wav")
        XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.attributes?.expression, "full")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits)
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.first)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.value, "entity name")
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.first?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.attributes?.role, "producer")
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.attributes?.scheme, "urn:ebu")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.last)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.value, "copyright holder of the entity")
        XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.last?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.attributes?.role, "owner")
        XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.attributes?.scheme, "urn:yvs")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaCategory)
        XCTAssertEqual(media?.mediaGroup?.mediaCategory?.value, "music/artist name/album/song")
        XCTAssertNotNil(media?.mediaGroup?.mediaCategory?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaCategory?.attributes?.label, "Ace Ventura - Pet Detective")
        XCTAssertEqual(media?.mediaGroup?.mediaCategory?.attributes?.scheme, "http://dmoz.org")
        
        XCTAssertNotNil(media?.mediaGroup?.mediaRating)
        XCTAssertEqual(media?.mediaGroup?.mediaRating?.value, "nonadult")
        XCTAssertNotNil(media?.mediaGroup?.mediaRating?.attributes)
        XCTAssertEqual(media?.mediaGroup?.mediaRating?.attributes?.scheme, "urn:mpaa")
        
        XCTAssertNotNil(media?.mediaContents)
        XCTAssertNotNil(media?.mediaContents?.first?.attributes)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.url, "http://www.foo.com/video.mov")
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.fileSize, 12216320)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.type, "video/quicktime")
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.expression, "full")
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.bitrate, 128)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.framerate, 25.0)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.samplingrate, 44.1)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.channels, 2)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.duration, 185)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.width, 200)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.height, 300)
        XCTAssertEqual(media?.mediaContents?.first?.attributes?.lang, "en")
        
        XCTAssertNotNil(media?.mediaContents)
        XCTAssertNotNil(media?.mediaContents?.last?.attributes)
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.url, "http://www.foo.com/movie.mov")
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.fileSize, 12216320)
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.type, "video/quicktime")
        XCTAssertEqual(media?.mediaContents?.last?.attributes?.expression, "full")
        
        XCTAssertNotNil(media?.mediaCommunity)
        XCTAssertNotNil(media?.mediaCommunity?.mediaStarRating)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.average, 3.5)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.count, 20)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.min, 1)
        XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.attributes?.max, 10)
        
        XCTAssertNotNil(media?.mediaCommunity?.mediaStatistics)
        XCTAssertNotNil(media?.mediaCommunity?.mediaStatistics?.attributes)
        XCTAssertEqual(media?.mediaCommunity?.mediaStatistics?.attributes?.favorites, 5)
        XCTAssertEqual(media?.mediaCommunity?.mediaStatistics?.attributes?.views, 5)
        
        XCTAssertNotNil(media?.mediaCommunity?.mediaTags)
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[0].tag, "news")
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[0].weight, 5)
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[1].tag, "abc")
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[1].weight, 3)
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[2].tag, "reuters")
        XCTAssertEqual(media?.mediaCommunity?.mediaTags?[2].weight, 1)
        
        XCTAssertNotNil(media?.mediaComments)
        XCTAssertEqual(media?.mediaComments?.first, "comment1")
        XCTAssertEqual(media?.mediaComments?.last, "comment2")
        
        XCTAssertNotNil(media?.mediaEmbed)
        XCTAssertNotNil(media?.mediaEmbed?.attributes)
        XCTAssertEqual(media?.mediaEmbed?.attributes?.url, "http://www.foo.com/player.swf")
        XCTAssertEqual(media?.mediaEmbed?.attributes?.width, 512)
        XCTAssertEqual(media?.mediaEmbed?.attributes?.height, 323)
        
        XCTAssertNotNil(media?.mediaEmbed?.mediaParams)
        XCTAssertNotNil(media?.mediaEmbed?.mediaParams?.first?.attributes)
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.first?.attributes?.name, "type")
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.first?.value, "application/x-shockwave-flash")
        XCTAssertNotNil(media?.mediaEmbed?.mediaParams?.last?.attributes)
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.last?.attributes?.name, "flashVars")
        XCTAssertEqual(media?.mediaEmbed?.mediaParams?.last?.value, "id=12345&vid=678912i&lang=en-us&intl=us&thumbUrl=http://www.foo.com/thumbnail.jpg")
        
        XCTAssertNotNil(media?.mediaResponses)
        XCTAssertEqual(media?.mediaResponses?.first, "http://www.response1.com")
        XCTAssertEqual(media?.mediaResponses?.last, "http://www.response2.com")
        
        XCTAssertNotNil(media?.mediaBackLinks)
        XCTAssertEqual(media?.mediaBackLinks?.first, "http://www.backlink1.com")
        XCTAssertEqual(media?.mediaBackLinks?.last, "http://www.backlink2.com")
        
        XCTAssertNotNil(media?.mediaStatus)
        XCTAssertNotNil(media?.mediaStatus?.attributes)
        XCTAssertEqual(media?.mediaStatus?.attributes?.reason, "http://www.reasonforblocking.com")
        XCTAssertEqual(media?.mediaStatus?.attributes?.state, "blocked")
        
        XCTAssertNotNil(media?.mediaPrices)
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.type, "rent")
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.price, 19.99)
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.currency, "EUR")
        XCTAssertEqual(media?.mediaPrices?.first?.attributes?.info, "http://www.dummy.jp/package_info.html")
        
        XCTAssertNotNil(media?.mediaLicense)
        XCTAssertNotNil(media?.mediaLicense?.attributes)
        XCTAssertEqual(media?.mediaLicense?.attributes?.href, "http://www.licensehost.com/license")
        XCTAssertEqual(media?.mediaLicense?.attributes?.type, "text/html")
        XCTAssertEqual(media?.mediaLicense?.value, "Sample license for a video")
        
        XCTAssertNotNil(media?.mediaSubTitle)
        XCTAssertNotNil(media?.mediaSubTitle?.attributes)
        XCTAssertEqual(media?.mediaSubTitle?.attributes?.href, "http://www.foo.org/subtitle.smil")
        XCTAssertEqual(media?.mediaSubTitle?.attributes?.lang, "en-us")
        XCTAssertEqual(media?.mediaSubTitle?.attributes?.type, "application/smil")
        
        XCTAssertNotNil(media?.mediaPeerLink)
        XCTAssertNotNil(media?.mediaPeerLink?.attributes)
        XCTAssertEqual(media?.mediaPeerLink?.attributes?.href, "http://www.foo.org/sampleFile.torrent")
        XCTAssertEqual(media?.mediaPeerLink?.attributes?.type, "application/x-bittorrent")
        
        XCTAssertNotNil(media?.mediaLocation)
        XCTAssertNotNil(media?.mediaLocation?.attributes)
        XCTAssertEqual(media?.mediaLocation?.attributes?.start, TimeInterval(1))
        XCTAssertEqual(media?.mediaLocation?.attributes?.end, TimeInterval(60))
        XCTAssertEqual(media?.mediaLocation?.attributes?.description, "My house")
        XCTAssertEqual(media?.mediaLocation?.latitude, 35.669998)
        XCTAssertEqual(media?.mediaLocation?.longitude, 139.770004)
        
        XCTAssertNotNil(media?.mediaRestriction)
        XCTAssertNotNil(media?.mediaRestriction?.attributes)
        XCTAssertEqual(media?.mediaRestriction?.attributes?.relationship, "allow")
        XCTAssertEqual(media?.mediaRestriction?.attributes?.type, "country")
        XCTAssertEqual(media?.mediaRestriction?.value, "au us")
        
        XCTAssertNotNil(media?.mediaRestriction)
        XCTAssertEqual(media?.mediaRestriction?.attributes?.relationship, "allow")
        XCTAssertEqual(media?.mediaRestriction?.attributes?.type, "country")
        XCTAssertEqual(media?.mediaRestriction?.value, "au us")
        
        XCTAssertNotNil(media?.mediaScenes)
        XCTAssertEqual(media?.mediaScenes?.first?.sceneTitle, "sceneTitle1")
        XCTAssertEqual(media?.mediaScenes?.first?.sceneDescription, "sceneDesc1")
        XCTAssertEqual(media?.mediaScenes?.first?.sceneStartTime, TimeInterval(15))
        XCTAssertEqual(media?.mediaScenes?.first?.sceneEndTime, TimeInterval(45))
        
    }
    
    func testAtomMediaParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Atom Media Parsing Performance")
            let URL = self.fileURL("AtomMedia", type: "xml")
            let parser = FeedParser(URL: URL)!
            
            // When
            parser.parseAsync { (result) in
                
                // Then
                expectation.fulfill()
                
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
}
