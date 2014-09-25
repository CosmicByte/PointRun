//
//  Communication.swift
//  PointRun
//
//  Created by Jack Cook on 9/24/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import Foundation

class Message: NSObject {
    
    var latitude = 0.0
    var longitude = 0.0
    var points = 0
    
    var uuid = ""
    var type: PRMessageType!
    
    init(playerDataWithPoints pts: Int, latitude lat: Double, longitude lon: Double) {
        latitude = lat
        longitude = lon
        points = pts
        type = PRMessageType.PlayerData
    }
    
    init(pointLocationWithLatitude lat: Double, longitude lon: Double, points pts: Int, uuid uid: String) {
        latitude = lat
        longitude = lon
        points = pts
        uuid = uid
        type = PRMessageType.PointLocation
    }
    
    init(pointCapturedWithUUID uid: String) {
        uuid = uid
        type = PRMessageType.PointCaptured
    }
    
    func intToMessageType(int: Int) -> PRMessageType {
        switch (int) {
        case 0:
            return PRMessageType.PlayerData
        case 1:
            return PRMessageType.PointLocation
        case 2:
            return PRMessageType.PointCaptured
        default:
            NSLog("\(wat)")
        }
        
        return PRMessageType.PlayerData
    }
    
    required init(coder aDecoder: NSCoder) {
        latitude = aDecoder.decodeDoubleForKey("latitude")
        longitude = aDecoder.decodeDoubleForKey("longitude")
        points = aDecoder.decodeIntegerForKey("points")
        uuid = aDecoder.decodeObjectForKey("uuid") as String
        
        var typeValue = aDecoder.decodeIntegerForKey("type")
        switch (typeValue) {
        case 0:
            type = PRMessageType.PlayerData
        case 1:
            type = PRMessageType.PointLocation
        case 2:
            type = PRMessageType.PointCaptured
        default:
            NSLog("\(wat)")
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(latitude, forKey: "latitude")
        aCoder.encodeDouble(longitude, forKey: "longitude")
        aCoder.encodeInteger(points, forKey: "points")
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeInteger(type.toRaw(), forKey: "type")
    }
}