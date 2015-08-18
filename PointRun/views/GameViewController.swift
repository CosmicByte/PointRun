//
//  GameViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/16/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import AudioToolbox
import GCHelper
import GoogleMaps
import UIKit

class GameViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var timerImage: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    
    var multiplayer = false
    var gameMode = PRGameMode.Timed
    var menuView: MenuView!
    
    var lastLocation: CLLocation!
    
    var mapView: GMSMapView!
    var markers = [GMSMarker]()
    
    var points = 0
    
    var min = 5
    var sec = 0
    var timer: NSTimer!
    
    var manager = CLLocationManager()
    var location = CLLocation()
    var firstLocUpdate = true
    
    var players = [Player]()
    var playerIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.addObserver(self, selector: Selector("backButton"), name: backNotification, object: nil)
        nc.addObserver(self, selector: Selector("mapChanged"), name: mapChangedNotification, object: nil)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decreaseTime"), userInfo: nil, repeats: true)
        
        if CLLocationManager.locationServicesEnabled() {
            mapView = GMSMapView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 84))
            mapView.delegate = self
            mapView.myLocationEnabled = true
            self.view.addSubview(mapView)
            mapChanged()
        } else {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        if !multiplayer {
            let alertView = AlertView()
            self.view.addSubview(alertView)
            alertView.show()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if gameMode != .Timed && !multiplayer {
            timerImage.removeFromSuperview()
            timerLabel.removeFromSuperview()
        }
    }
    
    func decreaseTime() {
        defaults.setDouble(defaults.doubleForKey(PRAchievement.Addicted.rawValue) + 1, forKey: PRAchievement.Addicted.rawValue)
        defaults.setDouble(defaults.doubleForKey(timePlayedStatistic) + 1, forKey: timePlayedStatistic)
        
        if gameMode == .Timed {
            let ssec = NSString(format: "%@%d", (sec > 9 ? "" : "0"), sec)
            timerLabel.text = NSString(format: "%d:%@", min, ssec) as String
            if sec > 0 {
                sec -= 1
            } else {
                if min > 0 {
                    sec = 59
                    min -= 1
                } else {
                    self.endGame(.TimerDone)
                    timer.invalidate()
                }
            }
        }
    }
    
    func backButton() {
        self.endGame(.MenuExit)
    }
    
    func mapChanged() {
        var mapType = defaults.doubleForKey("mapType")
        switch mapType {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        case 3:
            mapView.mapType = kGMSTypeTerrain
        default:
            break
        }
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        menuView = MenuView()
        menuView.viewController = self
        menuView.showSettings()
        self.view.addSubview(menuView)
        menuView.show()
    }
    
    func sendGameMode(gameMode gameType: PRGameMode) {
        gameMode = gameType
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as! CLLocation
        
        if lastLocation != nil {
            let distance = location.distanceFromLocation(lastLocation)
            defaults.setDouble(distance + defaults.doubleForKey(PRAchievement.MarathonMan.rawValue), forKey: PRAchievement.MarathonMan.rawValue)
            checkAchievement(.MarathonMan)
            defaults.setDouble(defaults.doubleForKey(metersTravelledStatistic) + distance, forKey: metersTravelledStatistic)
        }
        
        lastLocation = location
        
        if firstLocUpdate && !multiplayer {
            firstLocUpdate = false
            
            mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 17.5)
            
            for i in 0...39 {
                let lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                let lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                let value = Int(arc4random_uniform(10) + 1)
                let uuid = NSUUID().UUIDString
                
                addPoint(mapView, latitude: lat, longitude: lon, value: value, uuid: uuid)
            }
        } else {
            for point in markers {
                let pointCoords = point.position
                let pointLoc = CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)
                let userLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if userLoc.distanceFromLocation(pointLoc) <= 7 {
                    if gameMode == .Chance {
                        if arc4random_uniform(10) == 0 {
                            self.endGame(.PoisonPin)
                            
                            defaults.setDouble(defaults.doubleForKey(PRAchievement.BadLuck.rawValue) + 1, forKey: PRAchievement.BadLuck.rawValue)
                            checkAchievement(PRAchievement.BadLuck)
                            
                            defaults.setDouble(defaults.doubleForKey(poisonPinsStatistic) + 1, forKey: poisonPinsStatistic)
                            
                            return
                        } else {
                            defaults.setDouble(Double(points), forKey: PRAchievement.Evader.rawValue)
                            checkAchievement(PRAchievement.Evader)
                        }
                    }
                    
                    let pointsInAnnotation = (point.snippet.componentsSeparatedByString(" ")[0] as String).toInt()
                    self.points += pointsInAnnotation!
                    pointLabel.text = NSString(format: "%d %@", self.points, (self.points == 1 ? "Point" : "Points")) as String
                    removePoint(point.userData as! String, thisdevice: true)
                    
                    let lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    let lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    let value = Double(arc4random_uniform(10) + 1)
                    let uuid = NSUUID().UUIDString
                    
                    addPoint(mapView, latitude: lat, longitude: lon, value: Int(value), uuid: uuid)
                    
                    if value == 10 {
                        defaults.setDouble(defaults.doubleForKey(PRAchievement.HatTrick.rawValue) + 1, forKey: PRAchievement.HatTrick.rawValue)
                        checkAchievement(PRAchievement.HatTrick)
                    } else {
                        defaults.setDouble(0, forKey: PRAchievement.HatTrick.rawValue)
                    }
                    
                    defaults.setDouble(defaults.doubleForKey(pinsCollectedStatistic) + 1, forKey: pinsCollectedStatistic)
                    defaults.setDouble(defaults.doubleForKey(pointsEarnedStatistic) + value, forKey: pointsEarnedStatistic)
                }
            }
        }
    }
    
    func addPoint(map: GMSMapView, latitude lat: Double, longitude lon: Double, value: Int, uuid: String) {
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let point = GMSMarker(position: coordinates)
        point.appearAnimation = kGMSMarkerAnimationPop
        let s = value == 1 ? "" : "s"
        point.snippet = "\(value) Point\(s)"
        point.map = map
        point.userData = uuid
        
        let colors = [UIColor(red: 0.88, green: 0.22, blue: 0.18, alpha: 1.00), UIColor(red: 0.88, green: 0.22, blue: 0.18, alpha: 1.00), UIColor(red: 0.88, green: 0.22, blue: 0.18, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.92, green: 0.60, blue: 0.10, alpha: 1.00), UIColor(red: 0.19, green: 0.78, blue: 0.41, alpha: 1.00), UIColor(red: 0.19, green: 0.78, blue: 0.41, alpha: 1.00), UIColor(red: 0.19, green: 0.78, blue: 0.41, alpha: 1.00)]
        point.icon = GMSMarker.markerImageWithColor(colors[value - 1])
        
        markers.append(point)
        
        println("Created \(value) points at \(lat), \(lon) with a UUID of \(uuid)")
    }
    
    func removePoint(uuid: String, thisdevice: Bool) {
        var i = 0
        for point in markers {
            if point.userData as! String == uuid {
                point.map = nil
                markers.removeAtIndex(i)
                
                if thisdevice {
                    vibrate()
                }
            }
            i += 1
        }
    }
    
    func endGame(reason: PRGameEnd) {
        manager.stopUpdatingLocation()
        timer.invalidate()
        
        let alert = UIAlertController(title: "Game Over!", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (alertAction) -> Void in
            self.pop()
        }))
        
        switch reason {
        case .MenuExit:
            self.navigationController?.popViewControllerAnimated(true)
        case .TimerDone:
            alert.message = "You have run out of time!"
            GCHelper.sharedInstance.reportLeaderboardIdentifier("mosttimedpoints", score: self.points)
        case .PoisonPin:
            alert.message = "That pin was poisonous!"
        case .Disconnect:
            alert.message = "Another player has been disconnected."
            alert.addAction(UIAlertAction(title: "Continue", style: .Destructive, handler: { (alertAction) -> Void in
                self.manager.startUpdatingLocation()
            }))
        case .Error:
            alert.message = "An error has unexpectedly occured."
        case .MultiplayerWin:
            alert.message = "You won!"
        case .MultiplayerLoss:
            alert.message = "You lost."
        default:
            break
        }
        
        alert.message? += "\nYour Score: \(points)"
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
