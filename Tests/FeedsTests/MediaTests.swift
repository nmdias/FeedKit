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
import Feeds

class MediaTests: BaseTestCase {
    func testRSSMedia() async {
        
        // Given
        let URL = fileURL("RSSMedia", withExtension: "xml")

        do {
            // When
            let rssFeed = try await RSSFeed(URL: URL)
            let firstMedia = rssFeed.channel?.items?.first?.media
            let lastMedia = rssFeed.channel?.items?.last?.media
            
            // Then
            XCTAssertNotNil(firstMedia)
            XCTAssertNotNil(firstMedia?.mediaThumbnails)
            XCTAssertNotNil(firstMedia?.mediaThumbnails?.first)
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.url, "http://www.foo.com/keyframe1.jpg")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.width, "75")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.height, "50")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.first?.time, "12:05:01.123")
            XCTAssertNotNil(firstMedia?.mediaThumbnails?.last)
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.url, "http://www.foo.com/keyframe2.jpg")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.width, "640")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.height, "480")
            XCTAssertEqual(firstMedia?.mediaThumbnails?.last?.time, "12:05:01.123")
            
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.url, "http://www.foo.com/song64kbps.mp3")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.fileSize, 1000)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.bitrate,64)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.type, "audio/mpeg")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.isDefault, true)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.first?.expression, "full")
            
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.url, "http://www.foo.com/song.wav")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.fileSize, 16000)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.bitrate, nil)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.type, "audio/x-wav")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaContents?.last?.expression, "full")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits)
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits?.first)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.first?.credit, "entity name")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.first?.role, "producer")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.first?.scheme, "urn:ebu")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCredits?.last)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.last?.credit, "copyright holder of the entity")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.last?.role, "owner")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCredits?.last?.scheme, "urn:yvs")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaCategory)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCategory?.category, "music/artist name/album/song")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCategory?.label, "Ace Ventura - Pet Detective")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaCategory?.scheme, "http://dmoz.org")
            
            XCTAssertNotNil(firstMedia?.mediaGroup?.mediaRating)
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaRating?.rating, "nonadult")
            XCTAssertEqual(firstMedia?.mediaGroup?.mediaRating?.scheme, "urn:mpaa")
            
            XCTAssertNotNil(firstMedia?.mediaContents)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.url, "http://www.foo.com/video.mov")
            XCTAssertEqual(firstMedia?.mediaContents?.first?.fileSize, 12216320)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.type, "video/quicktime")
            XCTAssertEqual(firstMedia?.mediaContents?.first?.expression, "full")
            XCTAssertEqual(firstMedia?.mediaContents?.first?.bitrate, 128)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.framerate, 25.0)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.samplingrate, 44.1)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.channels, 2)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.duration, 185)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.width, 200)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.height, 300)
            XCTAssertEqual(firstMedia?.mediaContents?.first?.lang, "en")
            
            XCTAssertNotNil(firstMedia?.mediaContents)
            XCTAssertEqual(firstMedia?.mediaContents?.last?.url, "http://www.foo.com/movie.mov")
            XCTAssertEqual(firstMedia?.mediaContents?.last?.fileSize, 12216320)
            XCTAssertEqual(firstMedia?.mediaContents?.last?.type, "video/quicktime")
            XCTAssertEqual(firstMedia?.mediaContents?.last?.expression, "full")
            
            XCTAssertNotNil(firstMedia?.mediaCommunity)
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaStarRating)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.average, 3.5)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.count, 20)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.min, 1)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStarRating?.max, 10)
            
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaStatistics)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStatistics?.favorites, 5)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaStatistics?.views, 5)
            
            XCTAssertNotNil(firstMedia?.mediaCommunity?.mediaTags)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[0].tag, "news")
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[0].weight, 5)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[1].tag, "abc")
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[1].weight, 3)
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[2].tag, "reuters")
            XCTAssertEqual(firstMedia?.mediaCommunity?.mediaTags?[2].weight, 1)
            
            XCTAssertNotNil(firstMedia?.mediaComments)
            XCTAssertEqual(firstMedia?.mediaComments?.comments?.first?.comment, "comment1")
            XCTAssertEqual(firstMedia?.mediaComments?.comments?.last?.comment, "comment2")
            
            XCTAssertNotNil(firstMedia?.mediaEmbed)
            XCTAssertEqual(firstMedia?.mediaEmbed?.url, "http://www.foo.com/player.swf")
            XCTAssertEqual(firstMedia?.mediaEmbed?.width, 512)
            XCTAssertEqual(firstMedia?.mediaEmbed?.height, 323)
            
            XCTAssertNotNil(firstMedia?.mediaEmbed?.mediaParams)
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.first?.name, "type")
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.first?.param, "application/x-shockwave-flash")
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.last?.name, "flashVars")
            XCTAssertEqual(firstMedia?.mediaEmbed?.mediaParams?.last?.param, "id=12345&vid=678912i&lang=en-us&intl=us&thumbUrl=http://www.foo.com/thumbnail.jpg")
            
            XCTAssertNotNil(firstMedia?.mediaResponses)
            XCTAssertEqual(firstMedia?.mediaResponses?.responses?.first, "http://www.response1.com")
            XCTAssertEqual(firstMedia?.mediaResponses?.responses?.last, "http://www.response2.com")
            
            XCTAssertNotNil(firstMedia?.mediaBackLinks)
            XCTAssertEqual(firstMedia?.mediaBackLinks?.backLinks?.first, "http://www.backlink1.com")
            XCTAssertEqual(firstMedia?.mediaBackLinks?.backLinks?.last, "http://www.backlink2.com")
            
            XCTAssertNotNil(firstMedia?.mediaStatus)
            XCTAssertEqual(firstMedia?.mediaStatus?.reason, "http://www.reasonforblocking.com")
            XCTAssertEqual(firstMedia?.mediaStatus?.state, "blocked")
            
            XCTAssertNotNil(firstMedia?.mediaPrices)
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.type, "rent")
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.price, 19.99)
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.currency, "EUR")
            XCTAssertEqual(firstMedia?.mediaPrices?.first?.info, "http://www.dummy.jp/package_info.html")
            
            XCTAssertNotNil(firstMedia?.mediaLicense)
            XCTAssertEqual(firstMedia?.mediaLicense?.href, "http://www.licensehost.com/license")
            XCTAssertEqual(firstMedia?.mediaLicense?.type, "text/html")
            XCTAssertEqual(firstMedia?.mediaLicense?.license, "Sample license for a video")
            
            XCTAssertNotNil(firstMedia?.mediaSubTitle)
            XCTAssertEqual(firstMedia?.mediaSubTitle?.href, "http://www.foo.org/subtitle.smil")
            XCTAssertEqual(firstMedia?.mediaSubTitle?.lang, "en-us")
            XCTAssertEqual(firstMedia?.mediaSubTitle?.type, "application/smil")
            
            XCTAssertNotNil(firstMedia?.mediaPeerLink)
            XCTAssertEqual(firstMedia?.mediaPeerLink?.href, "http://www.foo.org/sampleFile.torrent")
            XCTAssertEqual(firstMedia?.mediaPeerLink?.type, "application/x-bittorrent")
            
            XCTAssertNotNil(firstMedia?.mediaLocation)
            XCTAssertEqual(firstMedia?.mediaLocation?.start, TimeInterval(1))
            XCTAssertEqual(firstMedia?.mediaLocation?.end, TimeInterval(60))
            XCTAssertEqual(firstMedia?.mediaLocation?.description, "My house")
            XCTAssertEqual(firstMedia?.mediaLocation?.georss?.geoRSSWhere?.gml?.points?.first?.position, "35.669998 139.770004")
            
            XCTAssertNotNil(firstMedia?.mediaRestriction)
            XCTAssertEqual(firstMedia?.mediaRestriction?.relationship, "allow")
            XCTAssertEqual(firstMedia?.mediaRestriction?.type, "country")
            XCTAssertEqual(firstMedia?.mediaRestriction?.restriction, "au us")
            
            XCTAssertNotNil(firstMedia?.mediaRestriction)
            XCTAssertEqual(firstMedia?.mediaRestriction?.relationship, "allow")
            XCTAssertEqual(firstMedia?.mediaRestriction?.type, "country")
            XCTAssertEqual(firstMedia?.mediaRestriction?.restriction, "au us")
            
            /*XCTAssertNotNil(firstMedia?.mediaScenes)
            XCTAssertEqual(firstMedia?.mediaScenes?.scenes?.first?.sceneTitle, "sceneTitle1")
            XCTAssertEqual(firstMedia?.mediaScenes?.scenes?.first?.sceneDescription, "sceneDesc1")
            XCTAssertEqual(firstMedia?.mediaScenes?.scenes?.first?.sceneStartTime, TimeInterval(15))
            XCTAssertEqual(firstMedia?.mediaScenes?.scenes?.first?.sceneEndTime, TimeInterval(45))*/
            
            XCTAssertNotNil(lastMedia?.mediaContents)
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaTitle)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaTitle?.type, "plain")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaTitle?.title, "The Judy's -- The Moo Song")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaDescription)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.type, "plain")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.description, "This was some really bizarre band I listened to as a young lad.")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaDescription)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.type, "plain")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaDescription?.description, "This was some really bizarre band I listened to as a young lad.")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaCategory)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaCategory?.scheme, "http://blah.com/scheme")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaCategory?.label, "blah")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaCategory?.category, "music/artistname/album/song")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaThumbnails?.first)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.url, "http://www.foo.com/keyframe.jpg")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.width, "75")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.height, "50")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaThumbnails?.first?.time, "12:05:01.123")
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaPlayer)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaPlayer?.url, "http://www.foo.com/player?id=1111")
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaPlayer?.height, 200)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaPlayer?.width, 400)
            
            XCTAssertNotNil(lastMedia?.mediaContents?.last?.mediaKeywords)
            XCTAssertEqual(lastMedia?.mediaContents?.last?.mediaKeywords?.joined(separator: ", "), "kitty, cat, big dog, yarn, fluffy")
        } catch DecodingError.dataCorrupted(let context) {
            XCTFail(context.debugDescription)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testRSSMediaParsingPerformance() {
        
        self.measure {
            // Given
            let expectation = self.expectation(description: "RSS Media Parsing Performance")
            let URL = self.fileURL("RSSMedia", withExtension: "xml")

            // When
            Task {
                _ = try await RSSFeed(URL: URL)
                
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
        }
    }
    
    func testAtomMedia() async {
        // Given
        let URL = fileURL("AtomMedia", withExtension: "xml")
        
        do {
            // When
            let media = try await AtomFeed(URL: URL).entries?.first?.media
            
            // Then
            XCTAssertNotNil(media)
            XCTAssertNotNil(media?.mediaThumbnails)
            XCTAssertNotNil(media?.mediaThumbnails?.first)
            XCTAssertEqual(media?.mediaThumbnails?.first?.url, "http://www.foo.com/keyframe1.jpg")
            XCTAssertEqual(media?.mediaThumbnails?.first?.width, "75")
            XCTAssertEqual(media?.mediaThumbnails?.first?.height, "50")
            XCTAssertEqual(media?.mediaThumbnails?.first?.time, "12:05:01.123")
            XCTAssertNotNil(media?.mediaThumbnails?.last)
            XCTAssertEqual(media?.mediaThumbnails?.last?.url, "http://www.foo.com/keyframe2.jpg")
            XCTAssertEqual(media?.mediaThumbnails?.last?.width, "640")
            XCTAssertEqual(media?.mediaThumbnails?.last?.height, "480")
            XCTAssertEqual(media?.mediaThumbnails?.last?.time, "12:05:01.123")

            XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.url, "http://www.foo.com/song64kbps.mp3")
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.fileSize, 1000)
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.bitrate,64)
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.type, "audio/mpeg")
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.isDefault, true)
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.first?.expression, "full")
            
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.url, "http://www.foo.com/song.wav")
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.fileSize, 16000)
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.bitrate, nil)
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.type, "audio/x-wav")
            XCTAssertEqual(media?.mediaGroup?.mediaContents?.last?.expression, "full")
            
            XCTAssertNotNil(media?.mediaGroup?.mediaCredits)
            XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.first)
            XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.credit, "entity name")
            XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.role, "producer")
            XCTAssertEqual(media?.mediaGroup?.mediaCredits?.first?.scheme, "urn:ebu")
            
            XCTAssertNotNil(media?.mediaGroup?.mediaCredits?.last)
            XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.credit, "copyright holder of the entity")
            XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.role, "owner")
            XCTAssertEqual(media?.mediaGroup?.mediaCredits?.last?.scheme, "urn:yvs")
            
            XCTAssertNotNil(media?.mediaGroup?.mediaCategory)
            XCTAssertEqual(media?.mediaGroup?.mediaCategory?.category, "music/artist name/album/song")
            XCTAssertEqual(media?.mediaGroup?.mediaCategory?.label, "Ace Ventura - Pet Detective")
            XCTAssertEqual(media?.mediaGroup?.mediaCategory?.scheme, "http://dmoz.org")
            
            XCTAssertNotNil(media?.mediaGroup?.mediaRating)
            XCTAssertEqual(media?.mediaGroup?.mediaRating?.rating, "nonadult")
            XCTAssertEqual(media?.mediaGroup?.mediaRating?.scheme, "urn:mpaa")
            
            XCTAssertNotNil(media?.mediaContents)
            XCTAssertEqual(media?.mediaContents?.first?.url, "http://www.foo.com/video.mov")
            XCTAssertEqual(media?.mediaContents?.first?.fileSize, 12216320)
            XCTAssertEqual(media?.mediaContents?.first?.type, "video/quicktime")
            XCTAssertEqual(media?.mediaContents?.first?.expression, "full")
            XCTAssertEqual(media?.mediaContents?.first?.bitrate, 128)
            XCTAssertEqual(media?.mediaContents?.first?.framerate, 25.0)
            XCTAssertEqual(media?.mediaContents?.first?.samplingrate, 44.1)
            XCTAssertEqual(media?.mediaContents?.first?.channels, 2)
            XCTAssertEqual(media?.mediaContents?.first?.duration, 185)
            XCTAssertEqual(media?.mediaContents?.first?.width, 200)
            XCTAssertEqual(media?.mediaContents?.first?.height, 300)
            XCTAssertEqual(media?.mediaContents?.first?.lang, "en")
            
            XCTAssertNotNil(media?.mediaContents)
            XCTAssertEqual(media?.mediaContents?.last?.url, "http://www.foo.com/movie.mov")
            XCTAssertEqual(media?.mediaContents?.last?.fileSize, 12216320)
            XCTAssertEqual(media?.mediaContents?.last?.type, "video/quicktime")
            XCTAssertEqual(media?.mediaContents?.last?.expression, "full")
            
            XCTAssertNotNil(media?.mediaCommunity)
            XCTAssertNotNil(media?.mediaCommunity?.mediaStarRating)
            XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.average, 3.5)
            XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.count, 20)
            XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.min, 1)
            XCTAssertEqual(media?.mediaCommunity?.mediaStarRating?.max, 10)
            
            XCTAssertNotNil(media?.mediaCommunity?.mediaStatistics)
            XCTAssertEqual(media?.mediaCommunity?.mediaStatistics?.favorites, 5)
            XCTAssertEqual(media?.mediaCommunity?.mediaStatistics?.views, 5)
            
            XCTAssertNotNil(media?.mediaCommunity?.mediaTags)
            XCTAssertEqual(media?.mediaCommunity?.mediaTags?[0].tag, "news")
            XCTAssertEqual(media?.mediaCommunity?.mediaTags?[0].weight, 5)
            XCTAssertEqual(media?.mediaCommunity?.mediaTags?[1].tag, "abc")
            XCTAssertEqual(media?.mediaCommunity?.mediaTags?[1].weight, 3)
            XCTAssertEqual(media?.mediaCommunity?.mediaTags?[2].tag, "reuters")
            XCTAssertEqual(media?.mediaCommunity?.mediaTags?[2].weight, 1)
            
            XCTAssertNotNil(media?.mediaComments)
            XCTAssertEqual(media?.mediaComments?.comments?.first?.comment, "comment1")
            XCTAssertEqual(media?.mediaComments?.comments?.last?.comment, "comment2")
            
            XCTAssertNotNil(media?.mediaEmbed)
            XCTAssertEqual(media?.mediaEmbed?.url, "http://www.foo.com/player.swf")
            XCTAssertEqual(media?.mediaEmbed?.width, 512)
            XCTAssertEqual(media?.mediaEmbed?.height, 323)
            
            XCTAssertNotNil(media?.mediaEmbed?.mediaParams)
            XCTAssertEqual(media?.mediaEmbed?.mediaParams?.first?.name, "type")
            XCTAssertEqual(media?.mediaEmbed?.mediaParams?.first?.param, "application/x-shockwave-flash")
            XCTAssertEqual(media?.mediaEmbed?.mediaParams?.last?.name, "flashVars")
            XCTAssertEqual(media?.mediaEmbed?.mediaParams?.last?.param, "id=12345&vid=678912i&lang=en-us&intl=us&thumbUrl=http://www.foo.com/thumbnail.jpg")
            
            XCTAssertNotNil(media?.mediaResponses)
            XCTAssertEqual(media?.mediaResponses?.responses?.first, "http://www.response1.com")
            XCTAssertEqual(media?.mediaResponses?.responses?.last, "http://www.response2.com")
            
            XCTAssertNotNil(media?.mediaBackLinks)
            XCTAssertEqual(media?.mediaBackLinks?.backLinks?.first, "http://www.backlink1.com")
            XCTAssertEqual(media?.mediaBackLinks?.backLinks?.last, "http://www.backlink2.com")
            
            XCTAssertNotNil(media?.mediaStatus)
            XCTAssertEqual(media?.mediaStatus?.reason, "http://www.reasonforblocking.com")
            XCTAssertEqual(media?.mediaStatus?.state, "blocked")
            
            XCTAssertNotNil(media?.mediaPrices)
            XCTAssertEqual(media?.mediaPrices?.first?.type, "rent")
            XCTAssertEqual(media?.mediaPrices?.first?.price, 19.99)
            XCTAssertEqual(media?.mediaPrices?.first?.currency, "EUR")
            XCTAssertEqual(media?.mediaPrices?.first?.info, "http://www.dummy.jp/package_info.html")
            
            XCTAssertNotNil(media?.mediaLicense)
            XCTAssertEqual(media?.mediaLicense?.href, "http://www.licensehost.com/license")
            XCTAssertEqual(media?.mediaLicense?.type, "text/html")
            XCTAssertEqual(media?.mediaLicense?.license, "Sample license for a video")
            
            XCTAssertNotNil(media?.mediaSubTitle)
            XCTAssertEqual(media?.mediaSubTitle?.href, "http://www.foo.org/subtitle.smil")
            XCTAssertEqual(media?.mediaSubTitle?.lang, "en-us")
            XCTAssertEqual(media?.mediaSubTitle?.type, "application/smil")
            
            XCTAssertNotNil(media?.mediaPeerLink)
            XCTAssertEqual(media?.mediaPeerLink?.href, "http://www.foo.org/sampleFile.torrent")
            XCTAssertEqual(media?.mediaPeerLink?.type, "application/x-bittorrent")
            
            XCTAssertNotNil(media?.mediaLocation)
            XCTAssertEqual(media?.mediaLocation?.start, TimeInterval(1))
            XCTAssertEqual(media?.mediaLocation?.end, TimeInterval(60))
            XCTAssertEqual(media?.mediaLocation?.description, "My house")
            XCTAssertEqual(media?.mediaLocation?.georss?.geoRSSWhere?.gml?.points?.first?.position, "35.669998 139.770004")
            
            XCTAssertNotNil(media?.mediaRestriction)
            XCTAssertEqual(media?.mediaRestriction?.relationship, "allow")
            XCTAssertEqual(media?.mediaRestriction?.type, "country")
            XCTAssertEqual(media?.mediaRestriction?.restriction, "au us")
            
            XCTAssertNotNil(media?.mediaRestriction)
            XCTAssertEqual(media?.mediaRestriction?.relationship, "allow")
            XCTAssertEqual(media?.mediaRestriction?.type, "country")
            XCTAssertEqual(media?.mediaRestriction?.restriction, "au us")
            
            /*XCTAssertNotNil(media?.mediaScenes)
            XCTAssertEqual(media?.mediaScenes?.scenes?.first?.sceneTitle, "sceneTitle1")
            XCTAssertEqual(media?.mediaScenes?.scenes?.first?.sceneDescription, "sceneDesc1")
            XCTAssertEqual(media?.mediaScenes?.scenes?.first?.sceneStartTime, TimeInterval(15))
            XCTAssertEqual(media?.mediaScenes?.scenes?.first?.sceneEndTime, TimeInterval(45))*/
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAtomMediaParsingPerformance() {
        
        self.measure {
            // Given
            let expectation = self.expectation(description: "Atom Media Parsing Performance")
            let URL = self.fileURL("AtomMedia", withExtension: "xml")
            
            // When
            Task {
                _ = try await AtomFeed(URL: URL)
                
                // Then
                expectation.fulfill()
            }
            
            self.waitForExpectations(timeout: self.timeout, handler: nil)
        }
    }
}
