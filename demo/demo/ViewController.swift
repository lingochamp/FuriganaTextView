//
//  ViewController.swift
//  demo
//
//  Created by Yan Li on 5/12/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

  @IBOutlet weak var textView: FuriganaTextView!
  
  private var exampleFont: UIFont {
    if let fontDescriptor = UIFontDescriptor(name: "Hiragino Mincho ProN", size: 24).fontDescriptorWithSymbolicTraits(.TraitBold)
    {
      return UIFont(descriptor: fontDescriptor, size: 24)
    }
    else
    {
      return UIFont.boldSystemFontOfSize(24)
    }
  }
  
  private var exampleFontSansSerif: UIFont {
    let fontDescriptor = UIFontDescriptor(name: "Hiragino Kaku Gothic ProN", size: 24)
    return UIFont(descriptor: fontDescriptor, size: 24)
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let contents = NSMutableAttributedString(string: "田中さん、中華料理を食べたことありますか。\n", attributes: [NSFontAttributeName : exampleFont])
    contents.appendAttributedString(NSAttributedString(string: "田中さん、中華料理を食べたことありますか。", attributes: [NSFontAttributeName : exampleFontSansSerif]))
    
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(5, 2))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(27, 2))
    
    let furiganas = [
      Furigana(text: "た", original: "田", range: NSMakeRange(0, 1)),
      Furigana(text: "なか", original: "中", range: NSMakeRange(1, 1)),
      Furigana(text: "ちゅうかう", original: "中華", range: NSMakeRange(5, 2)), // The hiraganas are for demostration purpose only, they are actually incorrect
      Furigana(text: "りょうり", original: "料理", range: NSMakeRange(7, 2)), // The hiraganas are for demostration purpose only, they are actually incorrect
      Furigana(text: "た", original: "食", range: NSMakeRange(10, 1)),
      Furigana(text: "た", original: "田", range: NSMakeRange(22, 1)),
      Furigana(text: "なか", original: "中", range: NSMakeRange(23, 1)),
      Furigana(text: "ちゅうかう", original: "中華", range: NSMakeRange(27, 2)), // The hiraganas are for demostration purpose only, they are actually incorrect
      Furigana(text: "りょうり", original: "料理", range: NSMakeRange(29, 2)), // The hiraganas are for demostration purpose only, they are actually incorrect
      Furigana(text: "り", original: "理", range: NSMakeRange(30, 1)),
      Furigana(text: "た", original: "食", range: NSMakeRange(32, 1)),
    ]

    textView.scrollEnabled = true
    textView.furiganaEnabled = true
    textView.furiganas = furiganas
    textView.contents = contents
  }

}

