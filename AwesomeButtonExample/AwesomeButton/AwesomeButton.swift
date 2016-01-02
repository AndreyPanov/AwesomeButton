//
//  AwesomeButton.swift
//  AwesomeButtonExample
//
//  Created by Панов Андрей on 26.12.15.
//  Copyright © 2015 Панов Андрей. All rights reserved.
//

import UIKit

public enum ImagePosition: Int {
    case Left = 0
    case Center = 1
    case Right = 2
    case None = 3
}

struct ButtonStyles {
    struct Color {
        
    }
    struct Font {
        
    }
    
}
@IBDesignable
public class AwesomeButton: UIButton {
    
    //MARK: Designable
    @IBInspectable public var iconNormal: UIImage? {
        didSet {
            iconConfiguration(iconNormal, iconState: .Normal) }
    }
    @IBInspectable public var iconHighlighted: UIImage? {
        didSet {
            iconConfiguration(iconHighlighted, iconState: .Highlighted) }
    }
    @IBInspectable public var iconSelected: UIImage? {
        didSet {
            iconConfiguration(iconSelected, iconState: .Selected) }
    }
    @IBInspectable public var cornerRadius: CGFloat = 3 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 3 {
        didSet { layer.borderWidth = borderWidth }
    }
    @IBInspectable public var borderColor: UIColor = UIColor.redColor() {
        didSet { layer.borderColor = borderColor.CGColor }
    }
    
    //MARK public
    
    public var iconPosition: ImagePosition = .Left {
        didSet {  }
    }
    public var numberOfLines: Int = 1 {
        didSet { titleLabel?.numberOfLines = numberOfLines }
    }
}
private extension AwesomeButton {
    
    func iconConfiguration(icon: UIImage?, iconState: UIControlState) {
        
        guard let iconUnwrapped = icon else { return }
        
        let finalString: NSMutableAttributedString
        let attrString = getAttributedStringForState(iconState)
        //  start with left image position
        let attachment = NSTextAttachment()
        attachment.image = iconUnwrapped
        attachment.bounds = CGRectMake(0, calculateOffsetYForState(iconState, fontSize: attrString.fontSize()), iconUnwrapped.size.width, iconUnwrapped.size.height)
        let attachmentString = NSAttributedString(attachment: attachment)
        finalString = NSMutableAttributedString(attributedString: attachmentString)
        finalString.appendAttributedString(attrString)
        setAttributedTitle(finalString, forState: iconState)
    }
    
    func getAttributedStringForState(buttonState: UIControlState) -> NSAttributedString {
        ///print(buttonState.rawValue)
        //print(attributedTitleForState(buttonState)?.string)
        //print(titleForState(buttonState))
        print("--------------")
        
        // order of if--else statement is important here
        if let titleUnwrapped = titleForState(buttonState) {
            
            let attributedString = NSAttributedString(string: titleUnwrapped, attributes: [NSFontAttributeName : titleLabel!.font])
            return attributedString
        }
        else if  let attributedTitleUnwrapped = attributedTitleForState(buttonState) {
            
            return NSAttributedString(string: attributedTitleUnwrapped.string, attributes: attributedTitleUnwrapped.fontAttributes())
        }
        
        return NSAttributedString(string: "")
    }
    
    func getImageForState(state: UIControlState) -> UIImage? {
        
        switch (state) {
        case UIControlState.Normal:
            return iconNormal
        case UIControlState.Highlighted:
            return iconHighlighted
        case UIControlState.Selected:
            return iconSelected
        default:
            return nil
        }
    }
    
    func calculateOffsetYForState(state: UIControlState, fontSize: CGFloat) -> CGFloat {
        
        //let imageOffsetY = -1 *
        
        guard let imageHeight = getImageForState(state)?.size.height else { return 0.0 }
        
        //let titleAndFontSizeDiff = titleLabel!.frame.size.height - fontNameUnwrapped.pointSize
        //print(titleAndFontSizeDiff)
        
        let imageOffsetY = -1 * (fontSize - imageHeight) / 2
        print(fontSize)
        print(imageOffsetY)
        return imageOffsetY
        /*
        if fontNameUnwrapped.pointSize > imageHeight {
            
            imageOffsetY = fontNameUnwrapped.pointSize - imageHeight
        }
        return imageOffsetY*/
    }
}

extension NSAttributedString {
    
    func fontAttributes() -> [String : AnyObject] {
        let limitRange = NSMakeRange(0, self.length)
        if let font = self.attribute(NSFontAttributeName, atIndex: 0, longestEffectiveRange: nil, inRange: limitRange) {
            
            return [NSFontAttributeName : font]
        }
        return [:]
    }
    
    func fontSize() -> CGFloat {
        if let fontSize = (self.fontAttributes()[NSFontAttributeName])?.fontSize {
            return fontSize
        }
        return 0.0
    }
}

