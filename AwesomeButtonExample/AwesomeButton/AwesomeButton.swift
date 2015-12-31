//
//  AwesomeButton.swift
//  AwesomeButtonExample
//
//  Created by Панов Андрей on 26.12.15.
//  Copyright © 2015 Панов Андрей. All rights reserved.
//

import UIKit

public enum ImagePosition {
    case Left, Center, Right, None
}

struct ButtonStyles {
    struct Color {
        
    }
    struct Font {
        
    }
    
}

public class AwesomeButton: UIButton {
    
    private var title: String?
    private var images: (UIImage, UIImage, UIImage, ImagePosition)?
    private var fontName: UIFont? {
        didSet {  }
    }
    private var imageOffsetY: CGFloat = 0
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    @IBInspectable
    public var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.CGColor }
    }
    @IBInspectable
    public var masksToBound: Bool = true {
        didSet { layer.masksToBounds = masksToBound }
    }
    
/*
    convenience init(icon: UIImage, positionIcon: IconPosition = .None, text: String = "", textSize: CGFloat = 17.0) {
        
        self.init(type: UIButtonType.Custom)
        self.icon = icon
        self.positionIcon = positionIcon
        self.text = text
        self.textSize = textSize
        
    }
    
    init(type: UIButtonType) {
        super.init(frame: CGRect(origin: CGPoint(), size: CGSize()))

    }
*/
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //postInit()
    }
    
    public func setImages(normalImage normalImage:UIImage, highlitedImage: UIImage, selectedImage: UIImage, imagePosition: ImagePosition = .None) {
        
        self.images = (normalImage, highlitedImage, selectedImage, imagePosition)
    }
    
    public func setTitle(title title: String, font: UIFont) {
        
        self.title = title
        self.fontName = font
    }
    
    public func setupIT() {
        setup()
    }
}

private extension AwesomeButton {
    
    func setup() {
        
        if let imagesUnwrapped = images {
            
            if let titleUnwrapped = title {
                let string = NSAttributedString(string: titleUnwrapped, attributes: [NSFontAttributeName : fontName!])
                createAttributedImageString(string, images: imagesUnwrapped)
                //some func
            } else {
                setImage(imagesUnwrapped.0, forState: .Normal)
                setImage(imagesUnwrapped.1, forState: .Highlighted)
                setImage(imagesUnwrapped.2, forState: .Selected)
            }
        }
    }
    
    func createAttributedImageString(string: NSAttributedString, images: (UIImage, UIImage, UIImage, ImagePosition)) {
        
        let finalString: NSMutableAttributedString
        
        //  start with left image position
        let attachment = NSTextAttachment()
        attachment.image = images.0
        attachment.bounds = CGRectMake(0, -7, images.0.size.width, images.0.size.height)
        let attachmentString = NSAttributedString(attachment: attachment)
        finalString = NSMutableAttributedString(attributedString: attachmentString)
        finalString.appendAttributedString(string)
        setAttributedTitle(finalString, forState: .Normal)
    }
    
    // need it?
    func postInit() {
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        self.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        self.setContentHuggingPriority(1000, forAxis: .Horizontal)
        self.setContentHuggingPriority(1000, forAxis: .Vertical)
    }
    
    // где-то нужно еще делить на 2
    func calculateOffsetYForState(state: UIControlState) -> CGFloat {
        
        guard let fontNameUnwrapped = fontName else { return 0.0 }
        let imageHeight = imageHeightForState(state)
        if imageHeight == 0.0 { return 0.0 }
        
        let titleAndFontSizeDiff = titleLabel!.frame.size.height - fontNameUnwrapped.pointSize
        print(titleAndFontSizeDiff)
        
        imageOffsetY = (-1 * (((fontNameUnwrapped.pointSize + (titleAndFontSizeDiff / 2)) - imageHeight) / 2)) - titleAndFontSizeDiff / 2 + imageOffsetY
        
        if fontNameUnwrapped.pointSize > imageHeight {
            
            imageOffsetY = fontNameUnwrapped.pointSize - imageHeight
        }
        return imageOffsetY
    }
    
    func imageHeightForState(state: UIControlState) -> CGFloat {
        
        guard let imagesUnwrapped = images else { return 0.0 }
        
        let imageHeight: CGFloat
        switch (state) {
        case UIControlState.Normal:
            imageHeight = imagesUnwrapped.0.size.height
        case UIControlState.Highlighted:
            imageHeight = imagesUnwrapped.1.size.height
        case UIControlState.Selected:
            imageHeight = imagesUnwrapped.2.size.height
        default:
            imageHeight = 0.0
        }
        return imageHeight
    }
}
