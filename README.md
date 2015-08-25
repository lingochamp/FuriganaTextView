# FuriganaTextView
A simple wrapper view for UITextView that can display Furiganas.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![Example](https://raw.githubusercontent.com/Liulishuo-iOS/FuriganaTextView/master/img/example.png)

## Install

#### Install using Carthage

`FuriganaTextView` has been tested to work well with [Carthage](https://github.com/Carthage/Carthage). To install using Carthage:

1. First, you need to add `github "lingochamp/FuriganaTextView"` to your `Cartfile` .
2. When Carthage done building the frameworks, you will find a framework named `LLS.framework` contains the files needed for intergrating `FuriganaTextView` .
3. Drag `LLS.framework` into your project.
4. In the source file where you want to use `FuriganaTextView`, add `import LLS`, then you are ready to go.

#### Install Manually

Clone the repo then add all files inside `/src` into your project. 

Then you are ready to go.

## Usage

```swift

// Prepare furigana contents
let furiganas = [
  Furigana(text: "た", original: "田", range: NSMakeRange(0, 1)),
  Furigana(text: "なか", original: "中", range: NSMakeRange(1, 1)),
]
let contents = NSAttributedString(string: "田中さん、中華料理を食べたことありますか。")

// Tell FuriganaTextView about 
// the furiganas (which is an array of the Furigana struct) 
// and the contents to display (a NSAttributedString)
furiganaTextView.furiganas = furiganas
furiganaTextView.contents = contents

```

For more configurable properties, see `/src/FuriganaTextView.swift`.

## Requirements

* Builds with __Xcode 6.3__ and __Swift 1.2__
* Supports __iOS 7 and above__

#### Swift 2.0

* `FuriganaTextView` is currently supporting Swift 2.0 with Xcode 7.0 beta 6
* Swift 2.0 compatible version can be found at the `swift2` branch
* The `swift2` branch will be merged to `master` when Xcode 7.0 reaches GM

## Why not CTRubyAnnotation and CoreText

`FuriganaTextView` is built on top of TextKit and treats furiganas as custom attributes on the contents `NSAttributedString`.

The custom furigana attributes can coexist with any other text attributes (e.g. `NSFontAttributeName`, `NSForegroundColorAttributeName`, etc.).

We built it this way because we want to support iOS 7, and we want to take advantage of the high level features TextKit API offeres.

## Known Issues

* The `textContainerInset` property of the wrapped `UITextView` seems not working correctly.
* Furiganas displayed in vertical writing is not implemented yet.

