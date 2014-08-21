//
//  GameViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/16/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit
import AudioToolbox

class GameViewController: UIViewController, RMMapViewDelegate {

    var gameMode: PRGameMode = PRGameMode.Timed
    var menuView: MenuView!
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var timerImage: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    var mapView: RMMapView!
    
    var points = 0
    
    var min = 5
    var sec = 0
    var time = 0
    var timer: NSTimer!
    
    var manager = CLLocationManager()
    var firstLocUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController.setNavigationBarHidden(true, animated: true)
        
        var nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: Selector("backButton"), name: backNotification, object: nil)
        nc.addObserver(self, selector: Selector("mapChanged"), name: mapChangedNotification, object: nil)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decreaseTime"), userInfo: nil, repeats: true)
        
        if (CLLocationManager.locationServicesEnabled()) {
            var tileSource = RMMapboxSource(mapID: "jackcook.j8kcb1lh")
            mapView = RMMapView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), andTilesource: tileSource)
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(RMUserTrackingModeFollow, animated: true)
            mapView.adjustTilesForRetinaDisplay = true
            mapView.hideAttribution = true
            self.view.addSubview(mapView)
        } else {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if (gameMode != PRGameMode.Timed) {
            timerImage.removeFromSuperview()
            timerLabel.removeFromSuperview()
        }
        
        // is this legal?
        /*for subview: UIView in mapView.subviews as [UIView] {
            if (subview is UIButton) {
                subview.removeFromSuperview()
            }
        }*/
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
                    //endGame()
                    timer.invalidate()
                }
            }
        }
    }
    
    func backButton() {
        self.navigationController.popViewControllerAnimated(true)
    }
    
    func mapChanged() {
        /*var mapType = defaults.integerForKey("mapType")
        switch (mapType) {
        case 0:
        mapView.
        }*/
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func singleTapOnMap(map: RMMapView!, at point: CGPoint) {
        var alertView = AlertView()
        self.view.addSubview(alertView)
        alertView.show()
    }
    
    func mapView(mapView: RMMapView!, layerForAnnotation annotation: RMAnnotation!) -> RMMapLayer! {
        if (annotation.isUserLocationAnnotation) {
            var marker = RMMarker(UIImage: UIImage(named: "userLocation.png"))
            return marker
        } else if (annotation.userInfo as NSString == "points") {
            var marker = RMMarker(UIImage: UIImage(named: "gamePoint.png"))
            return marker
        } else {
            return nil
        }
    }
    
    func mapView(mapView: RMMapView!, didUpdateUserLocation userLocation: RMUserLocation!) {
        if (firstLocUpdate) {
            firstLocUpdate = false
            
            for (var i = 0; i < 40; i++) {
                var lat = userLocation.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                var lon = userLocation.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                var points = arc4random_uniform(10) + 1
                
                var coords = CLLocationCoordinate2DMake(lat, lon)
                var point = RMAnnotation(mapView: mapView, coordinate: coords, andTitle: NSString(format: "%d Point%@", points, (points == 1 ? "" : "s")))
                point.userInfo = "points"
                
                mapView.addAnnotation(point)
                NSLog("Created %d points at %f, %f", points, lat, lon)
            }
        } else {
            var i = 0
            for point: RMAnnotation in mapView.annotations as [RMAnnotation] {
                if (i >= mapView.annotations.count) {break}
                var pointCoords = point.coordinate
                var pointLoc = CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)
                var userLoc = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                if (userLoc.distanceFromLocation(pointLoc) <= 5 && !point.isUserLocationAnnotation) {
                    if (gameMode == PRGameMode.Chance) {
                        if (arc4random_uniform(10) == 0) {
                            //[self endGame:0];
                            return
                        } else {
                            //[[Achievement sharedInstance] checkEvader:self.points];
                        }
                    }
                    
                    var pointsInAnnotation: Int? = point.title.stringByReplacingOccurrencesOfString(" Point", withString: "", options: nil, range: nil).stringByReplacingOccurrencesOfString("s", withString: "", options: nil, range: nil).toInt()
                    self.points += pointsInAnnotation!
                    pointLabel.text = NSString(format: "%d %@", self.points, (self.points == 1 ? "Point" : "Points"))
                    removePoint(i)
                    
                    var lat = userLocation.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    var lon = userLocation.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    var points = arc4random_uniform(10) + 1
                    
                    var coords = CLLocationCoordinate2DMake(lat, lon)
                    var point = RMAnnotation(mapView: mapView, coordinate: coords, andTitle: NSString(format: "%d Point%@", points, (points == 1 ? "" : "s")))
                    point.userInfo = "points"
                    
                    mapView.addAnnotation(point)
                    NSLog("Created %d points at %f, %f", points, lat, lon)
                }
                i += 1
            }
        }
    }
    
    func removePoint(position: Int) {
        var annotation = mapView.annotations[position] as RMAnnotation
        mapView.removeAnnotation(annotation)
        Functions.vibrate()
    }
}
