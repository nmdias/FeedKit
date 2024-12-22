//
//  MediaTests + Mocks.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
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

@testable import FeedKit

extension MediaTests {
  var mock: RSSFeed {
    .init(
      channel: .init(
        media: .init(
          group: .init(
            contents: [
              .init(
                attributes: .init(
                  url: "http://www.foo.com/song64kbps.mp3",
                  fileSize: 1000,
                  type: "audio/mpeg",
                  medium: nil,
                  isDefault: true,
                  expression: "full",
                  bitrate: 64,
                  framerate: nil,
                  samplingrate: nil,
                  channels: nil,
                  duration: nil,
                  height: nil,
                  width: nil,
                  lang: nil
                ),
                title: nil,
                description: nil,
                player: nil,
                thumbnails: nil,
                keywords: nil,
                category: nil
              ),
              .init(
                attributes: .init(
                  url: "ttp://www.foo.com/song.wav",
                  fileSize: 16000,
                  type: "audio/x-wav",
                  medium: nil,
                  isDefault: true,
                  expression: "full",
                  bitrate: nil,
                  framerate: nil,
                  samplingrate: nil,
                  channels: nil,
                  duration: nil,
                  height: nil,
                  width: nil,
                  lang: nil
                ),
                title: nil,
                description: nil,
                player: nil,
                thumbnails: nil,
                keywords: nil,
                category: nil
              ),
            ],
            credits: [
              .init(
                text: "entity name",
                attributes: .init(
                  role: "producer",
                  scheme: "urn:ebu"
                )
              ),
              .init(
                text: "copyright holder of the entity",
                attributes: .init(
                  role: "owner",
                  scheme: "urn:yvs"
                )
              )
            ],
            category: .init(
              text: "music/artist name/album/song",
              attributes: .init(
                scheme: "http://dmoz.org",
                label: "Ace Ventura - Pet Detective"
              )
            ),
            rating: .init(
              text: "nonadult",
              attributes: .init(
                scheme: "urn:mpaa"
              )
            )
          ),
          contents: [
            .init(
              attributes: .init(
                url: "http://www.foo.com/video.mov",
                fileSize: 12216320,
                type: "video/quicktime",
                medium: "video",
                isDefault: true,
                expression: "full",
                bitrate: 128,
                framerate: 25,
                samplingrate: 44.1,
                channels: 2,
                duration: 185,
                height: 300,
                width: 200,
                lang: "en"
              ),
              title: nil,
              description: nil,
              player: nil,
              thumbnails: nil,
              keywords: nil,
              category: nil
            )
          ],
          rating: nil,
          title: nil,
          description: nil,
          keywords: nil,
          thumbnails: [
            .init(
              text: nil,
              attributes: .init(
                url: "http://www.foo.com/keyframe1.jpg",
                width: "75",
                height: "50",
                time: "12:05:01.123"
              )
            ),
            .init(
              text: nil,
              attributes: .init(
                url: "http://www.foo.com/keyframe2.jpg",
                width: "640",
                height: "480",
                time: "12:05:01.123"
              )
            ),
          ],
          category: .init(
            text: nil,
            attributes: .init(
              scheme: nil,
              label: nil
            )
          ),
          hash: .init(
            text: nil,
            attributes: .init(
              algo: nil
            )
          ),
          player: .init(
            text: nil,
            attributes: .init(
              url: nil,
              width: nil, height: nil
            )
          ),
          credits: [
            .init(
              text: nil,
              attributes: .init(
                role: nil,
                scheme: nil
              )
            )
          ],
          copyright: .init(
            text: nil,
            attributes: .init(
              url: nil
            )
          ),
          text: .init(
            text: nil,
            attributes: .init(
              type: nil,
              lang: nil,
              start: nil,
              end: nil
            )
          ),
          restriction: .init(
            text: nil,
            attributes: .init(
              relationship: nil,
              type: nil
            )
          ),
          community: .init(
            starRating: .init(
              text: nil,
              attributes: .init(
                average: nil,
                count: nil,
                min: nil,
                max: nil
              )
            ),
            statistics: .init(
              text: nil,
              attributes: .init(
                views: nil,
                favorites: nil
              )
            ),
            tags: [
              .init(
                tag: nil,
                weight: nil
              )
            ]
          ),
          comments: [
            ""
          ],
          embed: .init(
            attributes: .init(
              url: nil,
              width: nil,
              height: nil
            ),
            params: [
              .init(
                text: nil,
                attributes: .init(
                  name: nil
                )
              )
            ]
          ),
          responses: [
            ""
          ],
          backLinks: [
            ""
          ],
          status: .init(
            text: nil,
            attributes: .init(
              state: nil,
              reason: nil
            )
          ),
          prices: [
            .init(
              text: nil,
              attributes: .init(
                type: nil,
                price: nil,
                info: nil,
                currency: nil
              )
            )
          ],
          license: .init(
            text: nil,
            attributes: .init(
              type: nil,
              href: nil
            
            )),
          subTitle: .init(
            text: nil,
            attributes: .init(
              type: nil,
              lang: nil,
              href: nil
            )
          ),
          peerLink: .init(
            text: nil,
            attributes: .init(
              type: nil, href: nil
            )
          ),
          location: .init(
            text: nil,
            attributes: .init(
              description: nil,
              start: nil,
              end: nil
            )
          ),
          rights: .init(
            text: nil,
            attributes: .init(
              status: nil
            )
          ),
          scenes: [
            .init(
              title: nil,
              description: nil,
              startTime: nil,
              endTime: nil
            )
          ]
        )
      )
    )
  }
}
