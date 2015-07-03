//
//  ClassesDataSourceParseImplTest.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import XCTest
import PunchOutTabs
import Parse

class ClassesDataSourceParseImplTest: XCTestCase {

    let chezStu = PFGeoPoint(latitude: 40.677701, longitude: -73.974661)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let gds = GymsDataSourceParseImpl(async: false)
        gds.nearestGyms(chezStu, limit: 1) { (gyms: [Gym]?) in
            let gym = gyms![0]
            let cds = ClassesDataSourceParseImpl(async: false)
            cds.classesForGym(gym, limit: 10) { (classes: [Class]?) in
                for clazz in classes! {
                    println(clazz)
                }
            }
        }
    }

}
