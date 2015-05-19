//
//  FuriganaLayoutManager.swift
//  Tydus
//
//  Created by Yan Li on 3/30/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

/**
 *
 * Ruby Annotation in Japanese Language:
 * ルビ: http://ja.wikipedia.org/wiki/ルビ
 * 熟字訓: http://zh.wikipedia.org/wiki/熟字訓
 * 当て字: http://ja.wikipedia.org/wiki/当て字
 *
 */

import UIKit

// [Yan Li]
// Set kFuriganaDebugging to true enables glyph rect border
private let kFuriganaDebugging = false

let kDefaultFuriganaKerningControlCharacter = " "
let kDefaultFuriganaFontMultiple: CGFloat = 2

class FuriganaLayoutManager: NSLayoutManager
{
  
  var textOffsetMultiple: CGFloat = 0
  
  override func drawGlyphsForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint)
  {
    super.drawGlyphsForGlyphRange(glyphsToShow, atPoint: origin)

    let attributesToEnumerate = characterRangeForGlyphRange(glyphsToShow, actualGlyphRange: nil)
    
    textStorage?.enumerateAttribute(kFuriganaAttributeName, inRange: attributesToEnumerate, options: .allZeros) { (attributeValue, range, _) in
      if let furiganaStringRepresentation = attributeValue as? String
      {
        if let furiganaText = FuriganaTextFromStringRepresentation(furiganaStringRepresentation)
        {
          let font = self.textStorage!.attribute(NSFontAttributeName, atIndex: range.location, effectiveRange: nil) as! UIFont
          let color = self.textStorage!.attribute(NSForegroundColorAttributeName, atIndex: range.location, effectiveRange: nil) as? UIColor
          self.drawFurigana(furiganaText, characterRange: range, characterFont: font, textColor: color)
        }
      }
    }
  }
  
  private func drawFurigana(text: NSString, characterRange: NSRange, characterFont: UIFont, textColor: UIColor?)
  {
    let glyphRange = glyphRangeForCharacterRange(characterRange, actualCharacterRange: nil)
    let glyphContainer = textContainerForGlyphAtIndex(glyphRange.location, effectiveRange: nil)!
    var glyphBounds = boundingRectForGlyphRange(glyphRange, inTextContainer: glyphContainer)

    let characterFontSize = characterFont.pointSize
    let furiganaFontSize = characterFontSize / kDefaultFuriganaFontMultiple
    let furiganaFont = UIFont.systemFontOfSize(furiganaFontSize)

    glyphBounds.origin.y = CGRectGetMinY(glyphBounds) + CGRectGetHeight(glyphBounds) * textOffsetMultiple
    
    let paragrapStyle = NSMutableParagraphStyle()
    paragrapStyle.alignment = .Center
    
    var furiganaAttributes = [
      NSFontAttributeName : furiganaFont,
      NSParagraphStyleAttributeName : paragrapStyle,
    ]
    
    if let color = textColor
    {
      furiganaAttributes[NSForegroundColorAttributeName] = color
    }
    
    text.drawInRect(glyphBounds, withAttributes: furiganaAttributes)
    
    if kFuriganaDebugging
    {
      UIColor.redColor().setStroke()
      UIBezierPath(rect: glyphBounds).stroke()
    }
  }
  
}
