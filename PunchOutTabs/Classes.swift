//
//  Classes.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

public class Class: Printable
{
    public let name: String
    public let instructor: String
    public let gym: Gym
    public let time: NSDate
    
    init(name: String, instructor: String, gym: Gym, time: NSDate) {
        self.name = name
        self.instructor = instructor
        self.gym = gym
        self.time = time
    }
    
    public var description: String {
        return "Class[\(name) by \(instructor) at \(gym) at time"
    }
}

public typealias ClassesCallback = (classes: [Class]?) -> ()

public protocol ClassesDataSource
{
    func classesForGym(gym: Gym, limit: Int, callback: ClassesCallback)
}