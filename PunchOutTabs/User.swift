//
//  User.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/5/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public extension PFUser
{
    private static let LastLoginKey = "lastLogin"
    
    public var lastLogin: NSDate? {
        get {
            return objectForKey(PFUser.LastLoginKey) as? NSDate
        }
        set {
            setObject(newValue!, forKey: PFUser.LastLoginKey)
        }
    }
    
    
    private static let ForgotPasswordRequestedKey = "forgotPasswordRequested"
    
    public var forgotPasswordRequested: NSDate? {
        get {
            return objectForKey(PFUser.ForgotPasswordRequestedKey) as? NSDate
        }
        set {
            setObject(newValue!, forKey: PFUser.ForgotPasswordRequestedKey)
        }
    }
}
