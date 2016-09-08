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
    case left, right
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
    static let borderColor: UIColor = UIColor.lightGray
    static let iconYOffset: CGFloat = 0.0
}

@IBDesignable
open class AwesomeButton: UIButton {
    
    //MARK: Designable
    
    @IBInspectable open var iconNormal: UIImage? {
        
        didSet { iconConfiguration(iconNormal, iconState: UIControlState()) }
    }
    @IBInspectable open var iconHighlighted: UIImage? {
        
        didSet { iconConfiguration(iconHighlighted, iconState: .highlighted) }
    }
    @IBInspectable open var iconSelected: UIImage? {
        
        didSet { iconConfiguration(iconSelected, iconState: .selected) }
    }
    @IBInspectable open var cornerRadius: CGFloat = ButtonStyle.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable open var borderWidth: CGFloat = ButtonStyle.borderWidth {
        
        didSet { layer.borderWidth = borderWidth }
    }
    @IBInspectable open var borderColor: UIColor = ButtonStyle.borderColor {
        
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    @IBInspectable open var iconYOffset: CGFloat = ButtonStyle.iconYOffset {
        
        didSet { setNewYOffset() }
    }
    
    //MARK: Public
    
    open var iconPosition: ImagePosition = .right {
        didSet {
            switchIconAndTextPosition()
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = backgroundColor?.withAlphaComponent(ButtonStyle.StateAlpha.highlighted)
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(ButtonStyle.StateAlpha.normal)
            }
        }
    }
    open override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = backgroundColor?.withAlphaComponent(ButtonStyle.StateAlpha.highlighted)
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(ButtonStyle.StateAlpha.normal)
            }
        }
    }
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = backgroundColor?.withAlphaComponent(ButtonStyle.StateAlpha.normal)
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(ButtonStyle.StateAlpha.disabled)
            }
        }
    }
    open var textSpacing: CGFloat = ButtonStyle.AttributedStringStyles.Spacing
    // store design
    fileprivate var iconAttachments: [UInt : NSAttributedString] = [:]
    fileprivate var attributedStrings: [UInt : NSAttributedString] = [:]
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        contentVerticalAlignment = .center
    }
    open func buttonWithIcon(_ icon: UIImage, highlightedImage: UIImage? = nil, selectedImage: UIImage? = nil, iconPosition: ImagePosition = .left, title: String = "") {
        setTitle(title, for: UIControlState())
        self.iconPosition = iconPosition
        iconNormal = icon
        iconHighlighted = highlightedImage
        iconSelected = selectedImage
    }
}

private extension AwesomeButton {
    
    func iconConfiguration(_ icon: UIImage?, iconState: UIControlState) {
        
        guard let iconUnwrapped = icon else { return }
        
        iconAttachments[iconState.rawValue] = getAttachmentStringWithImage(iconUnwrapped, iconState: iconState)
        attributedStrings[iconState.rawValue] = getAttributedStringForState(iconState)
        
        configurateAttributedStringWithState(iconState)
    }
    
    func switchIconAndTextPosition() {
        
        guard ((attributedStrings.isEmpty == false) || (iconAttachments.isEmpty == false)) else { return }
        
        [UIControlState.highlighted, UIControlState.selected].forEach({ stateButton in
            
            configurateAttributedStringWithState(stateButton)
        })
    }
    
    func configurateAttributedStringWithState(_ state: UIControlState) {
        
        let finalString = NSMutableAttributedString(string: "")
        
        if let attachmentString = iconAttachments[state.rawValue],
            let attributedString = attributedStrings[state.rawValue] {
                
                if iconPosition == .left {
                    finalString.append(attachmentString)
                    finalString.append(attributedString)
                    print("Left set for state \(state)")
                }
                else if iconPosition == .right {
                    finalString.append(attributedString)
                    finalString.append(attachmentString)
                    print("Right set for state \(state)")
                }
                setAttributedTitle(finalString, for: state)
        }
    }
    
    func getAttributedStringForState(_ buttonState: UIControlState) -> NSAttributedString {
        
        // order of if--else statement is important here
        if let titleUnwrapped = title(for: buttonState), let fontUnwrapped = titleLabel?.font, let textColor = titleColor(for: buttonState) {
            
            return NSAttributedString(string: titleUnwrapped, attributes: [NSFontAttributeName : fontUnwrapped, NSForegroundColorAttributeName : textColor, NSKernAttributeName : ButtonStyle.AttributedStringStyles.Spacing])
        }
        else if let attributedTitleUnwrapped = attributedTitle(for: buttonState) {
            
            return NSAttributedString(string: attributedTitleUnwrapped.string, attributes: attributedTitleUnwrapped.fontAttributes())
        }
        else {
            return NSAttributedString(string: "")
        }
    }
    
    func getImageForState(_ state: UIControlState) -> UIImage? {
        
        switch (state) {
        case UIControlState():
            return iconNormal
        case UIControlState.highlighted:
            return iconHighlighted
        case UIControlState.selected:
            return iconSelected
        default:
            return nil
        }
    }
    
    func calculateOffsetYForState(_ state: UIControlState) -> CGFloat {
        
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
    
    func getAttachmentStringWithImage(_ icon: UIImage, iconState: UIControlState) -> NSAttributedString {
        
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: calculateOffsetYForState(iconState), width: icon.size.width, height: icon.size.height).integral
        return NSAttributedString(attachment: attachment)
    }
    
    func setNewYOffset() {
        
        [UIControlState.highlighted, UIControlState.selected].forEach({ stateButton in
            
            if let image =  getImageForState(stateButton) {
                iconConfiguration(image, iconState: stateButton)
            }
        })
    }
}

private extension NSAttributedString {
    
    func fontAttributes() -> [String : AnyObject] {
        let limitRange = NSMakeRange(0, self.length)
        if let font = self.attribute(NSFontAttributeName, at: 0, longestEffectiveRange: nil, in: limitRange) {
            
            return [NSFontAttributeName : font as AnyObject, NSKernAttributeName : ButtonStyle.AttributedStringStyles.Spacing as AnyObject]
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
