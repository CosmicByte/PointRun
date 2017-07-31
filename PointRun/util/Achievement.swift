//
//  Achievement.swift
//  PointRun
//
//  Created by Jack Cook on 9/30/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import Foundation
import GCHelper

func checkAchievement(_ achievement: PRAchievement) {
    let value = defaults.double(forKey: achievement.rawValue + "Default")
    var percent: Double = 0
    
    switch achievement {
    case PRAchievement.MarathonMan:
        percent = value * 0.002
    case PRAchievement.HatTrick:
        if defaults.bool(forKey: achievement.rawValue + "Completed") {
            return
        }
        
        percent = value == 3 ? 100 : 0
    case PRAchievement.k100:
        percent = value
    case PRAchievement.Addicted:
        percent = value * 5
    case PRAchievement.BadLuck:
        percent = value * 5
    case PRAchievement.Evader:
        if defaults.bool(forKey: achievement.rawValue + "Completed") {
            return
        }
        
        percent = value >= 100 ? 100 : 0
    }
    
    GCHelper.sharedInstance.reportAchievementIdentifier(gameCenterID(achievement), percent: percent)
    defaults.set(percent >= 100, forKey: achievement.rawValue)
}

enum PRAchievement: String {
    case MarathonMan = "MarathonMan",
    HatTrick = "HatTrick",
    k100 = "100",
    Addicted = "Addicted",
    BadLuck = "BadLuck",
    Evader = "Evader"
}

func gameCenterID(_ achievement: PRAchievement) -> String {
    switch achievement {
    case .MarathonMan:
        return "marathonman"
    case .HatTrick:
        return "hattrick"
    case .k100:
        return "100"
    case .Addicted:
        return "addicted"
    case .BadLuck:
        return "badluck"
    case .Evader:
        return "evader"
    }
}
