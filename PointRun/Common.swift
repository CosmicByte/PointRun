//
//  Common.swift
//  PointRun
//
//  Created by Jack Cook on 8/5/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import AudioToolbox
import GoogleMaps

let defaults = NSUserDefaults.standardUserDefaults()
let nc = NSNotificationCenter.defaultCenter()

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

func vibrate() {
    AudioServicesPlaySystemSound(1352)
}
