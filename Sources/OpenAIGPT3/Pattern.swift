//
//  Pattern.swift
//  ImageReader
//
//  Created by David Peterson on 15/2/20.
//  Copyright © 2020 Quote-Unquote Apps. All rights reserved.
//

import Foundation

/**
 A wrapper for simplified RegEx matching. It does not throw an exception when given a bad pattern, rather it triggers a `preconditionFailure` with the error message. This makes it useful for providing reusable constants which
 generally should not fail in the real world.
 */
struct Pattern: CustomStringConvertible {
    let regex: NSRegularExpression
    
    var description: String {
        regex.pattern
    }
    
    init(_ pattern: String, options: NSRegularExpression.Options = []) {
        do {
            try regex = NSRegularExpression(pattern: pattern, options: options)
        } catch {
            preconditionFailure("Invalid regular expression '\(pattern)': \(error)")
        }
    }
    
    func matches(in value: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(value.startIndex..<value.endIndex, in: value)
        return regex.numberOfMatches(in: value, options: options, range: range) > 0
    }
    
    func matches(in value: CustomStringConvertible, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        return matches(in: String(describing: value), options: options)
    }
    
    func matchGroups(in value: String, options: NSRegularExpression.MatchingOptions = []) -> Result? {
        let range = NSRange(value.startIndex..<value.endIndex, in: value)
        if let result = regex.firstMatch(in: value, options: options, range: range)
        {
            return Result(textCheckingResult: result, value: value)
        }
        return nil
    }
    
    func matchGroups(in value: CustomStringConvertible, options: NSRegularExpression.MatchingOptions = []) -> Result? {
        return matchGroups(in: String(describing: value), options: options)
    }
    
    func replace(in value: String, with replacement: String, options: NSRegularExpression.MatchingOptions = []) -> String {
        let range = NSRange(value.startIndex..<value.endIndex, in: value)
        return regex.stringByReplacingMatches(in: value, options: options, range: range, withTemplate: replacement)
    }
    
    struct Result {
        let textCheckingResult: NSTextCheckingResult
        let value: String
        
        subscript(i: Int) -> Substring? {
            guard i < textCheckingResult.numberOfRanges else {
                return nil
            }
            
            if let group = Range(textCheckingResult.range(at: i), in: value) {
                return value[group]
            }
            return nil
        }
        
        subscript(i: Int, j: Int) -> (Substring, Substring)? {
            if let iValue = self[i],
                let jValue = self[j]
            {
                return (iValue, jValue)
            } else {
                return nil
            }
        }
        
        subscript(i: Int, j: Int, k: Int) -> (Substring, Substring, Substring)? {
            if let iValue = self[i],
                let jValue = self[j],
                let kValue = self[k]
            {
                return (iValue, jValue, kValue)
            } else {
                return nil
            }
        }
        
        subscript(name: String) -> Substring? {
            let nsrange = textCheckingResult.range(withName: name)
            guard nsrange.location != NSNotFound else {
                return nil
            }
            
            if let range = Range(nsrange, in: value) {
                return value[range]
            } else {
                return nil
            }
        }

        subscript(name1: String, name2: String) -> (Substring, Substring)? {
            if let value1 = self[name1],
                let value2 = self[name2]
            {
                return (value1, value2)
            }
            return nil
        }

        subscript(name1: String, name2: String, name3: String) -> (Substring, Substring, Substring)? {
            if let value1 = self[name1],
                let value2 = self[name2],
                let value3 = self[name3]
            {
                return (value1, value2, value3)
            }
            return nil
        }

    }
}

extension Pattern: ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    init(stringLiteral value: String) {
        self.init(value)
    }
}
