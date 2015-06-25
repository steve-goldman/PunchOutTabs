//
//  DummyLeaderboardDataSource.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

class DummyLeaderboardDataSource: LeaderboardDataSource {
    
    private let elements = [
        LeaderboardElement(name: "Emily", tally: 16),
        LeaderboardElement(name: "Ssor", tally: 12),
        LeaderboardElement(name: "Obama", tally: 10),
        LeaderboardElement(name: "Neil Armstrong", tally: 9),
        LeaderboardElement(name: "Mickey Mouse", tally: 9),
        LeaderboardElement(name: "Person With a Really Long Name", tally: 8),
        LeaderboardElement(name: "Ssor's Allison", tally: 6),
        LeaderboardElement(name: "Bridgette", tally: 5),
        LeaderboardElement(name: "Dan T", tally: 5),
        LeaderboardElement(name: "Al", tally: 2),
        LeaderboardElement(name: "Stu", tally: 1),
    ]
    
    var count: Int {
        return elements.count
    }
    
    func getAt(index: Int) -> LeaderboardElement {
        return elements[index]
    }

}