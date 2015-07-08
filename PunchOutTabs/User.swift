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
    
    // MARK: - Keys
    
    private struct Key
    {
        static let LastLogin = "lastLogin"
        static let ForgotPasswordRequested = "forgotPasswordRequested"
        static let PendingNewCard = "pendingNewCard"
    }
    
    // MARK: - Properties
    
    public var lastLogin: NSDate? {
        get {
            return objectForKey(PFUser.Key.LastLogin) as? NSDate
        }
        set {
            setObject(newValue!, forKey: PFUser.Key.LastLogin)
        }
    }
    
    public var forgotPasswordRequested: NSDate? {
        get {
            return objectForKey(PFUser.Key.ForgotPasswordRequested) as? NSDate
        }
        set {
            setObject(newValue!, forKey: PFUser.Key.ForgotPasswordRequested)
        }
    }
    
    public var pendingNewCard: CardTemplate? {
        get {
            return objectForKey(Key.PendingNewCard) as? CardTemplate
        }
        set {
            if newValue != nil {
                setObject(newValue!, forKey: Key.PendingNewCard)
            } else {
                removeObjectForKey(Key.PendingNewCard)
            }
        }
    }
    
    public static var PasswordMinLength: Int {
        return 6
    }
}
