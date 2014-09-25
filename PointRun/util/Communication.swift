//
//  Communication.swift
//  PointRun
//
//  Created by Jack Cook on 9/24/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import Foundation

enum PRMessageType: Int {
    case PlayerLocation = 0
    case PointLocation = 1
    case PlayerData = 2
}

class Message: NSObject {
    
    var latitude = 0.0
    var longitude = 0.0
    var points = 0
    
    var type: PRMessageType!
    
    init(playerLocationWithLatitude lat: Double, longitude lon: Double) {
        latitude = lat
        longitude = lon
        type = PRMessageType.PlayerLocation
    }
    
    init(pointLocationWithLatitude lat: Double, longitude lon: Double, points pts: Int) {
        latitude = lat
        longitude = lon
        points = pts
        type = PRMessageType.PointLocation
    }
    
    init(playerDataWithWhatever: String) {
        type = PRMessageType.PlayerData
    }
    
    func intToMessageType(int: Int) -> PRMessageType {
        switch (int) {
        case 0:
            return PRMessageType.PlayerLocation
        case 1:
            return PRMessageType.PointLocation
        case 2:
            return PRMessageType.PlayerData
        default:
            NSLog("\(wat)")
        }
        
        return PRMessageType.PlayerLocation
    }
    
    required init(coder aDecoder: NSCoder) {
        latitude = aDecoder.decodeDoubleForKey("latitude")
        longitude = aDecoder.decodeDoubleForKey("longitude")
        points = aDecoder.decodeIntegerForKey("points")
        
        var typeValue = aDecoder.decodeIntegerForKey("type")
        switch (typeValue) {
        case 0:
            type = PRMessageType.PlayerLocation
        case 1:
            type = PRMessageType.PointLocation
        case 2:
            type = PRMessageType.PlayerData
        default:
            NSLog("\(wat)")
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(latitude, forKey: "latitude")
        aCoder.encodeDouble(longitude, forKey: "longitude")
        aCoder.encodeInteger(points, forKey: "points")
        aCoder.encodeInteger(type.toRaw(), forKey: "type")
    }
}