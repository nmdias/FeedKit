//
//  URL + replacingScheme.swift
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

extension URL {
    /// Returns a new `URL` in which the target scheme is replaced by another given
    /// scheme. Returns `self` if the scheme already matches the target scheme.
    ///
    /// - Parameters:
    ///   - target: The target scheme
    ///   - replacement: The replacement scheme
    func replacing<Target, Replacement>(
        scheme target: Target,
        with replacement: Replacement)
        -> URL? where Target : StringProtocol, Replacement : StringProtocol
    {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)
        let isTargetScheme = urlComponents?.scheme?.caseInsensitiveCompare(target) == ComparisonResult.orderedSame
        if isTargetScheme {
            urlComponents?.scheme = "\(replacement)"
            return urlComponents?.url
        }
        return self
    }
}
