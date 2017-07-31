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
    
    @IBOutlet var timedButtonBackground: UIButton!
    @IBOutlet var timedButtonIcon: UIImageView!
    @IBOutlet var timedButtonTitle: UILabel!
    @IBOutlet var timedButtonDescription: UILabel!
    
    @IBOutlet var endlessButtonBackground: UIButton!
    @IBOutlet var endlessButtonIcon: UIImageView!
    @IBOutlet var endlessButtonTitle: UILabel!
    @IBOutlet var endlessButtonDescription: UILabel!
    
    @IBOutlet var chanceButtonBackground: UIButton!
    @IBOutlet var chanceButtonIcon: UIImageView!
    @IBOutlet var chanceButtonTitle: UILabel!
    @IBOutlet var chanceButtonDescription: UILabel!
    
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
            singlePlayerButton.setImage(UIImage(named: "element19.png"), for: UIControlState())
        } else {
            singlePlayerButton.setImage(UIImage(named: "element18.png"), for: UIControlState())
        }
        
        singlePlayerButton.setImage(UIImage(named: "element07.png"), for: .highlighted)
        
        singlePlayerImage.image = UIImage(named: "singleWhite.png")
    }
    
    @IBAction func singlePlayerUp(_ sender: AnyObject) {
        singlePlayerButton.setImage(UIImage(named: "element18.png"), for: UIControlState())
        
        multiPlayerButton.setImage(UIImage(named: "element19.png"), for: UIControlState())
        multiPlayerButton.setImage(UIImage(named: "element07.png"), for: .highlighted)
        
        multiPlayerImage.image = UIImage(named: "multiGreen.png")
        
        singlePlayer = true
        
        timedButtonIcon.image = UIImage(named: "gamemodeTimer.png")
        timedButtonIcon.frame = CGRect(x: 42, y: 183, width: 39, height: 36)
        timedButtonTitle.text = "Timed"
        timedButtonDescription.text = "You will be given 5 minutes to collect as many points as you can."
        
        endlessButtonBackground.alpha = 1.0
        endlessButtonIcon.alpha = 1.0
        endlessButtonTitle.alpha = 1.0
        endlessButtonDescription.alpha = 1.0
        
        chanceButtonBackground.alpha = 1.0
        chanceButtonIcon.alpha = 1.0
        chanceButtonTitle.alpha = 1.0
        chanceButtonDescription.alpha = 1.0
    }
    
    @IBAction func singlePlayerUpOutside(_ sender: AnyObject) {
        if singlePlayer {
            singlePlayerButton.setImage(UIImage(named: "element18.png"), for: UIControlState())
            singlePlayerImage.image = UIImage(named: "singleWhite.png")
        } else {
            singlePlayerButton.setImage(UIImage(named: "element19.png"), for: UIControlState())
            singlePlayerImage.image = UIImage(named: "singleGreen.png")
        }
    }
    
    @IBAction func singlePlayerDragEnter(_ sender: AnyObject) {
        singlePlayerImage.image = UIImage(named: "singleWhite.png")
    }
    
    @IBAction func singlePlayerDragExit(_ sender: AnyObject) {
        if singlePlayer {
            singlePlayerImage.image = UIImage(named: "singleWhite.png")
        } else {
            singlePlayerImage.image = UIImage(named: "singleGreen.png")
        }
    }
    
    @IBAction func multiPlayerDown(_ sender: AnyObject) {
        multiPlayerButton.setImage(UIImage(named: "element19.png"), for: UIControlState())
        multiPlayerButton.setImage(UIImage(named: "element07.png"), for: .highlighted)
        
        multiPlayerImage.image = UIImage(named: "multiWhite.png")
    }
    
    @IBAction func multiPlayerUp(_ sender: AnyObject) {
        multiPlayerButton.setImage(UIImage(named: "element18.png"), for: UIControlState())
        
        singlePlayerButton.setImage(UIImage(named: "element19.png"), for: UIControlState())
        singlePlayerButton.setImage(UIImage(named: "element07.png"), for: .highlighted)
        
        singlePlayerImage.image = UIImage(named: "singleGreen.png")
        
        singlePlayer = false
        
        timedButtonIcon.image = UIImage(named: "gamemodeRace.png")
        timedButtonIcon.frame = CGRect(x: (timedButtonBackground.frame.size.height - timedButtonIcon.frame.size.height / 1.08108) / 2 + timedButtonBackground.frame.origin.y, y: timedButtonIcon.frame.origin.y, width: timedButtonIcon.frame.size.width, height: timedButtonIcon.frame.size.height / 1.08108)
        timedButtonTitle.text = "Race"
        timedButtonDescription.text = "Beat up to three other friends in a race to 100 points."
        
        endlessButtonBackground.alpha = 0.0
        endlessButtonIcon.alpha = 0.0
        endlessButtonTitle.alpha = 0.0
        endlessButtonDescription.alpha = 0.0
        
        chanceButtonBackground.alpha = 0.0
        chanceButtonIcon.alpha = 0.0
        chanceButtonTitle.alpha = 0.0
        chanceButtonDescription.alpha = 0.0
    }
    
    @IBAction func multiPlayerUpOutside(_ sender: AnyObject) {
        if singlePlayer {
            multiPlayerButton.setImage(UIImage(named: "element19.png"), for: UIControlState())
            multiPlayerImage.image = UIImage(named: "multiGreen.png")
        } else {
            multiPlayerButton.setImage(UIImage(named: "element18.png"), for: UIControlState())
            multiPlayerImage.image = UIImage(named: "multiWhite.png")
        }
    }
    
    @IBAction func multiPlayerDragEnter(_ sender: AnyObject) {
        multiPlayerImage.image = UIImage(named: "multiWhite.png")
    }
    
    @IBAction func multiPlayerDragExit(_ sender: AnyObject) {
        multiPlayerImage.image = UIImage(named: "multiGreen.png")
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
