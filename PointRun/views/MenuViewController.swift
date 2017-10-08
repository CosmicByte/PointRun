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

    @IBOutlet var singlePlayerButton: PlayerNumberButton!
    @IBOutlet var multiPlayerButton: PlayerNumberButton!
    
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
    
    @IBAction func singlePlayerPressed(_ sender: Any) {
        singlePlayer = true
        
        timedButton.gamemodeValue = Gamemode.timed.rawValue
        endlessButton.alpha = 1
        chanceButton.alpha = 1
        
        singlePlayerButton.isSelected = true
        multiPlayerButton.isSelected = false
    }
    
    @IBAction func multiPlayerPressed(_ sender: Any) {
        singlePlayer = false
        
        timedButton.gamemodeValue = Gamemode.race.rawValue
        endlessButton.alpha = 0
        chanceButton.alpha = 0
        
        singlePlayerButton.isSelected = false
        multiPlayerButton.isSelected = true
    }
    
    @objc func menuTab(_ note: Notification) {
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
