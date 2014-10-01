//
//  Common.swift
//  PointRun
//
//  Created by Jack Cook on 8/5/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import AudioToolbox

let defaults = NSUserDefaults.standardUserDefaults()
let nc = NSNotificationCenter.defaultCenter()

let marathonManDefault = "MarathonMan"
let hatTrickDefault = "HatTrick"
let k100Default = "100"
let addictedDefault = "Addicted"
let badLuckDefault = "BadLuck"
let evaderDefault = "Evader"

let marathonManCompleted = "MarathonManCompleted"
let hatTrickCompleted = "HatTrickCompleted"
let k100Completed = "100Completed"
let addictedCompleted = "AddictedCompleted"
let badLuckCompleted = "BadLuckCompleted"
let evaderCompleted = "EvaderCompleted"

let gameWinsStatistic = "GameWins"
let timePlayedStatistic = "TimePlayed"
let metersTravelledStatistic = "MetersTravelled"
let pinsCollectedStatistic = "PinsCollected"
let pointsEarnedStatistic = "PointsEarned"
let poisonPinsStatistic = "PoisonPins"

let statisticNotification = "Statistic"
let achievementNotification = "Achievement"
let leaderboardNotification = "Leaderboard"
let backNotification = "Back"
let mapChangedNotification = "MapChanged"

let menuWidth: CGFloat = 260
let alertWidth: CGFloat = 280
let alertHeight: CGFloat = 175

let wat = "i dont want to live on this planet anymore"

enum PRGameMode: Int {
    case Timed = 0
    case Endless = 1
    case Chance = 2
    case Race = 3
}

enum PRMessageType: Int {
    case PlayerData = 0
    case PointLocation = 1
    case PointCaptured = 2
}

enum PRGameEnd: Int {
    case MenuExit = 0
    case TimerDone = 1
    case PoisonPin = 2
    case Disconnect = 3
    case Error = 4
    case MultiplayerWin = 5
    case MultiplayerLoss = 6
}

enum PRAchievement: Int {
    case MarathonMan = 0
    case HatTrick = 1
    case k100 = 2
    case Addicted = 3
    case BadLuck = 4
    case Evader = 5
}

func vibrate() {
    AudioServicesPlaySystemSound(1352)
}
