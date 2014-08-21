//
//  Common.swift
//  PointRun
//
//  Created by Jack Cook on 8/5/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import Foundation

let defaults = NSUserDefaults.standardUserDefaults()

let statisticNotification = "StatisticNotification"
let achievementNotification = "AchievementNotification"
let leaderboardNotification = "LeaderboardNotification"
let backNotification = "BackNotification"
let mapChangedNotification = "MapChangedNotification"

let menuWidth: CGFloat = 260
let alertWidth: CGFloat = 280
let alertHeight: CGFloat = 175

let wat = "i dont want to live on this planet anymore"

enum PRGameMode: Int {
    case Timed = 0
    case Endless = 1
    case Chance = 2
}