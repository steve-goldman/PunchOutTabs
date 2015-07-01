//
//  ParseDataSource.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class ParseDataSource
{
    let async: Bool
    
    public init(async: Bool) {
        self.async = async
    }
    
    func findObjects(query: PFQuery, callback: PFArrayResultBlock) {
        if async {
            query.findObjectsInBackgroundWithBlock(callback)
        } else {
            let results = query.findObjects()
            // TODO: figure out error handling in sync find
            callback(results, nil)
        }
    }
}