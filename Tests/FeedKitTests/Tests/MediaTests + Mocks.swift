//
// MediaTests + Mocks.swift
//
// Copyright (c) 2016 - 2026 Nuno Dias
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@testable import FeedKit

extension MediaTests {
  var mock: RSSFeed {
    var media: Media = .init()

    media.backLinks = .init(backLinks: [
      "http://www.backlink1.com",
      "http://www.backlink2.com"
    ])

    media.comments = .init(
      comments: [
        "comment1",
        "comment2"
      ]
    )

    media.group = .init(
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
          player: nil,
          thumbnails: nil,
          keywords: nil,
          category: nil,
          hash: nil
        ),
        .init(
          attributes: .init(
            url: "http://www.foo.com/song.wav",
            fileSize: 16000,
            type: "audio/x-wav",
            medium: nil,
            isDefault: nil,
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
        )
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
      ),
      description: .init(
        text: "What a wonderful description he found",
        attributes: nil
      ),
      thumbnails: [
        .init(
          text: nil,
          attributes: .init(
            url: "http://www.foo.com/keyframe3.jpg",
            width: "480",
            height: "360",
            time: "12:05:01.123"
          )
        )
      ]
    )

    media.contents = [
      .init(
        attributes: .init(
          url: "http://www.foo.com/video.mov",
          fileSize: 12_216_320,
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
      ),
      .init(
        attributes: .init(
          url: "http://www.foo.com/movie.mov",
          fileSize: 12_216_320,
          type: "video/quicktime",
          medium: nil,
          isDefault: nil,
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
        title: .init(
          text: "The Judy's -- The Moo Song",
          attributes: .init(
            type: "plain"
          )
        ),
        description: .init(
          text: "This was some really bizarre band I listened to as a young lad.",
          attributes: .init(
            type: "plain"
          )
        ),
        player: .init(
          text: nil,
          attributes: .init(
            url: "http://www.foo.com/player?id=1111",
            width: 400,
            height: 200
          )
        ),
        thumbnails: [
          .init(
            text: nil,
            attributes: .init(
              url: "http://www.foo.com/keyframe.jpg",
              width: "75",
              height: "50",
              time: "12:05:01.123"
            )
          )
        ],
        keywords: [
          "kitty", "cat", "big dog", "yarn", "fluffy"
        ],
        category: .init(
          text: "music/artistname/album/song",
          attributes: .init(
            scheme: "http://blah.com/scheme",
            label: "blah"
          )
        ),
        credits: [
          .init(
            text: "producer's name",
            attributes: .init(
              role: "producer",
              scheme: nil
            )
          ),
          .init(
            text: "artist's name",
            attributes: .init(
              role: "artist",
              scheme: nil
            )
          )
        ],
        rating: .init(
          text: "nonadult",
          attributes: nil
        ),
        hash: .init(
          text: "dfdec888b72151965a34b4b59031290a",
          attributes: .init(
            algo: "md5"
          )
        ),
        text: .init(
          text: "Oh, say, can you see, by the dawn's early light",
          attributes: .init(
            type: "plain",
            lang: nil,
            start: nil,
            end: nil
          )
        )
      )
    ]

    media.thumbnails = [
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
      )
    ]

    media.embed = .init(
      attributes: .init(
        url: "http://www.foo.com/player.swf",
        width: 512,
        height: 323
      ),
      params: [
        .init(
          text: "application/x-shockwave-flash",
          attributes: .init(
            name: "type"
          )
        ),
        .init(
          text: "512",
          attributes: .init(
            name: "width"
          )
        ),
        .init(
          text: "323",
          attributes: .init(
            name: "height"
          )
        ),
        .init(
          text: "true",
          attributes: .init(
            name: "allowFullScreen"
          )
        ),
        .init(
          text: "id=12345&vid=678912i&lang=en-us&intl=us&thumbUrl=http://www.foo.com/thumbnail.jpg",
          attributes: .init(
            name: "flashVars"
          )
        )
      ]
    )

    media.status = .init(
      text: nil,
      attributes: .init(
        state: "blocked",
        reason: "http://www.reasonforblocking.com"
      )
    )

    media.subTitle = .init(
      attributes: .init(
        type: "application/smil",
        lang: "en-us",
        href: "http://www.foo.org/subtitle.smil"
      )
    )

    media.group?.community = .init(
      starRating: .init(
        text: nil,
        attributes: .init(
          average: 3.5,
          count: 20,
          min: 1,
          max: 10
        )
      ),
      statistics: .init(
        text: nil,
        attributes: .init(
          views: 5,
          favorites: 5
        )
      ),
      tags: [
        .init(
          tag: "news",
          weight: 5
        ),
        .init(
          tag: "abc",
          weight: 3
        ),
        .init(
          tag: "reuters",
          weight: 1
        )
      ]
    )

    media.community = .init(
      starRating: .init(
        text: nil,
        attributes: .init(
          average: 3.5,
          count: 20,
          min: 1,
          max: 10
        )
      ),
      statistics: .init(
        text: nil,
        attributes: .init(
          views: 5,
          favorites: 5
        )
      ),
      tags: [
        .init(
          tag: "news",
          weight: 5
        ),
        .init(
          tag: "abc",
          weight: 3
        ),
        .init(
          tag: "reuters",
          weight: 1
        )
      ]
    )

    media.license = .init(
      text: "Sample license for a video",
      attributes: .init(
        type: "text/html",
        href: "http://www.licensehost.com/license"
      )
    )

    media.location = .init(
      attributes: .init(
        description: "My house",
        start: 1,
        end: 60
      ),
      geoRSS: .init(
        gmlPoint: .init(
          position: (latitude: 35.669998, longitude: 139.770004)
        )
      )
    )

    media.peerLink = .init(
      text: nil,
      attributes: .init(
        type: "application/x-bittorrent",
        href: "http://www.foo.org/sampleFile.torrent"
      )
    )

    media.prices = [
      .init(
        text: nil,
        attributes: .init(
          type: "rent",
          price: 19.99,
          info: "http://www.dummy.jp/package_info.html",
          currency: "EUR"
        )
      )
    ]

    media.responses = .init(
      responses: [
        "http://www.response1.com",
        "http://www.response2.com"
      ]
    )

    media.restriction = .init(
      text: "au us",
      attributes: .init(
        relationship: "allow",
        type: "country"
      )
    )

    media.scenes = .init(
      scenes: [
        .init(
          title: "sceneTitle1",
          description: "sceneDesc1",
          startTime: 15,
          endTime: 45
        )
      ]
    )

    return .init(
      channel: .init(
        items: [
          .init(
            media: media
          )
        ]
      )
    )
  }
}
