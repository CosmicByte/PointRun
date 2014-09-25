//
//  MultiplayerViewController.swift
//  PointRun
//
//  Created by Jack Cook on 9/25/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit

class MultiplayerViewController: GameViewController, GCHelperDelegate {

    override func viewDidLoad() {
        multiplayer = true
        super.viewDidLoad()

        GCHelper.sharedInstance().findMatchWithMinPlayers(2, maxPlayers: 4, viewController: self, delegate: self)
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
