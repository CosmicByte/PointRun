//
//  Button.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

open class Button: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            titleLabel?.font = .systemFont(ofSize: fontSize)
        }
    }
    
    @IBInspectable var showsShadow = true {
        didSet {
            layer.shadowOpacity = showsShadow ? 1 : 0
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var normalBackgroundColor = UIColor.greenButton {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var highlightedBackgroundColor = UIColor.greenHighlightedButton {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor? = nil {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var normalShadowColor = UIColor.greenButtonShadow {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var highlightedShadowColor = UIColor.greenHighlightedButtonShadow {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var selectedShadowColor: UIColor? = nil {
        didSet {
            updateColors()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        cornerRadius = 4
        fontSize = 14
        showsShadow = true
        
        layer.shadowColor = normalShadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 0
        
        updateColors()
    }
    
    open func updateColors() {
        if let selectedBackgroundColor = selectedBackgroundColor, let selectedShadowColor = selectedShadowColor {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : (isSelected ? selectedBackgroundColor : normalBackgroundColor)
            layer.shadowColor = (isHighlighted ? highlightedShadowColor : (isSelected ? selectedShadowColor : normalShadowColor)).cgColor
        } else {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
            layer.shadowColor = (isHighlighted ? highlightedShadowColor : normalShadowColor).cgColor
        }
        
        setTitleColor(.white, for: .normal)
    }
}
