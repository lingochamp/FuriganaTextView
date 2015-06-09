//
//  StringRubyAnnotationExt.swift
//  Tydus
//
//  Created by Yan Li on 3/30/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import Foundation

public struct Furigana
{
  let text: String
  let original: String
  let range: NSRange
  let UUID: NSUUID = NSUUID()
  
  init(text: String, original: String, range: NSRange)
  {
    self.text = text
    self.original = original
    self.range = range
  }
}

public let kFuriganaAttributeName = "com.liulishuo.Furigana"

private let kFuriganaRepresentationFormatter = "|"

public func FuriganaStringRepresentation(furigana: Furigana) -> NSString
{
  let values: NSArray = [
    furigana.text,
    furigana.UUID.UUIDString,
    furigana.original
  ]
  return values.componentsJoinedByString(kFuriganaRepresentationFormatter)
}

public func FuriganaTextFromStringRepresentation(string: NSString) -> NSString?
{
  return string.componentsSeparatedByString(kFuriganaRepresentationFormatter).first as? NSString
}

public func FuriganaOriginalTextFromStringrepresentation(string: NSString) -> NSString?
{
  return string.componentsSeparatedByString(kFuriganaRepresentationFormatter).last as? NSString
}

private let kCharLength = 1

public extension NSString
{
  
  func substringAtIndex(index: Int) -> String
  {
    return substringWithRange(NSMakeRange(index, kCharLength))
  }

  func filteredString(predicateBlock: (NSString) -> Bool) -> NSString
  {
    var result = ""
    
    enumerateCharacters { (index, charString) -> Void in
      if predicateBlock(charString)
      {
        result += charString as String
      }
    }
    
    return result
  }
  
  func enumerateCharacters(enumeration: (Int, NSString) -> Void)
  {
    for i in 0..<length
    {
      enumeration(i, substringAtIndex(i))
    }
  }
  
}
