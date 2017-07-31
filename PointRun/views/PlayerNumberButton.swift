//
//  PlayerNumberButton.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

enum PlayerNumber: Int {
    case singleplayer = 1, multiplayer
    
    var thumbnail: UIImage {
        switch self {
        case .singleplayer:
            return #imageLiteral(resourceName: "Singleplayer").withRenderingMode(.alwaysTemplate)
        case .multiplayer:
            return #imageLiteral(resourceName: "Multiplayer").withRenderingMode(.alwaysTemplate)
        }
    }
}

class PlayerNumberButton: UIButton {
    
    @IBInspectable var players: Int = 1
    
    override var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateColors()
        }
    }
    
    fileprivate var playerNumber: PlayerNumber {
        guard let number = PlayerNumber(rawValue: players) else {
            fatalError("Invalid number of players selected")
        }
        
        return number
    }
    
    fileprivate let thumbnailImage: UIImageView
    fileprivate let bottomBorder: UIView
    
    required init?(coder aDecoder: NSCoder) {
        thumbnailImage = UIImageView()
        bottomBorder = UIView()
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = isSelected ? UIColor.greenButton : UIColor.white
        
        thumbnailImage.image = playerNumber.thumbnail
        thumbnailImage.tintColor = isSelected ? UIColor.white : UIColor.greenButton
        addSubview(thumbnailImage)
        
        bottomBorder.backgroundColor = isSelected ? UIColor.greenButtonShadow : UIColor.whiteButtonShadow
        addSubview(bottomBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let thumbnailImageHeight: CGFloat = 22
        let thumbnailImageSize = CGSize(width: thumbnailImageHeight * (playerNumber.thumbnail.size.width / playerNumber.thumbnail.size.height), height: thumbnailImageHeight)
        thumbnailImage.frame = CGRect(x: (frame.size.width - thumbnailImageSize.width) / 2, y: (frame.size.height - thumbnailImageSize.height) / 2, width: thumbnailImageSize.width, height: thumbnailImageSize.height)
        
        let bottomBorderHeight: CGFloat = 2
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - bottomBorderHeight, width: frame.size.width, height: bottomBorderHeight)
    }
    
    fileprivate func updateColors() {
        backgroundColor = isHighlighted ? UIColor.greenHighlightedButton : (isSelected ? UIColor.greenButton : UIColor.white)
        layer.shadowColor = (isHighlighted ? UIColor.greenHighlightedButtonShadow : (isSelected ? UIColor.greenButtonShadow : UIColor.whiteButtonShadow)).cgColor
        thumbnailImage.tintColor = isHighlighted ? UIColor.white : (isSelected ? UIColor.white : UIColor.greenButton)
        bottomBorder.backgroundColor = isHighlighted ? UIColor.greenHighlightedButtonShadow : (isSelected ? UIColor.greenButtonShadow : UIColor.whiteButtonShadow)
    }
}
