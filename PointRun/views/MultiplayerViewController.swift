//
//  MultiplayerViewController.swift
//  PointRun
//
//  Created by Jack Cook on 9/25/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import GameKit
import UIKit

class MultiplayerViewController: GameViewController, GCHelperDelegate {

    var madeMatch = false
    var started = false
    
    var deleted = [String]()
    
    override func viewDidLoad() {
        multiplayer = true
        super.viewDidLoad()
    }
    
    override func backButton() {
        super.backButton()
        started = false
    }
    
    override func viewDidLayoutSubviews() {
        if (!madeMatch) {
            GCHelper.sharedInstance.findMatchWithMinPlayers(2, maxPlayers: 4, viewController: self, delegate: self)
            madeMatch = true
        }
    }
    
    override func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        super.locationManager(manager, didUpdateLocations: locations)
        
        if (started) {
            self.sendPlayerData()
        }
        
        if (points >= 100) {
            self.endGame(PRGameEnd.MultiplayerWin)
            
            defaults.setInteger(defaults.integerForKey(k100Default) + 1, forKey: k100Default)
            checkAchievement(PRAchievement.k100)
            
            defaults.setInteger(defaults.integerForKey(gameWinsStatistic) + 1, forKey: gameWinsStatistic)
        }
    }
    
    override func removePoint(uuid: String, thisdevice: Bool) {
        super.removePoint(uuid, thisdevice: thisdevice)
        self.sendPointCaptured(uuid)
    }
    
    override func endGame(reason: PRGameEnd) {
        super.endGame(reason)
        started = false
    }
 
    // MARK: Sending data

    func sendData(data: NSData) {
        var success = GCHelper.sharedInstance.match.sendDataToAllPlayers(data, withDataMode: GKMatchSendDataMode.Reliable, error: nil)
        if (!success) {
            NSLog("Error sending init packet")
        }
    }
    
    func sendPlayerData() {
        var playerData = Message(playerDataWithPoints: points, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(playerData))
    }
    
    func sendPointLocation(latitude lat: Double, longitude lon: Double, points: Int, uuid: String) {
        var pointLocation = Message(pointLocationWithLatitude: lat, longitude: lon, points: points, uuid: uuid)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(pointLocation))
    }
    
    func sendPointCaptured(uuid: String) {
        var pointCaptured = Message(pointCapturedWithUUID: uuid)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(pointCaptured))
    }
    
    
    // MARK: GCHelperDelegate
    
    func matchStarted() {
        started = true
        NSLog("Match started")
        self.sendPlayerData()
        manager.startUpdatingLocation()
        
        mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 17.5)
        
        var alertView = AlertView()
        self.view.addSubview(alertView)
        alertView.show()
        
        for (var i = 0; i < 20; i++) {
            var lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
            var lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
            var points = Int(arc4random_uniform(10) + 1)
            var uuid = NSUUID().UUIDString
            
            addPoint(mapView, latitude: lat, longitude: lon, value: points, uuid: uuid)
            sendPointLocation(latitude: lat, longitude: lon, points: points, uuid: uuid)
        }
    }
    
    func matchEnded() {
        self.endGame(PRGameEnd.Disconnect)
    }
    
    func match(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        var message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as Message
        switch (message.type!) {
        case PRMessageType.PlayerData:
            if (contains(playerIDs, playerID)) {
                for player in players {
                    if (player.pid == playerID) {
                        player.points = message.points
                        if (player.points >= 100) {
                            self.endGame(PRGameEnd.MultiplayerLoss)
                        }
                        
                        var coords = CLLocationCoordinate2DMake(message.latitude, message.longitude)
                        player.mapPoint.position = coords
                        player.mapPoint.snippet = "\(player.name) - \(player.points)"
                    }
                }
            } else {
                playerIDs.append(playerID)
                var player = Player()
                player.pid = playerID
                player.name = "Friend"
                GKPlayer.loadPlayersForIdentifiers([playerID], withCompletionHandler: { (players, error) -> Void in
                    var playerObj = players.last as GKPlayer
                    player.name = playerObj.displayName
                    NSLog("Opponent name: \(playerObj.displayName)")
                    
                    player.mapPoint = GMSMarker(position: CLLocationCoordinate2DMake(message.latitude, message.longitude))
                    player.mapPoint.appearAnimation = kGMSMarkerAnimationPop
                    player.mapPoint.icon = UIImage(named: "gamePlayer.png")
                    player.mapPoint.snippet = "\(player.name) - \(player.points)"
                    player.mapPoint.map = self.mapView
                })
                players.append(player)
            }
        case PRMessageType.PointLocation:
            addPoint(mapView, latitude: message.latitude, longitude: message.longitude, value: message.points, uuid: message.uuid)
        case PRMessageType.PointCaptured:
            if (!contains(deleted, message.uuid)) {
                removePoint(message.uuid, thisdevice: false)
                deleted.append(message.uuid)
            }
        default:
            NSLog(wat)
        }
    }
}
