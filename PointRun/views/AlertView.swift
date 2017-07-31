//
//  AlertView.swift
//  PointRun
//
//  Created by Jack Cook on 8/17/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit

class AlertView: UIView {

    var opacityView: UIView!
    var alertView: UIView!
    
    var device = UIScreen.main.bounds.size
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: device.width, height: device.height))
        
        opacityView = UIView(frame: CGRect(x: 0, y: 0, width: device.width, height: device.height))
        opacityView.backgroundColor = UIColor.black
        opacityView.alpha = 0.0
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(AlertView.hide))
        opacityView.addGestureRecognizer(tgr)
        
        
        alertView = UIView(frame: CGRect(x: (device.width - alertWidth) / 2, y: (device.height - alertHeight) / 2, width: alertWidth, height: alertHeight))
        alertView.alpha = 0.0
        
        let alertBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight))
        alertBackground.image = #imageLiteral(resourceName: "Element11")
        
        let alertIcon = UIImageView(frame: CGRect(x: (alertWidth - 29) / 2, y: 6, width: 29, height: 24))
        alertIcon.image = #imageLiteral(resourceName: "Warning")
        
        let alertText = UILabel(frame: CGRect(x: 18, y: 58, width: alertWidth - 36, height: 48))
        alertText.text = "Be mindful of traffic, obstructions, and other hazards while playing PointRun!"
        alertText.font = .systemFont(ofSize: 13)
        alertText.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00)
        alertText.numberOfLines = 0
        alertText.textAlignment = NSTextAlignment.center
        
        let alertButton = Button()
        alertButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        alertButton.setTitle("Start game", for: .normal)
        
        alertButton.frame = CGRect(x: 8, y: alertHeight - 49, width: alertWidth - 16, height: 40)
        
        alertView.addSubview(alertBackground)
        alertView.addSubview(alertIcon)
        alertView.addSubview(alertText)
        alertView.addSubview(alertButton)
        
        self.addSubview(opacityView)
        self.addSubview(alertView)
    }
    
    func show() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.opacityView.alpha = 0.5
            self.alertView.alpha = 1.0
        }) 
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            self.removeFromSuperview()
        }) 
    }
}
