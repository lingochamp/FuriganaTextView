//
//  FuriganaTextView.swift
//  Tydus
//
//  Created by Yan Li on 3/30/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import UIKit

struct FuriganaTextStyle
{
  let hostingLineHeightMultiple: CGFloat
  let textOffsetMultiple: CGFloat
}

// MARK: - Base Class

class FuriganaTextView: UIView
{
  
  // MARK: - Public
  
  var scrollEnabled: Bool = true
  var alignment: NSTextAlignment = .Left
  
  var furiganaEnabled = true
  var furiganaTextStyle = FuriganaTextStyle(hostingLineHeightMultiple: 1.6, textOffsetMultiple: 0)
  var furiganas: [Furigana]?
  
  var contents: NSAttributedString?
  {
    set
    {
      mutableContents = newValue?.mutableCopy() as? NSMutableAttributedString

      if furiganaEnabled
      {
        addFuriganaAttributes()
      }
      
      setup()
    }
    get
    {
      return mutableContents?.copy() as? NSAttributedString
    }
  }
  
  // MARK: - Private

  private var mutableContents: NSMutableAttributedString?
  private weak var underlyingTextView: UITextView?
  
  // [Yan Li]
  // A strong reference is needed, because NSLayoutManagerDelegate is unowned by the manager
  private var furiganaWordKerner: FuriganaWordKerner?
  
  private func setup()
  {
    underlyingTextView?.removeFromSuperview()
    
    if furiganaEnabled
    {
      setupFuriganaView()
    }
    else
    {
      setupRegularView()
    }
  }
  
  private func setupFuriganaView()
  {
    if let validContents = mutableContents
    {
      let layoutManager = FuriganaLayoutManager()
      layoutManager.textOffsetMultiple = furiganaTextStyle.textOffsetMultiple
      let kerner = FuriganaWordKerner()
      layoutManager.delegate = kerner
      
      let textContainer = NSTextContainer()
      layoutManager.addTextContainer(textContainer)
      
      let fullTextRange = NSMakeRange(0, (validContents.string as NSString).length)
      let paragrapStyle = NSMutableParagraphStyle()
      paragrapStyle.alignment = alignment
      paragrapStyle.lineHeightMultiple = furiganaTextStyle.hostingLineHeightMultiple
      validContents.addAttribute(NSParagraphStyleAttributeName, value: paragrapStyle, range: fullTextRange)
      
      let textStorage = NSTextStorage(attributedString: validContents)
      textStorage.addLayoutManager(layoutManager)
      
      let textView = textViewWithTextContainer(textContainer)
      addSubview(textView)
      addConstraints(fullLayoutConstraints(textView))
      
      furiganaWordKerner = kerner
      underlyingTextView = textView
    }
  }
  
  private func setupRegularView()
  {
    if let validContents = mutableContents
    {
      let textView = textViewWithTextContainer(nil)
      textView.attributedText = validContents
      addSubview(textView)
      addConstraints(fullLayoutConstraints(textView))
      
      underlyingTextView = textView
    }
  }
  
  private func textViewWithTextContainer(textContainer: NSTextContainer?) -> UITextView
  {
    let textView = UITextView(frame: bounds, textContainer: textContainer)
    textView.editable = false
    textView.scrollEnabled = scrollEnabled
    textView.alwaysBounceVertical = true
    textView.textContainerInset = UIEdgeInsetsZero
    textView.textContainer.lineFragmentPadding = 0
    
    return textView
  }
  
  private func fullLayoutConstraints(view: UIView) -> [AnyObject]
  {
    view.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    let vertical = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-(0)-[view]-(0)-|",
      options: nil,
      metrics: nil,
      views: ["view" : view])
    
    let horizontal = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(0)-[view]-(0)-|",
      options: nil,
      metrics: nil,
      views: ["view" : view])

    return vertical + horizontal
  }
  
}

// MARK: - Furigana Handling

extension FuriganaTextView
{
  
  private func addFuriganaAttributes()
  {
    if let validContents = mutableContents
    {
      if let validFuriganas = furiganas
      {
        var inserted = 0
        for (_, furigana) in enumerate(validFuriganas)
        {
          var furiganaRange = furigana.range
          
          let furiganaValue = FuriganaStringRepresentation(furigana)
          let furiganaLength = (furigana.text as NSString).length
          let contentsLenght = furigana.range.length
          
          if furiganaLength > contentsLenght
          {
            let currentAttributes = validContents.attributesAtIndex(furiganaRange.location + inserted, effectiveRange: nil)
            let kerningString = NSAttributedString(string: kDefaultFuriganaKerningControlCharacter, attributes: currentAttributes)
            
            let endLocation = furigana.range.location + furigana.range.length + inserted
            validContents.insertAttributedString(kerningString, atIndex: endLocation)
            
            let startLocation = furigana.range.location + inserted
            validContents.insertAttributedString(kerningString, atIndex: startLocation)
            
            let insertedLength = (kDefaultFuriganaKerningControlCharacter as NSString).length * 2
            inserted += insertedLength
            
            furiganaRange.location = startLocation
            furiganaRange.length += insertedLength
          }
          else
          {
            furiganaRange.location += inserted
          }
          
          validContents.addAttribute(kFuriganaAttributeName, value: furiganaValue, range: furiganaRange)
        }
        
        let fullTextRange = NSMakeRange(0, (validContents.string as NSString).length)
        validContents.fixAttributesInRange(fullTextRange)
        mutableContents = validContents
      }      
    }
  }
  
}

// MARK: - Auto Layout

extension FuriganaTextView
{
  
  override func intrinsicContentSize() -> CGSize
  {
    if let textView = underlyingTextView
    {
      var intrinsicSize = textView.sizeThatFits(CGSize(width: CGRectGetWidth(bounds), height: CGFloat.max))
      
      // [Yan Li]
      // There is a time that we have to multiply the result by the line height multiple
      // to make it work, but it seems fine now.
      
      // intrinsicSize.height *= furiganaTextStyle.hostingLineHeightMultiple
      
      return intrinsicSize
    }
    else
    {
      return CGSizeZero
    }
  }
  
}
