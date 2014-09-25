//
//  MenuViewController.swift
//  PointRun
//
//  Created by Jack Cook on 8/1/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var singlePlayerButton: UIButton!
    @IBOutlet var multiPlayerButton: UIButton!
    @IBOutlet var singlePlayerImage: UIImageView!
    @IBOutlet var multiPlayerImage: UIImageView!
    
    var menuView: MenuView!
    
    var singlePlayer = true
    var gameMode = PRGameMode.Timed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
        var nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: Selector("menuTab:"), name: statisticNotification, object: nil)
        nc.addObserver(self, selector: Selector("menuTab:"), name: achievementNotification, object: nil)
        nc.addObserver(self, selector: Selector("menuTab:"), name: leaderboardNotification, object: nil)
    }
    
    @IBAction func menuButton(sender: AnyObject) {
        menuView = MenuView()
        menuView.showStatistics()
        self.view.addSubview(menuView)
        menuView.show()
    }
    
    @IBAction func singlePlayerDown(sender: AnyObject) {
        if (!singlePlayer) {
            singlePlayerButton.setImage(UIImage(named: "element19.png"), forState: UIControlState.Normal)
        } else {
            singlePlayerButton.setImage(UIImage(named: "element18.png"), forState: UIControlState.Normal)
        }
        singlePlayerButton.setImage(UIImage(named: "element07.png"), forState: UIControlState.Highlighted)
        
        singlePlayerImage.image = UIImage(named: "singleWhite.png")
    }
    
    @IBAction func singlePlayerUp(sender: AnyObject) {
        singlePlayerButton.setImage(UIImage(named: "element18.png"), forState: UIControlState.Normal)
        
        multiPlayerButton.setImage(UIImage(named: "element19.png"), forState: UIControlState.Normal)
        multiPlayerButton.setImage(UIImage(named: "element07.png"), forState: UIControlState.Highlighted)
        
        multiPlayerImage.image = UIImage(named: "multiGreen.png")
        
        singlePlayer = true
    }
    
    @IBAction func singlePlayerUpOutside(sender: AnyObject) {
        if (singlePlayer) {
            singlePlayerButton.setImage(UIImage(named: "element18.png"), forState: UIControlState.Normal)
            singlePlayerImage.image = UIImage(named: "singleWhite.png")
        } else {
            singlePlayerButton.setImage(UIImage(named: "element19.png"), forState: UIControlState.Normal)
            singlePlayerImage.image = UIImage(named: "singleGreen.png")
        }
    }
    
    @IBAction func singlePlayerDragEnter(sender: AnyObject) {
        singlePlayerImage.image = UIImage(named: "singleWhite.png")
    }
    
    @IBAction func singlePlayerDragExit(sender: AnyObject) {
        if (singlePlayer) {
            singlePlayerImage.image = UIImage(named: "singleWhite.png")
        } else {
            singlePlayerImage.image = UIImage(named: "singleGreen.png")
        }
    }
    
    @IBAction func multiPlayerDown(sender: AnyObject) {
        multiPlayerButton.setImage(UIImage(named: "element19.png"), forState: UIControlState.Normal)
        multiPlayerButton.setImage(UIImage(named: "element07.png"), forState: UIControlState.Highlighted)
        
        multiPlayerImage.image = UIImage(named: "multiWhite.png")
    }
    
    @IBAction func multiPlayerUp(sender: AnyObject) {
        multiPlayerButton.setImage(UIImage(named: "element18.png"), forState: UIControlState.Normal)
        
        singlePlayerButton.setImage(UIImage(named: "element19.png"), forState: UIControlState.Normal)
        singlePlayerButton.setImage(UIImage(named: "element07.png"), forState: UIControlState.Highlighted)
        
        singlePlayerImage.image = UIImage(named: "singleGreen.png")
        
        singlePlayer = false
    }
    
    @IBAction func multiPlayerUpOutside(sender: AnyObject) {
        if (singlePlayer) {
            multiPlayerButton.setImage(UIImage(named: "element19.png"), forState: UIControlState.Normal)
            multiPlayerImage.image = UIImage(named: "multiGreen.png")
        } else {
            multiPlayerButton.setImage(UIImage(named: "element18.png"), forState: UIControlState.Normal)
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
        if (note.name == achievementNotification) {
            GCHelper.sharedInstance().showAchievements(self)
        } else if (note.name == leaderboardNotification) {
            GCHelper.sharedInstance().showLeaderboards(self)
        }
    }
    
    @IBAction func timedButton(sender: AnyObject) {
        gameMode = PRGameMode.Timed
        self.performSegueWithIdentifier("gameSegue", sender: self)
    }
    
    @IBAction func endlessButton(sender: AnyObject) {
        gameMode = PRGameMode.Endless
        self.performSegueWithIdentifier("gameSegue", sender: self)
    }
    
    @IBAction func chanceButton(sender: AnyObject) {
        gameMode = PRGameMode.Chance
        self.performSegueWithIdentifier("gameSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var gvc = segue.destinationViewController as GameViewController
        gvc.sendGameMode(gameMode: gameMode, multiplayer: !singlePlayer)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}
