//
//  UILabel+Extension.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 30/06/22.
//

import SkeletonView
import UIKit
public extension UILabel {
    
    enum FontType {
        case medium
        case bold
        case light
        case semibold
        case regular
        case black
        public var fontName : String {
            switch self {
            case .medium:
                return "Raleway-Medium"
            case .bold:
                return "Raleway-Bold"
            case .light:
                return "Raleway-Light"
            case .semibold:
                return "Raleway-SemiBold"
            case .regular:
                return "Raleway-Regular"
            case .black:
                return "Raleway-Black"
            }
        }
    }
    
    func style(_ type: FontType, _ size: CGFloat)  {
        self.font = .style(type, size)
    }
    
    func roomTitleDesign() {
        self.textColor = .olchaTextBlack
        self.style(.semibold, 24)
    }
}



public class LabelTapGesture: UITapGestureRecognizer {
    var tapOnText: String?
    var completion: (() -> ())?
}

public extension String {
    
    func attributed(_ attributes: [NSAttributedString.Key:Any]?) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func range(of rangeText:String) -> NSRange {
        return (self as NSString).range(of: rangeText)
    }
    
}

public extension UILabel {
    
    public func calculateMaxLines(actualWidth: CGFloat? = nil) -> Int {
        var width = frame.size.width
        if let actualWidth = actualWidth {
            width = actualWidth
        }
        let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    public func addTapGesture(text: String, textAttributes: [NSAttributedString.Key:Any]? = nil,
                              tapOnText: String, tapOnTextAttributes: [NSAttributedString.Key:Any],
                              completion: @escaping () -> ()) {
        let attributedString = text.attributed(textAttributes)
        attributedString.addAttributes(tapOnTextAttributes, range: text.range(of: tapOnText))
        self.isUserInteractionEnabled = true
        self.attributedText = attributedString
        let tapgesture: LabelTapGesture = .init(target: self, action: #selector(self.tappedOnAttributedText(_:)))
        tapgesture.numberOfTapsRequired = 1
        tapgesture.tapOnText = tapOnText
        tapgesture.completion = completion
        self.addGestureRecognizer(tapgesture)
    }
    
    @objc func tappedOnAttributedText(_ gesture: LabelTapGesture) {
        guard let text = self.text,
              let tapOnText = gesture.tapOnText,
              let completion = gesture.completion else { return }
        guard gesture.didTapAttributedTextInLabel(label: self, inRange: text.range(of: tapOnText)) else { return }
        completion()
    }
    
}

public extension UITapGestureRecognizer {
    
    public func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

public extension UILabel {
    func skeletonConfiguration(lines: SkeletonTextNumberOfLines = .inherited,
                               lastLinePercentage: Int = 70,
                               height: SkeletonTextLineHeight = .fixed(24),
                               space: CGFloat = 4
    ) {
        self.linesCornerRadius = 2
        self.skeletonTextNumberOfLines = lines
        self.lastLineFillPercent = lastLinePercentage
        self.skeletonTextLineHeight = height
        self.skeletonLineSpacing = space
    }
}

public extension UITextView {
    func skeletonConfiguration(lines: SkeletonTextNumberOfLines = .inherited,
                               lastLinePercentage: Int = 70,
                               height: SkeletonTextLineHeight = .fixed(24),
                               space: CGFloat = 4
    ) {
        self.linesCornerRadius = 2
        self.skeletonTextNumberOfLines = lines
        self.lastLineFillPercent = lastLinePercentage
        self.skeletonTextLineHeight = height
        self.skeletonLineSpacing = space
    }
}
