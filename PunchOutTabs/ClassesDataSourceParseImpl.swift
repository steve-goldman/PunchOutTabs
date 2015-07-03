//
//  ClassesDataSourceParseImpl.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class ClassesDataSourceParseImpl: ParseDataSource, ClassesDataSource
{
    public func classesForGym(gym: Gym, limit: Int, callback: ClassesCallback) {
        var query = PFQuery(className: Class.ClassName)
        let user = PFUser.currentUser()
        //query.whereKey(Class.GymKey, equalTo: )
        query.limit = limit
        findObjects(query) { (results: [AnyObject]?, error: NSError?) in
            if let classes = results {
                callback(classes: classes.map {
                    return Class(name: $0[Class.NameKey] as! String, instructor: $0[Class.InstructorKey] as! String, gym: $0[Class.GymKey] as! Gym, time: $0[Class.TimeKey] as! NSDate)
                })
            }
        }
    }
}

extension Class {
    static let ClassName = "Class"
    static let NameKey = "name"
    static let InstructorKey = "instructor"
    static let GymKey = "gym"
    static let TimeKey = "time"
}