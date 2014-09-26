//
//  BannerView.swift
//  PointRun
//
//  Created by Jack Cook on 9/26/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit

class BannerView: UIView {

    init(playername: String, points: Int) {
        super.init(frame: CGRectMake(0, 568, 320, 32))
        
        self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        
        var textView = UILabel(frame: CGRectMake(16, -3, frame.size.width - 32, frame.size.height - 8))
        var ve = playername == "You" ? "ve" : "s"
        var s = points == 1 ? "" : "s"
        textView.text = "\(playername) ha\(ve) picked up \(points) point\(s)".stringByReplacingOccurrencesOfString("“", withString: "")
        textView.font = UIFont(name: "Open Sans", size: 13.0)
        textView.textAlignment = NSTextAlignment.Center
        
        self.addSubview(textView)
        
        animate()
    }
    
    func animate() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.frame = CGRectMake(0, 548, 320, 32)
        }) { (completed) -> Void in
            var timer = NSTimer(timeInterval: 1.5, target: self, selector: Selector("animateBack"), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func animateBack() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.frame = CGRectMake(0, 568, 320, 32)
        }) { (completed) -> Void in
            self.removeFromSuperview()
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
