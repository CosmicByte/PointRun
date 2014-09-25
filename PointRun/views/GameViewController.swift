//
//  GameViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/16/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit
import AudioToolbox

class GameViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GCHelperDelegate {

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
        
        //GCHelper.sharedInstance().findMatchWithMinPlayers(2, maxPlayers: 4, viewController: self, delegate: self)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        var nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: Selector("backButton"), name: backNotification, object: nil)
        nc.addObserver(self, selector: Selector("mapChanged"), name: mapChangedNotification, object: nil)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decreaseTime"), userInfo: nil, repeats: true)
        
        if (CLLocationManager.locationServicesEnabled()) {
            mapView = GMSMapView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            mapView.delegate = self
            mapView.myLocationEnabled = true
            self.view.addSubview(mapView)
            mapChanged()
        } else {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        if (gameMode != PRGameMode.Timed) {
            timerImage.removeFromSuperview()
            timerLabel.removeFromSuperview()
        }
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
    
    func sendGameMode(gameMode gameType: PRGameMode, multiplayer mplayer: Bool) {
        gameMode = gameType
        multiplayer = mplayer
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
                
                addPoint(mapView, latitude: lat, longitude: lon, value: points)
            }
        } else {
            for point in markers {
                var pointCoords = point.position
                var pointLoc = CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)
                var userLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if (userLoc.distanceFromLocation(pointLoc) <= 5) {
                    if (gameMode == PRGameMode.Chance) {
                        if (arc4random_uniform(10) == 0) {
                            //[self endGame:0];
                            return
                        } else {
                            //[[Achievement sharedInstance] checkEvader:self.points];
                        }
                    }
                    
                    var pointsInAnnotation = (point.snippet.componentsSeparatedByString(" ")[0] as String).toInt()
                    self.points += pointsInAnnotation!
                    pointLabel.text = NSString(format: "%d %@", self.points, (self.points == 1 ? "Point" : "Points"))
                    removePoint(pointCoords.latitude, longitude: pointCoords.longitude)
                    
                    var lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    var lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
                    var points = Int(arc4random_uniform(10) + 1)
                    
                    addPoint(mapView, latitude: lat, longitude: lon, value: points)
                }
            }
        }
    }
    
    func addPoint(map: GMSMapView, latitude lat: Double, longitude lon: Double, value: Int) {
        var coordinates = CLLocationCoordinate2DMake(lat, lon)
        var point = GMSMarker(position: coordinates)
        point.appearAnimation = kGMSMarkerAnimationPop
        //point.icon = UIImage(named: "gamePoint.png")
        var s = value == 1 ? "" : "s"
        point.snippet = "\(value) Point\(s)"
        point.map = map
        
        markers.append(point)
        
        NSLog("Created \(value) points at \(lat), \(lon)")
    }
    
    func removePoint(latitude: Double, longitude: Double) {
        var i = 0
        for point in markers {
            if (point.position.latitude == latitude && point.position.longitude == longitude) {
                point.map = nil
                markers.removeAtIndex(i)
                Functions.vibrate()
            }
            i += 1
        }
    }
    
    // MARK: Sending data
    
    func sendData(data: NSData) {
        var success = GCHelper.sharedInstance().match.sendDataToAllPlayers(data, withDataMode: GKMatchSendDataMode.Reliable, error: nil)
        if (!success) {
            NSLog("Error sending init packet")
        }
    }
    
    func sendLocationUpdate() {
        var playerLocation = Message(playerLocationWithLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(playerLocation))
    }
    
    func sendPointLocation(latitude lat: Double, longitude lon: Double, points: Int) {
        var pointLocation = Message(pointLocationWithLatitude: lat, longitude: lon, points: points)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(pointLocation))
    }
    
    func sendGameOver(reason: Int) {
        
    }
    
    func sendPlayerData() {
        var playerData = Message(playerDataWithWhatever: "helloworld")
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(playerData))
    }
    
    
    // MARK: GCHelperDelegate
    
    func matchStarted() {
        NSLog("Match started")
        self.sendPlayerData()
        self.sendLocationUpdate()
        manager.startUpdatingLocation()
        
        mapView.userInteractionEnabled = false
        
        var alertView = AlertView()
        self.view.addSubview(alertView)
        alertView.show()
    }
    
    func matchEnded(playerID: String!) {
        NSLog("Match ended")
    }
    
    func match(match: GKMatch!, didReceiveData data: NSData!, fromPlayer playerID: String!) {
        var message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as Message
        switch (message.type!) {
        case PRMessageType.PlayerLocation:
            for player in players {
                if (player.pid == playerID) {
                    var coords = CLLocationCoordinate2DMake(message.latitude, message.longitude)
                    player.mapPoint.position = coords
                }
            }
        case PRMessageType.PointLocation:
            addPoint(mapView, latitude: message.latitude, longitude: message.longitude, value: message.points)
        case PRMessageType.PlayerData:
            playerIDs.append(playerID)
            var player = Player()
            player.pid = playerID
            player.name = "Friend"
            GKPlayer.loadPlayersForIdentifiers([playerID]) { (players, error) -> Void in
                var playerObj = players.last as GKPlayer
                player.name = playerObj.displayName
                NSLog("Opponent name: \(playerObj.displayName)")
                
                var point = GMSMarker(position: CLLocationCoordinate2DMake(message.latitude, message.longitude))
                point.appearAnimation = kGMSMarkerAnimationPop
                point.icon = UIImage(named: "gamePlayer.png")
                point.snippet = player.name
                point.map = self.mapView
                player.mapPoint = point
            }
            player.playerNum = playerIDs.count - 1
            player.image.image = UIImage(named: "gamePlayer.png")
        default:
            NSLog("\(wat)")
        }
    }
}
