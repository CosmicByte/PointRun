//
//  GameViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/16/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit
import AudioToolbox

class GameViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    var multiplayer = false
    var gameMode: PRGameMode = PRGameMode.Timed
    var menuView: MenuView!
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var timerImage: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    
    var mapView: GMSMapView!
    var markers = [GMSMarker]()
    
    var points = 0
    
    var min = 5
    var sec = 0
    var time = 0
    var timer: NSTimer!
    
    var manager = CLLocationManager()
    var location = CLLocation()
    var firstLocUpdate = true
    
    var players = [Player]()
    var playerIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: Selector("backButton"), name: backNotification, object: nil)
        nc.addObserver(self, selector: Selector("mapChanged"), name: mapChangedNotification, object: nil)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decreaseTime"), userInfo: nil, repeats: true)
        
        if (CLLocationManager.locationServicesEnabled()) {
            mapView = GMSMapView(frame: CGRectMake(0, 84, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            mapView.delegate = self
            mapView.myLocationEnabled = true
            self.view.addSubview(mapView)
            mapChanged()
        } else {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        if (!multiplayer) {
            var alertView = AlertView()
            self.view.addSubview(alertView)
            alertView.show()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if (gameMode != PRGameMode.Timed && !multiplayer) {
            timerImage.removeFromSuperview()
            timerLabel.removeFromSuperview()
        }
    }
    
    func banner(playername: String, points: Int) {
        self.view.addSubview(BannerView(playername: playername, points: points))
    }
    
    func decreaseTime() {
        time += 1
        if (gameMode == PRGameMode.Timed) {
            var ssec = NSString(format: "%@%d", (sec > 9 ? "" : "0"), sec)
            timerLabel.text = NSString(format: "%d:%@", min, ssec)
            if (sec > 0) {
                sec -= 1
            } else {
                if (min > 0) {
                    sec = 59
                    min -= 1
                } else {
                    self.endGame(PRGameEnd.TimerDone)
                    timer.invalidate()
                }
            }
        }
    }
    
    func backButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func mapChanged() {
        var mapType = defaults.integerForKey("mapType")
        switch (mapType) {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        case 3:
            mapView.mapType = kGMSTypeTerrain
        default:
            NSLog("\(wat)")
        }
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        menuView = MenuView()
        menuView.showSettings()
        self.view.addSubview(menuView)
        menuView.show()
    }
    
    func sendGameMode(gameMode gameType: PRGameMode) {
        gameMode = gameType
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations.last as CLLocation
        
        if (firstLocUpdate && !multiplayer) {
            firstLocUpdate = false
            
            mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 17.5)
            
            for (var i = 0; i < 40; i++) {
                var lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                var lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                var points = Int(arc4random_uniform(10) + 1)
                var uuid = NSUUID.UUID().UUIDString
                
                addPoint(mapView, latitude: lat, longitude: lon, value: points, uuid: uuid)
            }
        } else {
            for point in markers {
                var pointCoords = point.position
                var pointLoc = CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)
                var userLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if (userLoc.distanceFromLocation(pointLoc) <= 30) {
                    if (gameMode == PRGameMode.Chance) {
                        if (arc4random_uniform(10) == 0) {
                            self.endGame(PRGameEnd.PoisonPin)
                            return
                        } else {
                            //[[Achievement sharedInstance] checkEvader:self.points];
                        }
                    }
                    
                    var pointsInAnnotation = (point.snippet.componentsSeparatedByString(" ")[0] as String).toInt()
                    self.points += pointsInAnnotation!
                    pointLabel.text = NSString(format: "%d %@", self.points, (self.points == 1 ? "Point" : "Points"))
                    removePoint(point.userData as String)
                    banner("You", points: pointsInAnnotation!)
                    
                    var lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    var lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    var points = Int(arc4random_uniform(10) + 1)
                    var uuid = NSUUID.UUID().UUIDString
                    
                    addPoint(mapView, latitude: lat, longitude: lon, value: points, uuid: uuid)
                }
            }
        }
    }
    
    func addPoint(map: GMSMapView, latitude lat: Double, longitude lon: Double, value: Int, uuid: String) {
        var coordinates = CLLocationCoordinate2DMake(lat, lon)
        var point = GMSMarker(position: coordinates)
        point.appearAnimation = kGMSMarkerAnimationPop
        var s = value == 1 ? "" : "s"
        point.snippet = "\(value) Point\(s)"
        point.map = map
        point.userData = uuid
        
        markers.append(point)
        
        NSLog("Created \(value) points at \(lat), \(lon) with a UUID of \(uuid)")
    }
    
    func removePoint(uuid: String) {
        var i = 0
        for point in markers {
            if (point.userData as String == uuid) {
                point.map = nil
                markers.removeAtIndex(i)
                Functions.vibrate()
            }
            i += 1
        }
    }
    
    func endGame(reason: PRGameEnd) {
        manager.stopUpdatingLocation()
        
        var alert = UIAlertController(title: "Game Over!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            self.pop()
        }))
        
        switch (reason) {
        case PRGameEnd.MenuExit:
            NSLog("0")
        case PRGameEnd.TimerDone:
            alert.message = "You have run out of time!"
        case PRGameEnd.PoisonPin:
            alert.message = "That pin was poisonous!"
        case PRGameEnd.Disconnect:
            alert.message = "Another player has been disconnected."
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Destructive, handler: { (alertAction) -> Void in
                self.manager.startUpdatingLocation()
            }))
        case PRGameEnd.Error:
            alert.message = "An error has unexpectedly occured."
        case PRGameEnd.MultiplayerWin:
            alert.message = "You won!"
        case PRGameEnd.MultiplayerLoss:
            alert.message = "You lost."
        default:
            NSLog("\(wat)")
        }
        
        alert.message! += "\nYour Score: \(points)"
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func pop() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
