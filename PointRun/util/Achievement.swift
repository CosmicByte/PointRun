//
//  Achievement.swift
//  PointRun
//
//  Created by Jack Cook on 9/30/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import Foundation

func checkAchievement(achievement: PRAchievement) {
    switch (achievement) {
    case PRAchievement.MarathonMan:
        if (!defaults.boolForKey(marathonManCompleted)) {
            var meters = defaults.doubleForKey(marathonManDefault)
            GCHelper.sharedInstance.reportAchievementIdentifier("marathonman", percent: 0.002 * meters)
            defaults.setBool(true, forKey: marathonManDefault)
        }
    case PRAchievement.HatTrick:
        if (!defaults.boolForKey(hatTrickCompleted)) {
            var inarow = defaults.integerForKey(hatTrickDefault)
            if (inarow == 3) {
                GCHelper.sharedInstance.reportAchievementIdentifier("hattrick", percent: 100.0)
            }
            defaults.setBool(true, forKey: hatTrickCompleted)
        }
    case PRAchievement.k100:
        if (!defaults.boolForKey(k100Completed)) {
            var wins = defaults.doubleForKey(k100Default)
            GCHelper.sharedInstance.reportAchievementIdentifier("100", percent: wins)
            defaults.setBool(true, forKey: k100Completed)
        }
    case PRAchievement.Addicted:
        if (!defaults.boolForKey(addictedCompleted)) {
            var time = defaults.doubleForKey(addictedDefault)
            GCHelper.sharedInstance.reportAchievementIdentifier("addicted", percent: (1 / 864) * time)
            defaults.setBool(true, forKey: addictedCompleted)
        }
    case PRAchievement.BadLuck:
        if (!defaults.boolForKey(badLuckCompleted)) {
            var deaths = defaults.doubleForKey(badLuckDefault)
            GCHelper.sharedInstance.reportAchievementIdentifier("badluck", percent: deaths * 5)
            defaults.setBool(true, forKey: badLuckCompleted)
        }
    case PRAchievement.Evader:
        if (!defaults.boolForKey(evaderCompleted)) {
            var score = defaults.integerForKey(evaderDefault)
            if (score >= 100) {
                GCHelper.sharedInstance.reportAchievementIdentifier("evader", percent: 100.0)
            }
            defaults.setBool(true, forKey: evaderCompleted)
        }
    default:
        NSLog("\(wat)")
    }
}