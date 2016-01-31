//
//  AwesomeButton.swift
//
//  Created by Andrey Panov on 26.12.15.
//  Copyright © 2015 Andrey Panov. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public enum ImagePosition {
    case Left, Right
}

private struct ButtonStyle {
    
    struct StateAlpha {
        static let normal = CGFloat(1.0)
        static let highlighted = CGFloat(0.7)
        static let disabled = CGFloat(0.5)
    }
    struct AttributedStringStyles {
        static let Spacing: CGFloat = 1.2
    }
    static let cornerRadius: CGFloat = 5.0
    static let borderWidth: CGFloat = 3.0
    static let borderColor: UIColor = UIColor.lightGrayColor()
    static let iconYOffset: CGFloat = 0.0
}

@IBDesignable
public class AwesomeButton: UIButton {
    
    //MARK: Designable
    
    @IBInspectable public var iconNormal: UIImage? {
        
        didSet { iconConfiguration(iconNormal, iconState: .Normal) }
    }
    @IBInspectable public var iconHighlighted: UIImage? {
        
        didSet { iconConfiguration(iconHighlighted, iconState: .Highlighted) }
    }
    @IBInspectable public var iconSelected: UIImage? {
        
        didSet { iconConfiguration(iconSelected, iconState: .Selected) }
    }
    @IBInspectable public var cornerRadius: CGFloat = ButtonStyle.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable public var borderWidth: CGFloat = ButtonStyle.borderWidth {
        
        didSet { layer.borderWidth = borderWidth }
    }
    @IBInspectable public var borderColor: UIColor = ButtonStyle.borderColor {
        
        didSet { layer.borderColor = borderColor.CGColor }
    }
    
    @IBInspectable public var iconYOffset: CGFloat = ButtonStyle.iconYOffset {
        
        didSet { setNewYOffset() }
    }
    
    //MARK: Public
    
    public var iconPosition: ImagePosition = .Right {
        didSet {
            switchIconAndTextPosition()
        }
    }
    public override var highlighted: Bool {
        didSet {
            if highlighted {
                backgroundColor = backgroundColor?.colorWithAlphaComponent(ButtonStyle.StateAlpha.highlighted)
            } else {
                backgroundColor = backgroundColor?.colorWithAlphaComponent(ButtonStyle.StateAlpha.normal)
            }
        }
    }
    public override var selected: Bool {
        didSet {
            if selected {
                backgroundColor = backgroundColor?.colorWithAlphaComponent(ButtonStyle.StateAlpha.highlighted)
            } else {
                backgroundColor = backgroundColor?.colorWithAlphaComponent(ButtonStyle.StateAlpha.normal)
            }
        }
    }
    public override var enabled: Bool {
        didSet {
            if enabled {
                backgroundColor = backgroundColor?.colorWithAlphaComponent(ButtonStyle.StateAlpha.normal)
            } else {
                backgroundColor = backgroundColor?.colorWithAlphaComponent(ButtonStyle.StateAlpha.disabled)
            }
        }
    }
    public var textSpacing: CGFloat = ButtonStyle.AttributedStringStyles.Spacing
    // store design
    private var iconAttachments: [UInt : NSAttributedString] = [:]
    private var attributedStrings: [UInt : NSAttributedString] = [:]
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        contentVerticalAlignment = .Center
    }
    public func buttonWithIcon(icon: UIImage, highlightedImage: UIImage? = nil, selectedImage: UIImage? = nil, iconPosition: ImagePosition = .Left, title: String = "") {
        setTitle(title, forState: .Normal)
        self.iconPosition = iconPosition
        iconNormal = icon
        iconHighlighted = highlightedImage
        iconSelected = selectedImage
    }
}

private extension AwesomeButton {
    
    func iconConfiguration(icon: UIImage?, iconState: UIControlState) {
        
        guard let iconUnwrapped = icon else { return }
        
        iconAttachments[iconState.rawValue] = getAttachmentStringWithImage(iconUnwrapped, iconState: iconState)
        attributedStrings[iconState.rawValue] = getAttributedStringForState(iconState)
        
        configurateAttributedStringWithState(iconState)
    }
    
    func switchIconAndTextPosition() {
        
        guard ((attributedStrings.isEmpty == false) || (iconAttachments.isEmpty == false)) else { return }
        
        [UIControlState.Normal, UIControlState.Highlighted, UIControlState.Selected].forEach({ stateButton in
            
            configurateAttributedStringWithState(stateButton)
        })
    }
    
    func configurateAttributedStringWithState(state: UIControlState) {
        
        let finalString = NSMutableAttributedString(string: "")
        
        if let attachmentString = iconAttachments[state.rawValue],
            let attributedString = attributedStrings[state.rawValue] {
                
                if iconPosition == .Left {
                    finalString.appendAttributedString(attachmentString)
                    finalString.appendAttributedString(attributedString)
                    print("Left set for state \(state)")
                }
                else if iconPosition == .Right {
                    finalString.appendAttributedString(attributedString)
                    finalString.appendAttributedString(attachmentString)
                    print("Right set for state \(state)")
                }
                setAttributedTitle(finalString, forState: state)
        }
    }
    
    func getAttributedStringForState(buttonState: UIControlState) -> NSAttributedString {
        
        // order of if--else statement is important here
        if let titleUnwrapped = titleForState(buttonState), let fontUnwrapped = titleLabel?.font, let textColor = titleColorForState(buttonState) {
            
            return NSAttributedString(string: titleUnwrapped, attributes: [NSFontAttributeName : fontUnwrapped, NSForegroundColorAttributeName : textColor, NSKernAttributeName : ButtonStyle.AttributedStringStyles.Spacing])
        }
        else if let attributedTitleUnwrapped = attributedTitleForState(buttonState) {
            
            return NSAttributedString(string: attributedTitleUnwrapped.string, attributes: attributedTitleUnwrapped.fontAttributes())
        }
        else {
            return NSAttributedString(string: "")
        }
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
    
    func calculateOffsetYForState(state: UIControlState) -> CGFloat {
        
        guard let imageHeight = getImageForState(state)?.size.height else { return 0.0 }
        
        let attr = getAttributedStringForState(state)
        let imageOffsetY: CGFloat
        if imageHeight > attr.fontSize() {
            imageOffsetY = attr.fontOffset() - imageHeight / 2 + attr.mid()
        } else {
            imageOffsetY = 0
        }
        return imageOffsetY + iconYOffset
    }
    
    func getAttachmentStringWithImage(icon: UIImage, iconState: UIControlState) -> NSAttributedString {
        
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRectIntegral(CGRectMake(0, calculateOffsetYForState(iconState), icon.size.width, icon.size.height))
        return NSAttributedString(attachment: attachment)
    }
    
    func setNewYOffset() {
        
        [UIControlState.Normal, UIControlState.Highlighted, UIControlState.Selected].forEach({ stateButton in
            
            if let image =  getImageForState(stateButton) {
                iconConfiguration(image, iconState: stateButton)
            }
        })
    }
}

private extension NSAttributedString {
    
    func fontAttributes() -> [String : AnyObject] {
        let limitRange = NSMakeRange(0, self.length)
        if let font = self.attribute(NSFontAttributeName, atIndex: 0, longestEffectiveRange: nil, inRange: limitRange) {
            
            return [NSFontAttributeName : font, NSKernAttributeName : ButtonStyle.AttributedStringStyles.Spacing]
        }
        return [:]
    }
    
    func fontSize() -> CGFloat {
        if let fontSize = (self.fontAttributes()[NSFontAttributeName])?.pointSize { return fontSize }
        return 0.0
    }
    func fontOffset() -> CGFloat {
        if let offset = (self.fontAttributes()[NSFontAttributeName])?.descender { return offset }
        return 0.0
    }
    func mid() -> CGFloat {
        if let font = (self.fontAttributes()[NSFontAttributeName]) { return font.descender + font.capHeight }
        return 0.0
    }
    
    
}