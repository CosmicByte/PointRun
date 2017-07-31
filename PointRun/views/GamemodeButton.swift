//
//  GamemodeButton.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

class GamemodeButton: Button {
    
    @IBInspectable var gamemodeValue: Int = Gamemode.timed.rawValue {
        didSet {
            updateContent()
        }
    }
    
    fileprivate var gamemode: Gamemode {
        guard let mode = Gamemode(rawValue: gamemodeValue) else {
            fatalError("Invalid gamemode selected")
        }
        
        return mode
    }
    
    fileprivate let thumbnailImage: UIImageView
    fileprivate let nameLabel: UILabel
    fileprivate let descriptionLabel: UILabel
    
    required init?(coder aDecoder: NSCoder) {
        thumbnailImage = UIImageView()
        nameLabel = UILabel()
        descriptionLabel = UILabel()
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let thumbnailImageLeftMargin: CGFloat = 14
        let thumbnailImageWidth: CGFloat = 39
        let thumbnailImageSize = CGSize(width: thumbnailImageWidth, height: thumbnailImageWidth * (gamemode.thumbnail.size.height / gamemode.thumbnail.size.width))
        thumbnailImage.frame = CGRect(x: thumbnailImageLeftMargin, y: (frame.size.height - thumbnailImageSize.height) / 2, width: thumbnailImageSize.width, height: thumbnailImageSize.height)
        
        let nameLabelLeftMargin: CGFloat = 10
        let nameLabelTopMargin: CGFloat = 13
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: thumbnailImage.frame.origin.x + thumbnailImage.frame.size.width + nameLabelLeftMargin, y: nameLabelTopMargin, width: nameLabel.frame.size.width, height: nameLabel.frame.size.height)
        
        let descriptionLabelLeftMargin: CGFloat = 10
        let descriptionLabelTopMargin: CGFloat = 0
        descriptionLabel.frame = CGRect(x: thumbnailImage.frame.origin.x + thumbnailImage.frame.size.width + descriptionLabelLeftMargin, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + descriptionLabelTopMargin, width: frame.size.width - thumbnailImage.frame.origin.x - thumbnailImage.frame.size.width - nameLabelLeftMargin - descriptionLabelLeftMargin, height: frame.size.height - nameLabel.frame.origin.y - nameLabel.frame.size.height - descriptionLabelTopMargin - nameLabelTopMargin)
    }
    
    fileprivate func updateContent() {
        thumbnailImage.image = gamemode.thumbnail
        addSubview(thumbnailImage)
        
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.text = gamemode.title
        nameLabel.textColor = .white
        addSubview(nameLabel)
        
        descriptionLabel.font = .systemFont(ofSize: 11)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = gamemode.description
        descriptionLabel.textColor = .greenButtonText
        addSubview(descriptionLabel)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
