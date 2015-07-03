//
//  Gyms.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class Gym: Printable
{
    let name: String
    let location: PFGeoPoint
    
    init(name: String, location: PFGeoPoint) {
        self.name = name
        self.location = location
    }
    
    public var description: String {
        return "Gym[\(name)]"
    }
}

public typealias NearestGymsCallback = (gyms: [Gym]?) -> ()

public protocol GymsDataSource
{
    func nearestGyms(geoPoint: PFGeoPoint, limit: Int, callback: NearestGymsCallback)
}
