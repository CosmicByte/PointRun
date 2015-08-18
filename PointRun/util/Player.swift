//
//  Player.swift
//  PointRun
//
//  Created by Jack Cook on 9/24/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import Foundation
import GoogleMaps

class Player: NSObject {
    
    var points = 0
    
    var pid: String!
    var name: String!
    var mapPoint: GMSMarker!
}