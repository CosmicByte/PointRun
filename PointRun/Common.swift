//
//  Common.swift
//  PointRun
//
//  Created by Jack Cook on 8/5/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import AudioToolbox
import GoogleMaps

let defaults = UserDefaults.standard
let nc = NotificationCenter.default

let gameWinsStatistic = "GameWins"
let timePlayedStatistic = "TimePlayed"
let metersTravelledStatistic = "MetersTravelled"
let pinsCollectedStatistic = "PinsCollected"
let pointsEarnedStatistic = "PointsEarned"
let poisonPinsStatistic = "PoisonPins"

let statisticNotification = Notification.Name("Statistic")
let achievementNotification = Notification.Name("Achievement")
let leaderboardNotification = Notification.Name("Leaderboard")
let backNotification = Notification.Name("Back")
let mapChangedNotification = Notification.Name("MapChanged")

let menuWidth: CGFloat = 260
let alertWidth: CGFloat = 280
let alertHeight: CGFloat = 175

enum PRGameMode: Int {
    case timed = 0
    case endless = 1
    case chance = 2
    case race = 3
}

enum PRMessageType: Int {
    case playerData = 0
    case pointLocation = 1
    case pointCaptured = 2
}

enum PRGameEnd: Int {
    case menuExit = 0
    case timerDone = 1
    case poisonPin = 2
    case disconnect = 3
    case error = 4
    case multiplayerWin = 5
    case multiplayerLoss = 6
}

func vibrate() {
    AudioServicesPlaySystemSound(1352)
}
