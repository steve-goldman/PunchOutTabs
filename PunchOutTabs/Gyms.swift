//
//  Gyms.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public struct Gym
{
    public let name: String
    let location: PFGeoPoint
}

public typealias NearestGymsCallback = (gym: [Gym]?) -> ()

public protocol GymsDataSource
{
    func nearestGyms(geoPoint: PFGeoPoint, limit: Int, callback: NearestGymsCallback)
}
