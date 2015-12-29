//
//  AwesomeButton.swift
//  AwesomeButtonExample
//
//  Created by Панов Андрей on 26.12.15.
//  Copyright © 2015 Панов Андрей. All rights reserved.
//

import UIKit

enum ImagePosition {
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
    private var icon: UIImage?
    private var positionImage: ImagePosition?
    private var textSize: CGFloat? {
        didSet {  }
    }
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    public var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    public var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.CGColor }
    }
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
        postInit()
    }
    
    func setImage(image:UIImage, highlitedImage: UIImage? = nil, selectedImage: UIImage? = nil, imagePosition: ImagePosition = .None) {
        
    }
    /*
    func setTitle(title: String, textSize: CGFloat, icon: UIImage, positionIcon: IconPosition) {
        
        self.icon = icon
        self.positionIcon = positionIcon
        self.title = title
        self.textSize = textSize
        setup()
    }
    */
    private func setup() {
        
    }
    
    private func postInit() {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        self.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        self.setContentHuggingPriority(1000, forAxis: .Horizontal)
        self.setContentHuggingPriority(1000, forAxis: .Vertical)
    }
}
