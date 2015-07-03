//
//  File.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class GymsDataSourceParseImpl: ParseDataSource, GymsDataSource
{
    public func nearestGyms(geoPoint: PFGeoPoint, limit: Int, callback: NearestGymsCallback) {
        var query = PFQuery(className: Gym.ClassName)
        query.whereKey(Gym.LocationKey, nearGeoPoint: geoPoint)
        query.limit = limit
        findObjects(query) { (results: [AnyObject]?, error: NSError?) in
            if let gyms = results {
                callback(gyms: gyms.map { return Gym(name: ($0[Gym.NameKey] as! String), location: $0[Gym.LocationKey] as! PFGeoPoint) })
            }
        }
    }
}

extension Gym {
    static let ClassName = "Gym"
    static let LocationKey = "location"
    static let NameKey = "name"
}