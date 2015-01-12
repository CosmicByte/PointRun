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
    
    var device = UIScreen.mainScreen().bounds.size
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(frame: CGRectMake(0, 0, device.width, device.height))
        
        opacityView = UIView(frame: CGRectMake(0, 0, device.width, device.height))
        opacityView.backgroundColor = UIColor.blackColor()
        opacityView.alpha = 0.0
        
        let tgr = UITapGestureRecognizer(target: self, action: Selector("hide"))
        opacityView.addGestureRecognizer(tgr)
        
        
        alertView = UIView(frame: CGRectMake((device.width - alertWidth) / 2, (device.height - alertHeight) / 2, alertWidth, alertHeight))
        alertView.alpha = 0.0
        
        let alertBackground = UIImageView(frame: CGRectMake(0, 0, alertWidth, alertHeight))
        alertBackground.image = UIImage(named: "element11.png")
        
        let alertIcon = UIImageView(frame: CGRectMake((alertWidth - 29) / 2, 6, 29, 24))
        alertIcon.image = UIImage(named: "warning.png")
        
        let alertText = UILabel(frame: CGRectMake(18, 58, alertWidth - 36, 48))
        alertText.text = "Be mindful of traffic, obstructions, and other hazards while playing PointRun!"
        alertText.font = UIFont(name: "Open Sans", size: 13.0)
        alertText.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00)
        alertText.numberOfLines = 0
        alertText.textAlignment = NSTextAlignment.Center
        
        let alertButton = UIButton(frame: CGRectMake(8, alertHeight - 49, alertWidth - 16, 40))
        alertButton.setImage(UIImage(named: "element08.png"), forState: UIControlState.Normal)
        alertButton.setImage(UIImage(named: "element20.png"), forState: UIControlState.Highlighted)
        alertButton.addTarget(self, action: Selector("hide"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let buttonText = UILabel()
        buttonText.text = "Start game"
        buttonText.font = UIFont(name: "Open Sans", size: 14.0)
        buttonText.textColor = UIColor.whiteColor()
        buttonText.sizeToFit()
        buttonText.frame = CGRectMake((alertButton.frame.size.width - buttonText.frame.size.width) / 2, (alertButton.frame.size.height - buttonText.frame.size.height) / 2, buttonText.frame.size.width, buttonText.frame.size.height)
        
        alertButton.addSubview(buttonText)
        
        alertView.addSubview(alertBackground)
        alertView.addSubview(alertIcon)
        alertView.addSubview(alertText)
        alertView.addSubview(alertButton)
        
        self.addSubview(opacityView)
        self.addSubview(alertView)
    }
    
    func show() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.opacityView.alpha = 0.5
            self.alertView.alpha = 1.0
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0.0
        }) { (Bool) -> Void in
            self.removeFromSuperview()
        }
    }
}
