//
//  UserDefaultsCardDataSource.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

class UserDefaultsCardDataSource: CardDataSource
{
    
    let defaults: NSUserDefaults
    
    let key: String
    
    init(key: String, count: Int)
    {
        self.defaults = NSUserDefaults()
        self.key = key

        if let card = defaults.stringArrayForKey(key) {
            if count == card.count {
                return
            }
        }

        defaults.setObject([String](count: count, repeatedValue: "false"), forKey: key)
        defaults.synchronize()
    }
    
    private var card: [Bool] {
        return defaults.stringArrayForKey(key)!.map { ($0 as! String) == "true" }
    }
    
    // MARK - CardDataSource methods
    
    var count: Int {
        return card.count
    }
    
    var numStamped: Int {
        return card.reduce(0) { return $1 ? $0 + 1 : $0 }
    }
    
    func isStamped(index: Int) -> Bool {
        return card[index]
    }
    
    func stamp(index: Int, stamped stamp: Bool) {
        var newCard = card
        newCard[index] = stamp
        defaults.setObject(newCard.map { $0 ? "true" : "false" }, forKey: key)
        defaults.synchronize()
    }
    
}