//
//  CardDataSource.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

protocol CardDataSource
{
    
    var count: Int { get }
    
    var numStamped: Int { get }
    
    func isStamped(index: Int) -> Bool
    
    func stamp(index: Int, stamped stamp: Bool)
    
}