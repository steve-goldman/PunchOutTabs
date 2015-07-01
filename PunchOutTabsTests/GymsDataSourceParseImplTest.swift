//
//  GymsDataSourceParseImplTest.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/1/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import XCTest
import PunchOutTabs
import Parse

class GymsDataSourceParseImplTest: XCTestCase {

    let chezStu = PFGeoPoint(latitude: 40.677701, longitude: -73.974661)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let gds = GymsDataSourceParseImpl(async: false)
        var calledBack = false
        gds.nearestGyms(chezStu, limit: 3) { (gyms: [Gym]?) in
            calledBack = true
            XCTAssertTrue(gyms != nil)
            XCTAssertEqual(3, gyms!.count)
            XCTAssertEqual("Exhale Flatiron", gyms![0].name, "Expected 'Exhale Flatiron'")
        }
        XCTAssertTrue(calledBack)
    }

}
