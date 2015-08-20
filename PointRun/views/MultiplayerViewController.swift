//
//  MultiplayerViewController.swift
//  PointRun
//
//  Created by Jack Cook on 9/25/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import GameKit
import GCHelper
import GoogleMaps
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
        if !madeMatch {
            GCHelper.sharedInstance.findMatchWithMinPlayers(2, maxPlayers: 4, viewController: self, delegate: self)
            madeMatch = true
        }
    }
    
    override func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        
        if started {
            self.sendPlayerData()
        }
        
        if points >= 100 {
            self.endGame(.MultiplayerWin)
            
            defaults.setDouble(defaults.doubleForKey(PRAchievement.k100.rawValue) + 1, forKey: PRAchievement.k100.rawValue)
            checkAchievement(PRAchievement.k100)
            
            defaults.setDouble(defaults.doubleForKey(gameWinsStatistic) + 1, forKey: gameWinsStatistic)
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
        do {
            try GCHelper.sharedInstance.match.sendDataToAllPlayers(data, withDataMode: .Reliable)
        } catch {
            print("Error sending init packet")
        }
    }
    
    func sendPlayerData() {
        let playerData = Message(playerDataWithPoints: points, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(playerData))
    }
    
    func sendPointLocation(latitude lat: Double, longitude lon: Double, points: Int, uuid: String) {
        let pointLocation = Message(pointLocationWithLatitude: lat, longitude: lon, points: points, uuid: uuid)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(pointLocation))
    }
    
    func sendPointCaptured(uuid: String) {
        let pointCaptured = Message(pointCapturedWithUUID: uuid)
        self.sendData(NSKeyedArchiver.archivedDataWithRootObject(pointCaptured))
    }
    
    
    // MARK: GCHelperDelegate
    
    func matchStarted() {
        started = true
        
        self.sendPlayerData()
        manager.startUpdatingLocation()
        
        mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 17.5)
        
        let alertView = AlertView()
        self.view.addSubview(alertView)
        alertView.show()
        
        for _ in 0...19 {
            let lat = location.coordinate.latitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
            let lon = location.coordinate.longitude + CLLocationDegrees(Double(arc4random_uniform(20)) / 10000.0 - 0.001)
            let points = Int(arc4random_uniform(10) + 1)
            let uuid = NSUUID().UUIDString
            
            addPoint(mapView, latitude: lat, longitude: lon, value: points, uuid: uuid)
            sendPointLocation(latitude: lat, longitude: lon, points: points, uuid: uuid)
        }
    }
    
    func matchEnded() {
        self.endGame(.Disconnect)
    }
    
    func match(match: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        let message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Message
        switch message.type! {
        case PRMessageType.PlayerData:
            if playerIDs.contains(playerID) {
                for player in players {
                    if player.pid == playerID {
                        player.points = message.points
                        if player.points >= 100 {
                            self.endGame(.MultiplayerLoss)
                        }
                        
                        let coords = CLLocationCoordinate2DMake(message.latitude, message.longitude)
                        player.mapPoint.position = coords
                        player.mapPoint.snippet = "\(player.name) - \(player.points)"
                    }
                }
            } else {
                playerIDs.append(playerID)
                let player = Player()
                player.pid = playerID
                player.name = "Friend"
                GKPlayer.loadPlayersForIdentifiers([playerID], withCompletionHandler: { (players, error) -> Void in
                    guard let players = players else {
                        return
                    }
                    
                    let playerObj = players.last!
                    player.name = playerObj.displayName
                    print("Opponent name: \(playerObj.displayName)")
                    
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
            if !deleted.contains(message.uuid) {
                removePoint(message.uuid, thisdevice: false)
                deleted.append(message.uuid)
            }
        }
    }
}
