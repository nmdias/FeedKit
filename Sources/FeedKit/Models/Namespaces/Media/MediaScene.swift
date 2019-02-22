//
//  MediaScene.swift
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

import Foundation

/// Optional element to specify various scenes within a media object. It can
/// have multiple child <media:scene> elements, where each <media:scene>
/// element contains information about a particular scene. <media:scene> has
/// the optional sub-elements <sceneTitle>, <sceneDescription>,
/// <sceneStartTime> and <sceneEndTime>, which contains title, description,
/// start and end time of a particular scene in the media, respectively.
public class MediaScene {
    
    /// The scene's title.
    public var sceneTitle: String?
    
    /// The scene's description.
    public var sceneDescription: String?
    
    /// The scene's start time.
    public var sceneStartTime: TimeInterval?
    
    /// The scene's end time.
    public var sceneEndTime: TimeInterval?
    
    public init() { }

}

// MARK: - Equatable

extension MediaScene: Equatable {
    
    public static func ==(lhs: MediaScene, rhs: MediaScene) -> Bool {
        return
            lhs.sceneTitle == rhs.sceneTitle &&
            lhs.sceneDescription == rhs.sceneDescription &&
            lhs.sceneStartTime == rhs.sceneStartTime &&
            lhs.sceneEndTime == rhs.sceneEndTime
    }
    
}
