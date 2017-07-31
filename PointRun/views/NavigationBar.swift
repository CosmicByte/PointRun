//
//  NavigationBar.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

class NavigationBar: UIView {
    
    fileprivate let bottomBorder: UIView
    
    required init?(coder aDecoder: NSCoder) {
        bottomBorder = UIView()
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomBorder.backgroundColor = UIColor.whiteButtonShadow
        insertSubview(bottomBorder, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bottomBorderHeight: CGFloat = 2
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - bottomBorderHeight, width: frame.size.width, height: bottomBorderHeight)
    }
}
