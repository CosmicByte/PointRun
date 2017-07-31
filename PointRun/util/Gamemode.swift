//
//  Gamemode.swift
//  PointRun
//
//  Created by Jack Cook on 7/30/17.
//  Copyright © 2017 CosmicByte. All rights reserved.
//

import UIKit

enum Gamemode: Int {
    case timed = 0, endless, chance, race
    
    var thumbnail: UIImage {
        switch self {
        case .timed:
            return #imageLiteral(resourceName: "Timer Gamemode")
        case .endless:
            return #imageLiteral(resourceName: "Endless Gamemode")
        case .chance:
            return #imageLiteral(resourceName: "Target Gamemode")
        case .race:
            return #imageLiteral(resourceName: "Race Gamemode")
        }
    }
    
    var title: String {
        switch self {
        case .timed:
            return "Timed"
        case .endless:
            return "Endless"
        case .chance:
            return "Chance"
        case .race:
            return "Race"
        }
    }
    
    var description: String {
        switch self {
        case .timed:
            return "You will be given five minutes to collect as many points as you can."
        case .endless:
            return "Play for hours upon end! Each time you collect a pin, a new one appears."
        case .chance:
            return "No time limit, but one in ten pins will end the game. How long can you survive?"
        case .race:
            return "Beat up to three other friends in a race to 100 points."
        }
    }
}
