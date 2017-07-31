//
//  MenuView.swift
//  PointRun
//
//  Created by Jack Cook on 8/4/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit

class MenuView: UIView {

    var opacityView: UIView!
    var statusbarView: UIView!
    var menuView: UIView!
    
    var statisticsButton: Button!
    var indicator: UIImageView!
    var checkImage: UIImageView!
    
    var device = UIScreen.main.bounds.size
    var statisticsShown = false
    
    var viewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: device.width, height: device.height))
        
        opacityView = UIView(frame: CGRect(x: 0, y: 0, width: device.width, height: device.height))
        opacityView.backgroundColor = UIColor.black
        opacityView.alpha = 0.0
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(MenuView.hide))
        opacityView.addGestureRecognizer(tgr)
        
        
        statusbarView = UIView(frame: CGRect(x: -device.width, y: 0, width: device.width, height: 20))
        statusbarView.backgroundColor = UIColor(red: 0.09, green: 0.6, blue: 0.47, alpha: 1.00)
        
        
        menuView = UIView(frame: CGRect(x: -menuWidth, y: 20, width: menuWidth, height: device.height))
        menuView.backgroundColor = UIColor.white
        
        statisticsButton = Button()
        statisticsButton.addTarget(self, action: #selector(updateIndicator), for: .allTouchEvents)
        statisticsButton.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
        statisticsButton.cornerRadius = 0
        statisticsButton.frame = CGRect(x: 0, y: 0, width: 87, height: 62)
        
        let statisticsImage = UIImageView(frame: CGRect(x: 30, y: 21, width: 27, height: 22))
        statisticsImage.image = #imageLiteral(resourceName: "Statistics")
        
        let achievementsButton = Button()
        achievementsButton.addTarget(self, action: #selector(showAchievements), for: .touchUpInside)
        achievementsButton.cornerRadius = 0
        achievementsButton.frame = CGRect(x: 87, y: 0, width: 86, height: 62)
        
        achievementsButton.normalBackgroundColor = UIColor.greenHighlightedButton
        achievementsButton.normalShadowColor = UIColor.greenHighlightedButtonShadow
        achievementsButton.highlightedBackgroundColor = UIColor.greenButton
        achievementsButton.highlightedShadowColor = UIColor.greenButtonShadow
        
        let achievementsImage = UIImageView(frame: CGRect(x: 35.5, y: 21, width: 15, height: 22))
        achievementsImage.image = #imageLiteral(resourceName: "Medal")
        
        let leaderboardButton = Button()
        leaderboardButton.addTarget(self, action: #selector(MenuView.showLeaderboards), for: .touchUpInside)
        leaderboardButton.cornerRadius = 0
        leaderboardButton.frame = CGRect(x: 173, y: 0, width: 87, height: 62)
        
        let leaderboardImage = UIImageView(frame: CGRect(x: 28.5, y: 21, width: 30, height: 22))
        leaderboardImage.image = #imageLiteral(resourceName: "List")
        
        indicator = UIImageView(frame: CGRect(x: 33, y: 62, width: 21, height: 8))
        indicator.image = #imageLiteral(resourceName: "Element03")
        
        statisticsButton.addSubview(statisticsImage)
        achievementsButton.addSubview(achievementsImage)
        leaderboardButton.addSubview(leaderboardImage)
        
        menuView.addSubview(statisticsButton)
        menuView.addSubview(achievementsButton)
        menuView.addSubview(leaderboardButton)
        
        self.addSubview(opacityView)
        self.addSubview(statusbarView)
        self.addSubview(menuView)
    }
    
    func show() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.opacityView.alpha = 0.5
            self.statusbarView.frame = CGRect(x: 0, y: 0, width: self.device.width, height: 20)
            self.menuView.frame = CGRect(x: 0, y: 20, width: menuWidth, height: self.menuView.frame.height - 20)
        }) 
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.opacityView.alpha = 0.0
            self.statusbarView.frame = CGRect(x: -self.device.width, y: 0, width: self.device.width, height: 20)
            self.menuView.frame = CGRect(x: -menuWidth, y: 20, width: menuWidth, height: self.menuView.frame.height - 20)
        }, completion: { (Bool) -> Void in
            self.removeFromSuperview()
        }) 
    }
    
    func showSettings() {
        let backHeight: CGFloat = 64
        let backImage = UIImageView(frame: CGRect(x: 0, y: 64, width: menuWidth, height: backHeight))
        backImage.image = #imageLiteral(resourceName: "Element13")
        
        let backButton = Button()
        backButton.addTarget(self, action: #selector(MenuView.backButton), for: .touchUpInside)
        backButton.setTitle("Return to mode select", for: .normal)
        
        backButton.frame = CGRect(x: 10, y: 74, width: menuWidth - 20, height: backHeight - 20)
        
        let iconHeight: CGFloat = 18
        let backIcon = UIImageView(frame: CGRect(x: 16, y: (backButton.frame.size.height - iconHeight) / 2, width: 21, height: iconHeight))
        backIcon.image = #imageLiteral(resourceName: "Back")
        
        backButton.addSubview(backIcon)
        
        let optionImage = UIImageView(frame: CGRect(x: 0, y: 128, width: menuWidth, height: 64))
        optionImage.image = #imageLiteral(resourceName: "Element13")
        
        let optionLabel = UILabel()
        optionLabel.text = "Map display"
        optionLabel.font = .systemFont(ofSize: 14)
        optionLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00)
        optionLabel.sizeToFit()
        optionLabel.frame = CGRect(x: 12, y: 142, width: 128, height: optionLabel.frame.size.height)
        
        let streetsButton = Button()
        streetsButton.addTarget(self, action: #selector(MenuView.streetsButton), for: .touchUpInside)
        streetsButton.frame = CGRect(x: 10, y: 174, width: menuWidth - 20, height: 40)
        
        streetsButton.normalBackgroundColor = UIColor.grayButton
        streetsButton.normalShadowColor = UIColor.grayButtonShadow
        streetsButton.highlightedBackgroundColor = UIColor.grayButtonShadow
        streetsButton.highlightedShadowColor = UIColor.grayButtonShadow
        
        let streetsLabel = UILabel()
        streetsLabel.text = "Streets"
        streetsLabel.font = .systemFont(ofSize: 14)
        streetsLabel.textColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1.00)
        streetsLabel.sizeToFit()
        streetsLabel.frame = CGRect(x: 56, y: (streetsButton.frame.size.height - streetsLabel.frame.size.height) / 2, width: streetsLabel.frame.size.width, height: streetsLabel.frame.size.height)
        
        streetsButton.addSubview(streetsLabel)
        
        let satelliteButton = Button()
        satelliteButton.addTarget(self, action: #selector(MenuView.satelliteButton), for: .touchUpInside)
        satelliteButton.frame = CGRect(x: 10, y: 228, width: menuWidth - 20, height: 40)
        
        satelliteButton.normalBackgroundColor = UIColor.grayButton
        satelliteButton.normalShadowColor = UIColor.grayButtonShadow
        satelliteButton.highlightedBackgroundColor = UIColor.grayButtonShadow
        satelliteButton.highlightedShadowColor = UIColor.grayButtonShadow
        
        let satelliteLabel = UILabel()
        satelliteLabel.text = "Satellite"
        satelliteLabel.font = .systemFont(ofSize: 14)
        satelliteLabel.textColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1.00)
        satelliteLabel.sizeToFit()
        satelliteLabel.frame = CGRect(x: 56, y: (satelliteButton.frame.size.height - satelliteLabel.frame.size.height) / 2, width: satelliteLabel.frame.size.width, height: satelliteLabel.frame.size.height)
        
        satelliteButton.addSubview(satelliteLabel)
        
        let hybridButton = Button()
        hybridButton.addTarget(self, action: #selector(MenuView.hybridButton), for: .touchUpInside)
        hybridButton.frame = CGRect(x: 10, y: 282, width: menuWidth - 20, height: 40)
        
        hybridButton.normalBackgroundColor = UIColor.grayButton
        hybridButton.normalShadowColor = UIColor.grayButtonShadow
        hybridButton.highlightedBackgroundColor = UIColor.grayButtonShadow
        hybridButton.highlightedShadowColor = UIColor.grayButtonShadow
        
        let hybridLabel = UILabel()
        hybridLabel.text = "Hybrid"
        hybridLabel.font = .systemFont(ofSize: 14)
        hybridLabel.textColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1.00)
        hybridLabel.sizeToFit()
        hybridLabel.frame = CGRect(x: 56, y: (hybridButton.frame.size.height - hybridLabel.frame.size.height) / 2, width: hybridLabel.frame.size.width, height: hybridLabel.frame.size.height)
        
        hybridButton.addSubview(hybridLabel)
        
        let terrainButton = Button()
        terrainButton.addTarget(self, action: #selector(MenuView.terrainButton), for: .touchUpInside)
        terrainButton.frame = CGRect(x: 10, y: 336, width: menuWidth - 20, height: 40)
        
        terrainButton.normalBackgroundColor = UIColor.grayButton
        terrainButton.normalShadowColor = UIColor.grayButtonShadow
        terrainButton.highlightedBackgroundColor = UIColor.grayButtonShadow
        terrainButton.highlightedShadowColor = UIColor.grayButtonShadow
        
        let terrainLabel = UILabel()
        terrainLabel.text = "Terrain"
        terrainLabel.font = .systemFont(ofSize: 14)
        terrainLabel.textColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1.00)
        terrainLabel.sizeToFit()
        terrainLabel.frame = CGRect(x: 56, y: (terrainButton.frame.size.height - terrainLabel.frame.size.height) / 2, width: terrainLabel.frame.size.width, height: terrainLabel.frame.size.height)
        
        terrainButton.addSubview(terrainLabel)
        
        let checkY = CGFloat(174 + (54 * defaults.double(forKey: "mapType")))
        checkImage = UIImageView()
        checkImage.image = #imageLiteral(resourceName: "Element24")
        checkImage.frame = CGRect(x: 10, y: checkY, width: 42, height: 42)
        
        let checkIcon = UIImageView(frame: CGRect(x: (checkImage.frame.size.width - 19) / 2, y: (checkImage.frame.size.height - 16) / 2, width: 19, height: 16))
        checkIcon.image = #imageLiteral(resourceName: "Checkmark")
        
        checkImage.addSubview(checkIcon)
        
        menuView.addSubview(backImage)
        menuView.addSubview(backButton)
        menuView.addSubview(optionImage)
        menuView.addSubview(optionLabel)
        menuView.addSubview(streetsButton)
        menuView.addSubview(satelliteButton)
        menuView.addSubview(hybridButton)
        menuView.addSubview(terrainButton)
        menuView.addSubview(checkImage)
    }
    
    func backButton() {
        nc.post(name: backNotification, object: nil)
    }
    
    func streetsButton() {
        defaults.set(0, forKey: "mapType")
        let checkY = CGFloat(174 + (54 * defaults.double(forKey: "mapType")))
        checkImage.frame = CGRect(x: 10, y: checkY, width: 42, height: 42)
        nc.post(name: mapChangedNotification, object: nil)
    }
    
    func satelliteButton() {
        defaults.set(1, forKey: "mapType")
        let checkY = CGFloat(174 + (54 * defaults.double(forKey: "mapType")))
        checkImage.frame = CGRect(x: 10, y: checkY, width: 42, height: 42)
        nc.post(name: mapChangedNotification, object: nil)
    }
    
    func hybridButton() {
        defaults.set(2, forKey: "mapType")
        let checkY = CGFloat(174 + (54 * defaults.double(forKey: "mapType")))
        checkImage.frame = CGRect(x: 10, y: checkY, width: 42, height: 42)
        nc.post(name: mapChangedNotification, object: nil)
    }
    
    func terrainButton() {
        defaults.set(3, forKey: "mapType")
        let checkY = CGFloat(174 + (54 * defaults.double(forKey: "mapType")))
        checkImage.frame = CGRect(x: 10, y: checkY, width: 42, height: 42)
        nc.post(name: mapChangedNotification, object: nil)
    }
    
    func updateIndicator() {
        indicator.image = statisticsButton.isHighlighted ? #imageLiteral(resourceName: "Element21") : #imageLiteral(resourceName: "Element03")
    }
    
    func showStatistics() {
        menuView.addSubview(indicator)
        indicator.image = #imageLiteral(resourceName: "Element03")
        
        if statisticsShown {return}
        statisticsShown = true
        
        let height = 46
        for i in 0...6 {
            let statisticCell = UIImageView(frame: CGRect(x: 0, y: CGFloat(64 + (i * height)), width: menuWidth, height: CGFloat(height)))
            statisticCell.image = #imageLiteral(resourceName: "Element13")
            menuView.insertSubview(statisticCell, belowSubview: indicator)
            
            let name = UILabel()
            let score = UILabel()
            
            switch i {
            case 0:
                let heading = UILabel()
                heading.text = "Statistics"
                heading.font = .systemFont(ofSize: 18)
                heading.textColor = UIColor(red: 0.1, green: 0.71, blue: 0.56, alpha: 1.00)
                heading.sizeToFit()
                heading.frame = CGRect(x: 16, y: (statisticCell.frame.size.height - heading.frame.size.height) / 2, width: heading.frame.size.width, height: heading.frame.size.height)
                statisticCell.addSubview(heading)
            case 1:
                name.text = "Game wins"
                score.text = defaults.double(forKey: gameWinsStatistic).toString()
            case 2:
                let time = defaults.double(forKey: timePlayedStatistic)
                if time < 60 {
                    name.text = "Seconds played"
                    score.text = time.toString()
                } else if time >= 60 && time < 3600 {
                    name.text = "Minutes played"
                    score.text = (time / 60).toString()
                } else if time >= 3600 {
                    name.text = "Hours played"
                    score.text = (time / 3600).toString()
                }
            case 3:
                name.text = "Meters travelled"
                score.text = defaults.double(forKey: metersTravelledStatistic).toString()
            case 4:
                name.text = "Pins collected"
                score.text = defaults.double(forKey: pinsCollectedStatistic).toString()
            case 5:
                name.text = "Points earned"
                score.text = defaults.double(forKey: pointsEarnedStatistic).toString()
            case 6:
                name.text = "Poison pins"
                score.text = defaults.double(forKey: poisonPinsStatistic).toString()
            default:
                break
            }
            
            if i != 0 {
                name.font = .systemFont(ofSize: 14)
                name.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1.00)
                name.sizeToFit()
                name.frame = CGRect(x: 16, y: (statisticCell.frame.size.height - name.frame.size.height) / 2, width: name.frame.size.width, height: name.frame.size.height)
                statisticCell.addSubview(name)
                
                score.font = .systemFont(ofSize: 15)
                score.textColor = UIColor(red: 0.1, green: 0.7, blue: 0.57, alpha: 1.00)
                score.textAlignment = NSTextAlignment.right
                score.sizeToFit()
                score.frame = CGRect(x: menuWidth / 2, y: (statisticCell.frame.size.height - score.frame.size.height) / 2, width: (menuWidth / 2) - 16, height: score.frame.size.height)
                statisticCell.addSubview(score)
            }
        }
        
        let resetHeight: CGFloat = 64
        let resetImage = UIImageView(frame: CGRect(x: 0, y: device.height - 20 - resetHeight, width: menuWidth, height: resetHeight))
        resetImage.image = #imageLiteral(resourceName: "Element13")
        
        let resetButton = Button()
        resetButton.addTarget(self, action: #selector(resetStatistics), for: .touchUpInside)
        resetButton.setTitle("Reset all stats", for: .normal)
        
        resetButton.frame = CGRect(x: 10, y: device.height - 20 - resetHeight + 10, width: menuWidth - 20, height: resetHeight - 20)
        
        menuView.addSubview(resetImage)
        menuView.addSubview(resetButton)
    }
    
    func showAchievements() {
        nc.post(name: achievementNotification, object: nil)
    }
    
    func showLeaderboards() {
        nc.post(name: leaderboardNotification, object: nil)
    }
    
    func resetStatistics() {
        let alert = UIAlertController(title: "Reset", message: "Are you sure you want to reset your statistics?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alertAction) -> Void in
            defaults.set(0, forKey: gameWinsStatistic)
            defaults.set(0, forKey: timePlayedStatistic)
            defaults.set(0, forKey: metersTravelledStatistic)
            defaults.set(0, forKey: pinsCollectedStatistic)
            defaults.set(0, forKey: pointsEarnedStatistic)
            defaults.set(0, forKey: poisonPinsStatistic)
            
            for view in self.menuView.subviews {
                if view is UIImageView {
                    for label in view.subviews {
                        if label is UILabel {
                            // It works, so...
                            if label.frame.origin.x > 100 {
                                (label as! UILabel).text = "0"
                            }
                        }
                    }
                }
            }
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
