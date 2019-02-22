//
//  iTunesNamespace.swift
//
//  Copyright (c) 2017 Ben Murphy
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

import Foundation

/// iTunes Podcasting Tags are de facto standard for podcast syndication. For more 
/// information see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
public class ITunesNamespace {

    /// The content you specify in the <itunes:author> tag appears in the Artist 
    /// column on the iTunes Store. If the tag is not present, the iTunes Store 
    /// uses the contents of the <author> tag. If <itunes:author> is not present 
    /// at the RSS feed level, the iTunes Store uses the contents of the 
    /// <managingEditor> tag.
    public var iTunesAuthor: String?

    /// Specifying the <itunes:block> tag with a Yes value in:
    ///
    /// - A <channel> tag (podcast), prevents the entire podcast from appearing on 
    /// the iTunes Store podcast directory
    /// 
    /// - An <item> tag (episode), prevents that episode from appearing on the 
    /// iTunes Store podcast directory
    ///
    /// For example, you might want to block a specific episode if you know that 
    /// its content would otherwise cause the entire podcast to be removed from 
    /// the iTunes Store. Specifying any value other than Yes has no effect.
    public var iTunesBlock: String?

    /// Users can browse podcast subject categories in the iTunes Store by choosing
    /// a category from the Podcasts pop-up menu in the navigation bar. Use the 
    /// <itunes:category> tag to specify the browsing category for your podcast.
    ///
    /// You can also define a subcategory if one is available within your category.
    /// Although you can specify more than one category and subcategory in your 
    /// feed, the iTunes Store only recognizes the first category and subcategory. 
    /// For a complete list of categories and subcategories, see Podcasts Connect 
    /// categories.
    ///
    /// Note: When specifying categories and subcategories, be sure to properly 
    /// escape ampersands:
    ///
    /// Single category:
    /// <itunes:category text="Music" />
    /// 
    /// Category with ampersand:
    /// <itunes:category text="TV &amp; Film" />
    /// 
    /// Category with subcategory:
    /// <itunes:category text="Society &amp; Culture">
    /// <itunes:category text="History" />
    /// </itunes:category>
    /// 
    /// Multiple categories:
    /// <itunes:category text="Society &amp; Culture">
    /// <itunes:category text="History" />
    /// </itunes:category>
    /// <itunes:category text="Technology">
    /// <itunes:category text="Gadgets" />
    /// </itunes:category>
    public var iTunesCategories: [ITunesCategory]?

    /// Specify your podcast artwork using the <a href> attribute in the 
    /// <itunes:image> tag. If you do not specify the <itunes:image> tag, the 
    /// iTunes Store uses the content specified in the RSS feed image tag and Apple
    /// does not consider your podcast for feature placement on the iTunes Store or
    /// Podcasts.
    ///
    /// Depending on their device, subscribers see your podcast artwork in varying 
    /// sizes. Therefore, make sure your design is effective at both its original 
    /// size and at thumbnail size. Apple recommends including a title, brand, or 
    /// source name as part of your podcast artwork. For examples of podcast 
    /// artwork, see the Top Podcasts. To avoid technical issues when you update 
    /// your podcast artwork, be sure to:
    ///
    /// Change the artwork file name and URL at the same time
    /// Verify the web server hosting your artwork allows HTTP head requests
    /// The <itunes:image> tag is also supported at the <item> (episode) level. 
    /// For best results, Apple recommends embedding the same artwork within the 
    /// metadata for that episode's media file prior to uploading to your host
    /// server; using Garageband or another content-creation tool to edit your
    /// media file if needed.
    ///
    /// Note: Artwork must be a minimum size of 1400 x 1400 pixels and a maximum 
    /// size of 3000 x 3000 pixels, in JPEG or PNG format, 72 dpi, with appropriate 
    /// file extensions (.jpg, .png), and in the RGB colorspace. These requirements 
    /// are different from the standard RSS image tag specifications.
    public var iTunesImage: ITunesImage?

    /// The content you specify in the <itunes:duration> tag appears in the Time 
    /// column in the List View on the iTunes Store.
    ///
    /// Specify one of the following formats for the <itunes:duration> tag value:
    ///
    /// HH:MM:SS
    /// H:MM:SS
    /// MM:SS
    /// M:SS
    /// 
    /// Where H = hours, M = minutes, and S = seconds.
    ///
    /// If you specify a single number as a value (without colons), the iTunes 
    /// Store displays the value as seconds. If you specify one colon, the iTunes 
    /// Store displays the number to the left as minutes and the number to the 
    /// right as seconds. If you specify more then two colons, the iTunes Store 
    /// ignores the numbers farthest to the right.
    public var iTunesDuration: TimeInterval?

    /// The <itunes:explicit> tag indicates whether your podcast contains explicit 
    /// material. You can specify the following values:
    ///
    /// Yes | Explicit | True. If you specify yes, explicit, or true, indicating 
    /// the presence of explicit content, the iTunes Store displays an Explicit 
    /// parental advisory graphic for your podcast.
    /// Clean | No | False. If you specify clean, no, or false, indicating that 
    /// none of your podcast episodes contain explicit language or adult content, 
    /// the iTunes Store displays a Clean parental advisory graphic for your 
    /// podcast.
    /// 
    /// Note: Podcasts containing explicit material are not available in some 
    /// iTunes Store territories.
    public var iTunesExplicit: String?

    /// Specifying the <itunes:isClosedCaptioned> tag with a Yes value indicates 
    /// that the video podcast episode is embedded with closed captioning and the 
    /// iTunes Store should display a closed-caption icon next to the corresponding 
    /// episode. This tag is only supported at the <item> level (episode).
    ///
    /// Note: If you specify a value other than Yes, no closed-caption indicator 
    /// appears.
    public var isClosedCaptioned: String?

    /// Use the <itunes:order> tag to specify the number value in which you would 
    /// like the episode to appear and override the default ordering of episodes 
    /// on the iTunes Store.
    ///
    /// For example, if you want an <item> to appear as the first episode of your 
    /// podcast, specify the <itunes:order> tag with 1. If conflicting order 
    /// values are present in multiple episodes, the iTunes Store uses <pubDate>.
    public var iTunesOrder: Int?

    /// Specifying the <itunes:complete> tag with a Yes value indicates that a 
    /// podcast is complete and you will not post any more episodes in the future. 
    /// This tag is only supported at the <channel> level (podcast).
    ///
    /// Note: If you specify a value other than Yes, nothing happens.
    public var iTunesComplete: String?

    /// Use the <itunes:new-feed-url> tag to manually change the URL where your 
    /// podcast is located. This tag is only supported at a <channel>level 
    /// (podcast).
    ///
    /// <itunes:new-feed-url>http://newlocation.com/example.rss</itunes:new-feed-url>
    /// Note: You should maintain your old feed until you have migrated your e
    /// xisting subscribers. For more information, see Update your RSS feed URL.
    public var iTunesNewFeedURL: String?

    /// Use the <itunes:owner> tag to specify contact information for the podcast 
    /// owner. Include the email address of the owner in a nested <itunes:email> 
    /// tag and the name of the owner in a nested <itunes:name> tag.
    ///
    /// The <itunes:owner> tag information is for administrative communication 
    /// about the podcast and is not displayed on the iTunes Store.
    public var iTunesOwner: ITunesOwner?

    /// The content you specify in the <itunes:subtitle> tag appears in the 
    /// Description column on the iTunes Store. For best results, choose a subtitle 
    /// that is only a few words long.
    public var iTunesSubtitle: String?

    /// The content you specify in the <itunes:summary> tag appears on the iTunes 
    /// Store page for your podcast. You can specify up to 4000 characters. The 
    /// information also appears in a separate window if a users clicks the 
    /// Information icon (Information icon) in the Description column. If you do 
    /// not specify a <itunes:summary> tag, the iTunes Store uses the information 
    /// in the <description> tag.
    public var iTunesSummary: String?

    /// Note: The keywords tag is deprecated by Apple and no longer documented in 
    /// the official list of tags. However many podcasts still use the tags and it 
    /// may be of use for developers building directory or search functionality so 
    /// it is included.
    /// 
    /// <itunes:keywords>
    /// This tag allows users to search on text keywords.
    /// Limited to 255 characters or less, plain text, no HTML, words must be 
    /// separated by spaces.
    /// This tag is applicable to the Item element only.
    public var iTunesKeywords: String?

    /// Use the <itunes:type> tag to indicate how you intend for episodes to be
    /// presented. You can specify the following values:
    ///
    /// episodic | serial. If you specify episodic it means you intend for
    /// episodes to be presented newest-to-oldest. This is the default behavior
    /// in the iTunes Store if the tag is excluded. If you specify serial it
    /// means you intend for episodes to be presented oldest-to-newest.
    public var iTunesType: String?

    /// Use the <itunes:episodeType> tag to indicate what type of show item the
    /// entry is. You can specify the following values:
    ///
    /// full | trailer | bonus. If you specify full, it means this is the full
    /// content of a show. Trailer means this is a preview of the show. Bonus
    /// means it is extra content for a show.
    public var iTunesEpisodeType: String?

    /// Use the <itunes:season> tag to indicate which season the item is part of.
    ///
    /// Note: The iTunes Store & Apple Podcasts does not show the season number
    /// until a feed contains at least two seasons.
    public var iTunesSeason: Int?

    /// Use the <itunes:episode> tag in conjunction with the <itunes:season> tag
    /// to indicate the order an episode should be presented within a season.
    public var iTunesEpisode: Int?
    
    public init() { }

}

// MARK: - Equatable

extension ITunesNamespace: Equatable {
    
    public static func ==(lhs: ITunesNamespace, rhs: ITunesNamespace) -> Bool {
        return
            lhs.iTunesAuthor == rhs.iTunesAuthor &&
            lhs.iTunesBlock == rhs.iTunesBlock &&
            lhs.iTunesCategories == rhs.iTunesCategories &&
            lhs.iTunesImage == rhs.iTunesImage &&
            lhs.iTunesDuration == rhs.iTunesDuration &&
            lhs.iTunesExplicit == rhs.iTunesExplicit &&
            lhs.isClosedCaptioned == rhs.isClosedCaptioned &&
            lhs.iTunesOrder == rhs.iTunesOrder &&
            lhs.iTunesComplete == rhs.iTunesComplete &&
            lhs.iTunesNewFeedURL == rhs.iTunesNewFeedURL &&
            lhs.iTunesOwner == rhs.iTunesOwner &&
            lhs.iTunesSubtitle == rhs.iTunesSubtitle &&
            lhs.iTunesSummary == rhs.iTunesSummary &&
            lhs.iTunesKeywords == rhs.iTunesKeywords &&
            lhs.iTunesType == rhs.iTunesType &&
            lhs.iTunesEpisodeType == rhs.iTunesEpisodeType &&
            lhs.iTunesSeason == rhs.iTunesSeason &&
            lhs.iTunesEpisode == rhs.iTunesEpisode
    }
    
}
