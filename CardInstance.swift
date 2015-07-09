//
//  CardInstance.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/7/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class CardInstance: PFObject, PFSubclassing
{
    
    // MARK: - Classname
    
    public static let ClassName = "CardInstance"
    
    public static func parseClassName() -> String {
        return self.ClassName
    }
    
    // MARK: - Keys
    
    private struct Key
    {
        static let User = "user"
        static let CardTemplate = "cardTemplate"
        static let IsArchived = "isArchived"
    }
    
    // MARK: - Properties
    
    public var user: PFUser! {
        get {
            return objectForKey(Key.User) as! PFUser
        }
        set {
            setObject(newValue, forKey: Key.User)
        }
    }
    
    public var cardTemplate: CardTemplate! {
        get {
            return objectForKey(Key.CardTemplate) as! CardTemplate
        }
        set {
            setObject(newValue, forKey: Key.CardTemplate)
        }
    }
    
    public var isArchived: Bool! {
        get {
            return objectForKey(Key.IsArchived) as! Bool
        }
        set {
            setObject(newValue, forKey: Key.IsArchived)
        }
    }
    
    // MARK: - Utilities
    
    public static func query(#user: PFUser) -> PFQuery {
        return PFQuery(className: self.ClassName).whereKey(Key.User, equalTo: user)
    }
}