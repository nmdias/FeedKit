//
//  MediaTests.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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
        let parser = FeedParser(URL: URL)
        
        do {
            // When
            let rssFeed = try parser.parse().get().rssFeed
            let firstMedia = rssFeed?.items?.first?.media
            let lastMedia = rssFeed?.items?.last?.media

            // Then
            XCTAssertNotNil(firstMedia)
            XCTAssertNotNil(firstMedia?.mediaThumbnails)
            XCTAssertNotNil(firstMedia?.mediaThumbnails?.first)
            XCTAssertNotNil(firstMedia?.mediaThumbnails?.first?.attributes)
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.attributes?.url, "http://www.foo.com/keyframe1.jpg")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.attributes?.width, "75")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.attributes?.height, "50")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.attributes?.time, "12:05:01.123")
            XCTAssertNotNil(firstMedia?.mediaThumbnails?.last)
            XCTAssertNotNil(firstMedia?.mediaThumbnails?.last?.attributes)
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.attributes?.url, "http://www.foo.com/keyframe2.jpg")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.attributes?.width, "640")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.attributes?.height, "480")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.attributes?.time, "12:05:01.123")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaContents?.first?.attributes)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.attributes?.url, "http://www.foo.com/song64kbps.mp3")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.attributes?.fileSize, 1000)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.attributes?.bitrate,64)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.attributes?.type, "audio/mpeg")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.attributes?.isDefault, true)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.attributes?.expression, "full")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaContents?.last?.attributes)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.attributes?.url, "http://www.foo.com/song.wav")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.attributes?.fileSize, 16000)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.attributes?.bitrate, nil)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.attributes?.type, "audio/x-wav")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.attributes?.expression, "full")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits)
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits?.first)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.first?.value, "entity name")
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits?.first?.attributes)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.first?.attributes?.role, "producer")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.first?.attributes?.scheme, "urn:ebu")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits?.last)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.last?.value, "copyright holder of the entity")
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits?.last?.attributes)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.last?.attributes?.role, "owner")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.last?.attributes?.scheme, "urn:yvs")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCategory)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCategory?.value, "music/artist name/album/song")
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCategory?.attributes)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCategory?.attributes?.label, "Ace Ventura - Pet Detective")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCategory?.attributes?.scheme, "http://dmoz.org")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaRating)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaRating?.value, "nonadult")
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaRating?.attributes)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaRating?.attributes?.scheme, "urn:mpaa")
            
            XCTAssertNotNil(firstMedia?.mediaContents)
            XCTAssertNotNil(firstMedia?.mediaContents?.first?.attributes)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.url, "http://www.foo.com/video.mov")
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.fileSize, 12216320)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.type, "video/quicktime")
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.expression, "full")
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.bitrate, 128)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.framerate, 25.0)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.samplingrate, 44.1)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.channels, 2)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.duration, 185)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.width, 200)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.height, 300)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.attributes?.lang, "en")
            
            XCTAssertNotNil(firstMedia?.mediaContents)
            XCTAssertNotNil(firstMedia?.mediaContents?.last?.attributes)
            XCTAssertEqual(firstMedia?.mediaContents?.last?.attributes?.url, "http://www.foo.com/movie.mov")
            XCTAssertEqual(firstMedia?.mediaContents?.last?.attributes?.fileSize, 12216320)
            XCTAssertEqual(firstMedia?.mediaContents?.last?.attributes?.type, "video/quicktime")
            XCTAssertEqual(firstMedia?.mediaContents?.last?.attributes?.expression, "full")
            
            XCTAssertNotNil(firstMedia?.mediaCommunity)
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaStarRating)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.attributes?.average, 3.5)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.attributes?.count, 20)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.attributes?.min, 1)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.attributes?.max, 10)
            
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaStatistics)
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaStatistics?.attributes)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStatistics?.attributes?.favorites, 5)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStatistics?.attributes?.views, 5)
            
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaTags)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[0].tag, "news")
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[0].weight, 5)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[1].tag, "abc")
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[1].weight, 3)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[2].tag, "reuters")
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[2].weight, 1)
            
            XCTAssertNotNil(firstMedia?.mediaComments)
            XCTAssertEqual(firstMedia?.mediaComments?.first, "comment1")
            XCTAssertEqual(firstMedia?.mediaComments?.last, "comment2")
            
            XCTAssertNotNil(firstMedia?.mediaEmbed)
            XCTAssertNotNil(firstMedia?.mediaEmbed?.attributes)
            XCTAssertEqual(firstMedia?.mediaEmbed?.attributes?.url, "http://www.foo.com/player.swf")
            XCTAssertEqual(firstMedia?.mediaEmbed?.attributes?.width, 512)
            XCTAssertEqual(firstMedia?.mediaEmbed?.attributes?.height, 323)
            
            XCTAssertNotNil(firstMedia?.mediaEmbed?.mediaParams)
            XCTAssertNotNil(firstMedia?.mediaEmbed?.mediaParams?.first?.attributes)
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.first?.attributes?.name, "type")
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.first?.value, "application/x-shockwave-flash")
            XCTAssertNotNil(firstMedia?.mediaEmbed?.mediaParams?.last?.attributes)
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.last?.attributes?.name, "flashVars")
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.last?.value, "id=12345&vid=678912i&lang=en-us&intl=us&thumbUrl=http://www.foo.com/thumbnail.jpg")
            
            XCTAssertNotNil(firstMedia?.mediaResponses)
            XCTAssertEqual(firstMedia?.mediaResponses?.first, "http://www.response1.com")
            XCTAssertEqual(firstMedia?.mediaResponses?.last, "http://www.response2.com")
            
            XCTAssertNotNil(firstMedia?.mediaBackLinks)
            XCTAssertEqual(firstMedia?.mediaBackLinks?.first, "http://www.backlink1.com")
            XCTAssertEqual(firstMedia?.mediaBackLinks?.last, "http://www.backlink2.com")
            
            XCTAssertNotNil(firstMedia?.mediaStatus)
            XCTAssertNotNil(firstMedia?.mediaStatus?.attributes)
            XCTAssertEqual(firstMedia?.mediaStatus?.attributes?.reason, "http://www.reasonforblocking.com")
            XCTAssertEqual(firstMedia?.mediaStatus?.attributes?.state, "blocked")
            
            XCTAssertNotNil(firstMedia?.mediaPrices)
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.attributes?.type, "rent")
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.attributes?.price, 19.99)
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.attributes?.currency, "EUR")
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.attributes?.info, "http://www.dummy.jp/package_info.html")
            
            XCTAssertNotNil(firstMedia?.mediaLicense)
            XCTAssertNotNil(firstMedia?.mediaLicense?.attributes)
            XCTAssertEqual(firstMedia?.mediaLicense?.attributes?.href, "http://www.licensehost.com/license")
            XCTAssertEqual(firstMedia?.mediaLicense?.attributes?.type, "text/html")
            XCTAssertEqual(firstMedia?.mediaLicense?.value, "Sample license for a video")
            
            XCTAssertNotNil(firstMedia?.mediaSubTitle)
            XCTAssertNotNil(firstMedia?.mediaSubTitle?.attributes)
            XCTAssertEqual(firstMedia?.mediaSubTitle?.attributes?.href, "http://www.foo.org/subtitle.smil")
            XCTAssertEqual(firstMedia?.mediaSubTitle?.attributes?.lang, "en-us")
            XCTAssertEqual(firstMedia?.mediaSubTitle?.attributes?.type, "application/smil")
            
            XCTAssertNotNil(firstMedia?.mediaPeerLink)
            XCTAssertNotNil(firstMedia?.mediaPeerLink?.attributes)
            XCTAssertEqual(firstMedia?.mediaPeerLink?.attributes?.href, "http://www.foo.org/sampleFile.torrent")
            XCTAssertEqual(firstMedia?.mediaPeerLink?.attributes?.type, "application/x-bittorrent")
            
            XCTAssertNotNil(firstMedia?.mediaLocation)
            XCTAssertNotNil(firstMedia?.mediaLocation?.attributes)
            XCTAssertEqual(firstMedia?.mediaLocation?.attributes?.start, TimeInterval(1))
            XCTAssertEqual(firstMedia?.mediaLocation?.attributes?.end, TimeInterval(60))
            XCTAssertEqual(firstMedia?.mediaLocation?.attributes?.description, "My house")
            XCTAssertEqual(firstMedia?.mediaLocation?.latitude, 35.669998)
            XCTAssertEqual(firstMedia?.mediaLocation?.longitude, 139.770004)
            
            XCTAssertNotNil(firstMedia?.mediaRestriction)
            XCTAssertNotNil(firstMedia?.mediaRestriction?.attributes)
            XCTAssertEqual(firstMedia?.mediaRestriction?.attributes?.relationship, "allow")
            XCTAssertEqual(firstMedia?.mediaRestriction?.attributes?.type, "country")
            XCTAssertEqual(firstMedia?.mediaRestriction?.value, "au us")
            
            XCTAssertNotNil(firstMedia?.mediaRestriction)
            XCTAssertEqual(firstMedia?.mediaRestriction?.attributes?.relationship, "allow")
            XCTAssertEqual(firstMedia?.mediaRestriction?.attributes?.type, "country")
            XCTAssertEqual(firstMedia?.mediaRestriction?.value, "au us")
            
            XCTAssertNotNil(firstMedia?.mediaScenes)
            XCTAssertEqual(firstMedia?.mediaScenes?.first?.sceneTitle, "sceneTitle1")
            XCTAssertEqual(firstMedia?.mediaScenes?.first?.sceneDescription, "sceneDesc1")
            XCTAssertEqual(firstMedia?.mediaScenes?.first?.sceneStartTime, TimeInterval(15))
            XCTAssertEqual(firstMedia?.mediaScenes?.first?.sceneEndTime, TimeInterval(45))
            
            XCTAssertNotNil(lastMedia?.mediaContents)
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaTitle)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaTitle?.attributes?.type, "plain")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaTitle?.value, "The Judy's -- The Moo Song")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaDescription)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.attributes?.type, "plain")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.value, "This was some really bizarre band I listened to as a young lad.")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaDescription)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.attributes?.type, "plain")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.value, "This was some really bizarre band I listened to as a young lad.")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaCategory)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaCategory?.attributes?.scheme, "http://blah.com/scheme")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaCategory?.attributes?.label, "blah")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaCategory?.value, "music/artistname/album/song")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaThumbnails?.first)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.attributes?.url, "http://www.foo.com/keyframe.jpg")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.attributes?.width, "75")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.attributes?.height, "50")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.attributes?.time, "12:05:01.123")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaPlayer)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaPlayer?.attributes?.url, "http://www.foo.com/player?id=1111")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaPlayer?.attributes?.height, 200)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaPlayer?.attributes?.width, 400)
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaKeywords)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaKeywords?.joined(separator: ", "), "kitty, cat, big dog, yarn, fluffy")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testRSSMediaParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "RSS Media Parsing Performance")
            let URL = self.fileURL("RSSMedia", type: "xml")
            let parser = FeedParser(URL: URL)
            
            // When
            Task {
                _ = await parser.parseAsync()
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
    func testAtomMedia() {
        
        // Given
        let URL = fileURL("AtomMedia", type: "xml")
        let parser = FeedParser(URL: URL)
        
        do {
            // When
            let media = try parser.parse().get().atomFeed?.entries?.first?.media

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
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        
        
    }
    
    func testAtomMediaParsingPerformance() {
        
        self.measure {
            
            // Given
            let expectation = self.expectation(description: "Atom Media Parsing Performance")
            let URL = self.fileURL("AtomMedia", type: "xml")
            let parser = FeedParser(URL: URL)
            
            // When
            Task {
                _ = await parser.parseAsync()
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
            
        }
        
    }
    
}
