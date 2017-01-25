//
//  iTunesCategory.swift
//  Pods
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

/// Categories and Subcategories for Itunes Podcasts
/// see: https://help.apple.com/itc/podcasts_connect/#/itc9267a2f12
open class ITunesCategory {

    /// The iTunes Podcasting Tags Category
    let category: Category
    /// The iTunes Podcasting Tags Subcategory
    let subcategory: Subcategory?

    /// Initialize and validate that subcategories and categories match
    init?(with categoryString: String?, subcategoryString: String?) {
        guard
            categoryString != nil,
            let cat = Category(rawValue: categoryString!)
            else { return nil }
        category = cat

        guard
            subcategoryString != nil,
            let subcat = Subcategory(rawValue: subcategoryString!),
            ITunesCategory.validate(category: cat, subcategory: subcat)
            else { self.subcategory = nil; return}
        self.subcategory = subcat

    }

    /// Initialize with a valid Category and maybe a subcategory
    ///
    /// - Parameters:
    ///   - category: any category
    ///   - subcategory: an optional subcategory
    init(with category: Category, subcategory: Subcategory? = nil) {
        self.category = category
        self.subcategory = subcategory
    }

    /// Ensure that a category and subcategory are valid matches
    ///
    /// - Parameters:
    ///   - category: the top level category
    ///   - subcategory: a subcategory
    /// - Returns: true if the combination is valid
    static func validate(category: Category, subcategory: Subcategory) -> Bool {
        guard let validSubcategories = validCombinations[category] else { return false }
        return validSubcategories.contains(subcategory)
    }



    /// Match categories with valid subcategories - does not include categories with no subcategories
    static let validCombinations: [Category: Set<Subcategory>] =
        [.arts:                     [.design, .fashionBeauty, .food, .literature, .performingArts, .visualArts],
         .business:                 [.businessNews, .careers, .investing, .managementMarketing, .shopping],
         .education:                [.educationalTechnology, .higherEducation, .k12, .languageCourses, .training],
         .gamesHobbies:             [.automotive, .aviation, .hobbies, .otherGames, .videoGames],
         .governmentOrganizations:  [.local, .national, .nonProfit, .regional],
         .health:                   [.alternativeHealth, .fitnessNutrition, .selfHelp, .sexuality],
         .religionSpirituality:     [.buddhism, .christianity, .hinduism, .islam, .judaism, .other, .spirituality],
         .scienceMedicine:          [.medicine, .naturalSciences, .socialSciences],
         .societyCulture:           [.history, .personalJournals, .philosophy, .placesTravel],
         .sportsRecreation:         [.amateur, .collegeHighSchool, .outdoor, .professional],
         .technology:               [.gadgets, .techNews, .podcasting, .softwareHowTo]
    ]

    /// All Categories
    public enum Category: String {
        case arts
        case business
        case comedy
        case education
        case gamesHobbies = "Games & Hobbies"
        case governmentOrganizations = "Government & Organizations"
        case health
        case kidsFamily = "Kids & Family"
        case music
        case newsPolitics = "News & Politics"
        case religionSpirituality = "Religion & Spirituality"
        case scienceMedicine = "Science & Medicine"
        case societyCulture = "Society & Culture"
        case sportsRecreation = "Sports & Recreation"
        case technology
        case tvFilm = "TV & Film"
    }

    /// All Subcategories
    public enum Subcategory: String {
        // Arts
        case design
        case fashionBeauty = "Fashion & Beauty"
        case food
        case literature
        case performingArts
        case visualArts
        // Business
        case businessNews
        case careers
        case investing
        case managementMarketing = "Management & Marketing"
        case shopping
        // Education
        case educationalTechnology
        case higherEducation
        case k12 = "K-12"
        case languageCourses
        case training
        // Games & Hobbies
        case automotive
        case aviation
        case hobbies
        case otherGames
        case videoGames
        // Government & Organizations
        case local
        case national
        case nonProfit = "Non-Profit"
        case regional
        // Health
        case alternativeHealth
        case fitnessNutrition = "Fitness & Nutrition"
        case selfHelp = "Self-Help"
        case sexuality
        // Religion & Spirituality
        case buddhism
        case christianity
        case hinduism
        case islam
        case judaism
        case other
        case spirituality
        // Science & Medicine
        case medicine
        case naturalSciences
        case socialSciences
        // Society & Culture
        case history
        case personalJournals
        case philosophy
        case placesTravel = "Places & Travel"
        // Sports & Recreation
        case amateur
        case collegeHighSchool = "College & High School"
        case outdoor
        case professional
        // Technology
        case gadgets
        case techNews
        case podcasting
        case softwareHowTo = "Software How-To"
    }



}





