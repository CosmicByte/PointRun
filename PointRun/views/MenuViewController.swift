//
//  MenuViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/1/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import GameKit
import GCHelper
import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var singlePlayerButton: UIButton!
    @IBOutlet var multiPlayerButton: UIButton!
    @IBOutlet var singlePlayerImage: UIImageView!
    @IBOutlet var multiPlayerImage: UIImageView!
    
    @IBOutlet var timedButton: GamemodeButton!
    @IBOutlet var endlessButton: GamemodeButton!
    @IBOutlet var chanceButton: GamemodeButton!
    
    var menuView: MenuView!
    
    var singlePlayer = true
    var gameMode = PRGameMode.timed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.addObserver(self, selector: #selector(menuTab(_:)), name: statisticNotification, object: nil)
        nc.addObserver(self, selector: #selector(menuTab(_:)), name: achievementNotification, object: nil)
        nc.addObserver(self, selector: #selector(menuTab(_:)), name: leaderboardNotification, object: nil)
    }
    
    @IBAction func menuButton(_ sender: AnyObject) {
        menuView = MenuView()
        menuView.viewController = self
        menuView.showStatistics()
        view.addSubview(menuView)
        menuView.show()
    }
    
    @IBAction func singlePlayerDown(_ sender: AnyObject) {
        if !singlePlayer {
            singlePlayerButton.setImage(#imageLiteral(resourceName: "Element19"), for: .normal)
        } else {
            singlePlayerButton.setImage(#imageLiteral(resourceName: "Element18"), for: .normal)
        }
        
        singlePlayerButton.setImage(#imageLiteral(resourceName: "Element07"), for: .highlighted)
        
        singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer White")
    }
    
    @IBAction func singlePlayerUp(_ sender: AnyObject) {
        singlePlayerButton.setImage(#imageLiteral(resourceName: "Element18"), for: .normal)
        
        multiPlayerButton.setImage(#imageLiteral(resourceName: "Element19"), for: .normal)
        multiPlayerButton.setImage(#imageLiteral(resourceName: "Element07"), for: .highlighted)
        
        multiPlayerImage.image = #imageLiteral(resourceName: "Multiplayer Green")
        
        singlePlayer = true
        
        timedButton.gamemodeValue = Gamemode.timed.rawValue
        endlessButton.alpha = 1
        chanceButton.alpha = 1
    }
    
    @IBAction func singlePlayerUpOutside(_ sender: AnyObject) {
        if singlePlayer {
            singlePlayerButton.setImage(#imageLiteral(resourceName: "Element18"), for: .normal)
            singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer White")
        } else {
            singlePlayerButton.setImage(#imageLiteral(resourceName: "Element19"), for: .normal)
            singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer Green")
        }
    }
    
    @IBAction func singlePlayerDragEnter(_ sender: AnyObject) {
        singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer White")
    }
    
    @IBAction func singlePlayerDragExit(_ sender: AnyObject) {
        if singlePlayer {
            singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer White")
        } else {
            singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer Green")
        }
    }
    
    @IBAction func multiPlayerDown(_ sender: AnyObject) {
        multiPlayerButton.setImage(#imageLiteral(resourceName: "Element19"), for: .normal)
        multiPlayerButton.setImage(#imageLiteral(resourceName: "Element07"), for: .highlighted)
        
        multiPlayerImage.image = #imageLiteral(resourceName: "Multiplayer White")
    }
    
    @IBAction func multiPlayerUp(_ sender: AnyObject) {
        multiPlayerButton.setImage(#imageLiteral(resourceName: "Element18"), for: .normal)
        
        singlePlayerButton.setImage(#imageLiteral(resourceName: "Element19"), for: .normal)
        singlePlayerButton.setImage(#imageLiteral(resourceName: "Element07"), for: .highlighted)
        
        singlePlayerImage.image = #imageLiteral(resourceName: "Singleplayer Green")
        
        singlePlayer = false
        
        timedButton.gamemodeValue = Gamemode.race.rawValue
        endlessButton.alpha = 0
        chanceButton.alpha = 0
    }
    
    @IBAction func multiPlayerUpOutside(_ sender: AnyObject) {
        if singlePlayer {
            multiPlayerButton.setImage(#imageLiteral(resourceName: "Element19"), for: .normal)
            multiPlayerImage.image = #imageLiteral(resourceName: "Multiplayer Green")
        } else {
            multiPlayerButton.setImage(#imageLiteral(resourceName: "Element18"), for: .normal)
            multiPlayerImage.image = #imageLiteral(resourceName: "Multiplayer White")
        }
    }
    
    @IBAction func multiPlayerDragEnter(_ sender: AnyObject) {
        multiPlayerImage.image = #imageLiteral(resourceName: "Multiplayer White")
    }
    
    @IBAction func multiPlayerDragExit(_ sender: AnyObject) {
        multiPlayerImage.image = #imageLiteral(resourceName: "Multiplayer Green")
    }
    
    func menuTab(_ note: Notification) {
        if note.name == achievementNotification {
            GCHelper.sharedInstance.showGameCenter(self, viewState: .achievements)
        } else if note.name == leaderboardNotification {
            GCHelper.sharedInstance.showGameCenter(self, viewState: .leaderboards)
        }
    }
    
    @IBAction func timedButton(_ sender: AnyObject) {
        if singlePlayer {
            gameMode = .timed
            self.performSegue(withIdentifier: "gameSegue", sender: self)
        } else {
            if GKLocalPlayer.localPlayer().isAuthenticated {
                gameMode = .race
                self.performSegue(withIdentifier: "multiplayerSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Game Center", message: "You are not signed into Game Center.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func endlessButton(_ sender: AnyObject) {
        gameMode = .endless
        self.performSegue(withIdentifier: "gameSegue", sender: self)
    }
    
    @IBAction func chanceButton(_ sender: AnyObject) {
        gameMode = .chance
        self.performSegue(withIdentifier: "gameSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "gameSegue" {
            let gvc = segue.destination as! GameViewController
            gvc.sendGameMode(gameMode: gameMode)
        } else {
            let mvc = segue.destination as! MultiplayerViewController
            mvc.sendGameMode(gameMode: gameMode)
        }
    }
}
