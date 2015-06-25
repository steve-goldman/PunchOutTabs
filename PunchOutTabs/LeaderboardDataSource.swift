//
//  LeaderboardDataSource.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

protocol LeaderboardDataSource {
    
    var count: Int { get }
    
    func getAt(index: Int) -> LeaderboardElement
    
}