//
//  Colors.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var greenButton: UIColor {
        return UIColor(red: 27/255, green: 188/255, blue: 155/255, alpha: 1)
    }
    
    static var greenButtonShadow: UIColor {
        return greenHighlightedButton
    }
    
    static var greenHighlightedButton: UIColor {
        return UIColor(red: 24/255, green: 169/255, blue: 136/255, alpha: 1)
    }
    
    static var greenHighlightedButtonShadow: UIColor {
        return UIColor(red: 73/255, green: 153/255, blue: 131/255, alpha: 1)
    }
    
    static var greenButtonText: UIColor {
        return UIColor(red: 20/255, green: 99/255, blue: 82/255, alpha: 1)
    }
    
    static var whiteButtonShadow: UIColor {
        return UIColor(red: 211/255, green: 216/255, blue: 217/255, alpha: 1)
    }
    
    static var grayButton: UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    static var grayButtonShadow: UIColor {
        return UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1)
    }
}
