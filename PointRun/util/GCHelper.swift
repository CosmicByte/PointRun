//
//  GCHelper.swift
//  PointRun
//
//  Created by Jack Cook on 9/27/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import GameKit

protocol GCHelperDelegate {
    func matchStarted()
    func match(match: GKMatch, didReceiveData: NSData, fromPlayer: String)
    func matchEnded()
}

class GCHelper: NSObject, GKMatchmakerViewControllerDelegate, GKGameCenterControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    var presentingViewController: UIViewController!
    var match: GKMatch!
    var delegate: GCHelperDelegate!
    var playersDict = [:]
    var invitedPlayer: GKPlayer!
    var invite: GKInvite!
    
    var matchStarted = false
    var authenticated = false
    
    class var sharedInstance: GCHelper {
        struct Static {
            static let instance = GCHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        nc.addObserver(self, selector: Selector("authenticationChanged"), name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
    
    // MARK: Internal functions
    
    func authenticationChanged() {
        if (GKLocalPlayer.localPlayer().authenticated && authenticated) {
            println("Authentication changed: player authenticated")
            authenticated = true
        } else {
            println("Authentication changed: player not authenticated")
            authenticated = false
        }
    }
    
    func lookupPlayers() {
        var playerIDs = [String]()
        for player in match.players {
            playerIDs.append(player.playerID)
        }
        
        GKPlayer.loadPlayersForIdentifiers(playerIDs, withCompletionHandler: { (players, error) -> Void in
            if (error != nil) {
                println("Error retrieving player info: \(error.localizedDescription)")
                self.matchStarted = false
                self.delegate.matchEnded()
            } else {
                self.playersDict = NSMutableDictionary(capacity: players.count)
                for player in players {
                    println("Found player: \(player.alias)")
                    self.playersDict.setValue(player, forKey: player.playerID)
                }
                
                self.matchStarted = true
                GKMatchmaker.sharedMatchmaker().finishMatchmakingForMatch(self.match)
                self.delegate.matchStarted()
            }
        })
    }
    
    // MARK: User functions
    
    func authenticateLocalUser() {
        println("Authenticating local user...")
        if (GKLocalPlayer.localPlayer().authenticated == false) {
            GKLocalPlayer.localPlayer().authenticateHandler = { (view, error) in
                if (error == nil) {
                    self.authenticated = true
                } else {
                    println("\(error.localizedDescription)")
                }
            }
        } else {
            println("Already authenticated")
        }
    }
    
    func findMatchWithMinPlayers(minPlayers: Int, maxPlayers: Int, viewController: UIViewController, delegate theDelegate: GCHelperDelegate) {
        matchStarted = false
        match = nil
        presentingViewController = viewController
        delegate = theDelegate
        presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        
        var request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        
        var mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc.matchmakerDelegate = self
        
        presentingViewController.presentViewController(mmvc, animated: true, completion: nil)
    }
    
    func reportAchievementIdentifier(identifier: String, percent: Double) {
        var achievement: GKAchievement? = GKAchievement(identifier: identifier)
        if let a = achievement {
            achievement!.percentComplete = percent
            achievement!.showsCompletionBanner = true
            GKAchievement.reportAchievements([achievement!], withCompletionHandler: { (error) -> Void in
                if (error != nil) {
                    println("Error in reporting achievements: \(error)")
                }
            })
        }
    }
    
    func reportLeaderboardIdentifier(identifier: String, score: Int) {
        var scoreObject = GKScore(leaderboardIdentifier: identifier)
        scoreObject.value = Int64(score)
        println("\(scoreObject.value)")
        GKScore.reportScores([scoreObject], withCompletionHandler: { (error) -> Void in
            if (error != nil) {
                println("Error in reporting leaderboard scores: \(error)")
            }
        })
    }
    
    func showGameCenter(viewController: UIViewController, viewState: GKGameCenterViewControllerState) {
        presentingViewController = viewController
        
        var gcvc = GKGameCenterViewController()
        gcvc.viewState = viewState
        gcvc.gameCenterDelegate = self
        presentingViewController.presentViewController(gcvc, animated: true, completion: nil)
    }
    
    // MARK: GKGameCenterControllerDelegate
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: GKMatchmakerViewControllerDelegate
    
    func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController!) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        presentingViewController.navigationController?.popViewControllerAnimated(true)
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController!, didFailWithError error: NSError!) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        println("Error finding match: \(error.localizedDescription)")
    }
    
    func matchmakerViewController(viewController: GKMatchmakerViewController!, didFindMatch theMatch: GKMatch!) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        match = theMatch
        match.delegate = self
        if (!matchStarted && match.expectedPlayerCount == 0) {
            println("Ready to start match!")
            self.lookupPlayers()
        }
    }
    
    // MARK: GKMatchDelegate
    
    func match(theMatch: GKMatch!, didReceiveData data: NSData!, fromPlayer playerID: String!) {
        if (match != theMatch) {
            return
        }
        
        delegate.match(theMatch, didReceiveData: data, fromPlayer: playerID)
    }
    
    func match(theMatch: GKMatch!, player playerID: String!, didChangeState state: GKPlayerConnectionState) {
        if (match != theMatch) {
            return
        }
        
        switch (state) {
        case GKPlayerConnectionState.StateConnected:
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                lookupPlayers()
            }
        case GKPlayerConnectionState.StateDisconnected:
            matchStarted = false
            delegate.matchEnded()
            match = nil
        default:
            break
        }
    }
    
    func match(theMatch: GKMatch!, didFailWithError error: NSError!) {
        if (match != theMatch) {
            return
        }
        
        println("Match failed with error: \(error.localizedDescription)")
        matchStarted = false
        delegate.matchEnded()
    }
    
    // MARK: GKLocalPlayerListener
    
    func player(player: GKPlayer!, didAcceptInvite inviteToAccept: GKInvite!) {
        var mmvc = GKMatchmakerViewController(invite: inviteToAccept)
        mmvc.matchmakerDelegate = self
        presentingViewController.presentViewController(mmvc, animated: true, completion: nil)
    }
    
    func player(player: GKPlayer!, didRequestMatchWithOtherPlayers playersToInvite: [AnyObject]!) {
        
    }
}