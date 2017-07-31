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
        type = .playerData
    }
    
    init(pointLocationWithLatitude lat: Double, longitude lon: Double, points pts: Int, uuid uid: String) {
        latitude = lat
        longitude = lon
        points = pts
        uuid = uid
        type = .pointLocation
    }
    
    init(pointCapturedWithUUID uid: String) {
        uuid = uid
        type = .pointCaptured
    }
    
    required init(coder aDecoder: NSCoder) {
        latitude = aDecoder.decodeDouble(forKey: "latitude")
        longitude = aDecoder.decodeDouble(forKey: "longitude")
        points = aDecoder.decodeInteger(forKey: "points")
        uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        
        let typeValue = aDecoder.decodeInteger(forKey: "type")
        
        switch typeValue {
        case 0:
            type = .playerData
        case 1:
            type = .pointLocation
        case 2:
            type = .pointCaptured
        default:
            break
        }
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(points, forKey: "points")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(type.rawValue, forKey: "type")
    }
    
    func intToMessageType(_ int: Int) -> PRMessageType {
        switch int {
        case 0:
            return .playerData
        case 1:
            return .pointLocation
        case 2:
            return .pointCaptured
        default:
            break
        }
        
        return .playerData
    }
}
