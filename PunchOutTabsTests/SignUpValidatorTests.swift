//
//  SignUpValidatorTests.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/28/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import XCTest
import PunchOutTabs

class SignUpValidatorTests: XCTestCase {

    private struct Constants
    {
        static let UsernameTooShort = "acbde"
        static let UsernameShortest = "abcdef"
        static let UsernameLongest = "abcdefabcdefabcdefab"
        static let UsernameTooLong = "abcdefabcdefabcdefabc"
        static let GoodUsername = UsernameShortest
        static let GoodPassword = "abcdef"
        static let GoodEmail = "stu@stu.com"
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private func assertBadUsername(username: String) {
        let result = SignUpValidator.validate(username: username, password: Constants.GoodPassword, email: Constants.GoodEmail)
        XCTAssertFalse(result.valid, "expected invalid username for \(username)")
        XCTAssertEqual(SignUpValidator.Username, result.errorSection!)
    }
    
    private func assertGoodUsername(username: String) {
        let result = SignUpValidator.validate(username: username, password: Constants.GoodPassword, email: Constants.GoodEmail)
        XCTAssertTrue(result.valid, "expected valid username for \(username)")
    }
    
    private func assertBadPassword(password: String) {
        let result = SignUpValidator.validate(username: Constants.GoodUsername, password: password, email: Constants.GoodEmail)
        XCTAssertFalse(result.valid, "expected invalid password for \(password)")
        XCTAssertEqual(SignUpValidator.Password, result.errorSection!)
    }
    
    private func assertGoodPassword(password: String) {
        let result = SignUpValidator.validate(username: Constants.GoodUsername, password: password, email: Constants.GoodEmail)
        XCTAssertTrue(result.valid, "expected valid password for \(password)")
    }
    
    private func assertBadEmail(email: String) {
        let result = SignUpValidator.validate(username: Constants.GoodUsername, password: Constants.GoodPassword, email: email)
        XCTAssertFalse(result.valid, "expected invalid email for \(email)")
        XCTAssertEqual(SignUpValidator.Email, result.errorSection!)
    }
    
    private func assertGoodEmail(email: String) {
        let result = SignUpValidator.validate(username: Constants.GoodUsername, password: Constants.GoodPassword, email: email)
        XCTAssertTrue(result.valid, "expected valid email for \(email)")
    }
    
    func testUsernameLength() {
        assertBadUsername(Constants.UsernameTooShort)
        assertGoodUsername(Constants.UsernameShortest)
        assertGoodUsername(Constants.UsernameLongest)
        assertBadUsername(Constants.UsernameTooLong)
    }
    
    func testUsernameContents() {
        assertBadUsername("1bcdef")
        assertBadUsername("_bcdef")
        assertBadUsername("abcde+")
        assertBadUsername("abcde-")
        assertBadUsername("abcde-")
        assertBadUsername("abcde*")
        assertBadUsername("abcde{")
        assertBadUsername("abcde ")
        
        assertGoodUsername("a12345")
        assertGoodUsername("A12345")
        assertGoodUsername("a_____")
        assertGoodUsername("a1_bB12")
    }
    
    func testPasswordContents() {
        assertBadPassword("abcde")
        assertGoodPassword("abcdef")
        assertGoodPassword("a     ")
        assertGoodPassword("     a")
        assertBadPassword("      ")
    }
    
    func testEmailContents() {
        assertGoodEmail("stu@gmail.com")
        assertGoodEmail("STU@G.net")
        assertBadEmail("@hello.net")
        assertBadEmail("stu@g")
        assertBadEmail("")
        assertBadEmail("    ")
    }
    
}
