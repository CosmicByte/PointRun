//
//  MenuViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/1/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import GameKit
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
    var gameMode = PRGameMode.Timed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.addObserver(self, selector: Selector("menuTab:"), name: statisticNotification, object: nil)
        nc.addObserver(self, selector: Selector("menuTab:"), name: achievementNotification, object: nil)
        nc.addObserver(self, selector: Selector("menuTab:"), name: leaderboardNotification, object: nil)
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        menuView = MenuView()
        menuView.viewController = self
        menuView.showStatistics()
        view.addSubview(menuView)
        menuView.show()
    }
    
    @IBAction func singlePlayerDown(sender: AnyObject) {
        if !singlePlayer {
            singlePlayerButton.setImage(UIImage(named: "element19.png"), forState: .Normal)
        } else {
            singlePlayerButton.setImage(UIImage(named: "element18.png"), forState: .Normal)
        }
        
        singlePlayerButton.setImage(UIImage(named: "element07.png"), forState: .Highlighted)
        
        singlePlayerImage.image = UIImage(named: "singleWhite.png")
    }
    
    @IBAction func singlePlayerUp(sender: AnyObject) {
        singlePlayerButton.setImage(UIImage(named: "element18.png"), forState: .Normal)
        
        multiPlayerButton.setImage(UIImage(named: "element19.png"), forState: .Normal)
        multiPlayerButton.setImage(UIImage(named: "element07.png"), forState: .Highlighted)
        
        multiPlayerImage.image = UIImage(named: "multiGreen.png")
        
        singlePlayer = true
        
        timedButtonIcon.image = UIImage(named: "gamemodeTimer.png")
        timedButtonIcon.frame = CGRectMake(42, 183, 39, 36)
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
    
    @IBAction func singlePlayerUpOutside(sender: AnyObject) {
        if singlePlayer {
            singlePlayerButton.setImage(UIImage(named: "element18.png"), forState: .Normal)
            singlePlayerImage.image = UIImage(named: "singleWhite.png")
        } else {
            singlePlayerButton.setImage(UIImage(named: "element19.png"), forState: .Normal)
            singlePlayerImage.image = UIImage(named: "singleGreen.png")
        }
    }
    
    @IBAction func singlePlayerDragEnter(sender: AnyObject) {
        singlePlayerImage.image = UIImage(named: "singleWhite.png")
    }
    
    @IBAction func singlePlayerDragExit(sender: AnyObject) {
        if singlePlayer {
            singlePlayerImage.image = UIImage(named: "singleWhite.png")
        } else {
            singlePlayerImage.image = UIImage(named: "singleGreen.png")
        }
    }
    
    @IBAction func multiPlayerDown(sender: AnyObject) {
        multiPlayerButton.setImage(UIImage(named: "element19.png"), forState: .Normal)
        multiPlayerButton.setImage(UIImage(named: "element07.png"), forState: .Highlighted)
        
        multiPlayerImage.image = UIImage(named: "multiWhite.png")
    }
    
    @IBAction func multiPlayerUp(sender: AnyObject) {
        multiPlayerButton.setImage(UIImage(named: "element18.png"), forState: .Normal)
        
        singlePlayerButton.setImage(UIImage(named: "element19.png"), forState: .Normal)
        singlePlayerButton.setImage(UIImage(named: "element07.png"), forState: .Highlighted)
        
        singlePlayerImage.image = UIImage(named: "singleGreen.png")
        
        singlePlayer = false
        
        timedButtonIcon.image = UIImage(named: "gamemodeRace.png")
        timedButtonIcon.frame = CGRectMake((timedButtonBackground.frame.size.height - timedButtonIcon.frame.size.height / 1.08108) / 2 + timedButtonBackground.frame.origin.y, timedButtonIcon.frame.origin.y, timedButtonIcon.frame.size.width, timedButtonIcon.frame.size.height / 1.08108)
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
    
    @IBAction func multiPlayerUpOutside(sender: AnyObject) {
        if singlePlayer {
            multiPlayerButton.setImage(UIImage(named: "element19.png"), forState: .Normal)
            multiPlayerImage.image = UIImage(named: "multiGreen.png")
        } else {
            multiPlayerButton.setImage(UIImage(named: "element18.png"), forState: .Normal)
            multiPlayerImage.image = UIImage(named: "multiWhite.png")
        }
    }
    
    @IBAction func multiPlayerDragEnter(sender: AnyObject) {
        multiPlayerImage.image = UIImage(named: "multiWhite.png")
    }
    
    @IBAction func multiPlayerDragExit(sender: AnyObject) {
        multiPlayerImage.image = UIImage(named: "multiGreen.png")
    }
    
    func menuTab(note: NSNotification) {
        if note.name == achievementNotification {
            GCHelper.showGameCenter(self, viewState: .Achievements)
        } else if note.name == leaderboardNotification {
            GCHelper.showGameCenter(self, viewState: .Leaderboards)
        }
    }
    
    @IBAction func timedButton(sender: AnyObject) {
        if singlePlayer {
            gameMode = .Timed
            self.performSegueWithIdentifier("gameSegue", sender: self)
        } else {
            if GKLocalPlayer.localPlayer().authenticated {
                gameMode = .Race
                self.performSegueWithIdentifier("multiplayerSegue", sender: self)
            } else {
                var alert = UIAlertController(title: "Game Center", message: "You are not signed into Game Center.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func endlessButton(sender: AnyObject) {
        gameMode = .Endless
        self.performSegueWithIdentifier("gameSegue", sender: self)
    }
    
    @IBAction func chanceButton(sender: AnyObject) {
        gameMode = .Chance
        self.performSegueWithIdentifier("gameSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "gameSegue" {
            var gvc = segue.destinationViewController as GameViewController
            gvc.sendGameMode(gameMode: gameMode)
        } else {
            var mvc = segue.destinationViewController as MultiplayerViewController
            mvc.sendGameMode(gameMode: gameMode)
        }
    }
}
