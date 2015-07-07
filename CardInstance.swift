//
//  CardInstance.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/7/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class CardInstance: PFObject
{
    
    // MARK: - Classname
    
    private static let ClassName = "CardInstance"
    
    // MARK: - Static Initializers
    
    static func create(#user: PFUser, cardTemplate: CardTemplate) -> CardInstance {
        let cardInstance = CardInstance(className: self.ClassName)
        cardInstance.setObject(user, forKey: Key.User)
        cardInstance.setObject(cardTemplate, forKey: Key.CardTemplate)
        cardInstance.setObject(false, forKey: Key.IsArchived)
        return cardInstance
    }
    
    static func createAsArchived(cardInstance: CardInstance) -> CardInstance {
        cardInstance.setObject(true, forKey: Key.IsArchived)
        return cardInstance
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
        return objectForKey(Key.User) as! PFUser
    }
    
    public var cardTemplate: CardTemplate! {
        return objectForKey(Key.CardTemplate) as! CardTemplate
    }
    
    public var isArchived: Bool! {
        return objectForKey(Key.IsArchived) as! Bool
    }
}