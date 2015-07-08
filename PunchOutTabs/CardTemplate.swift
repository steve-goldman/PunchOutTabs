//
//  CardTemplate.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation
import Parse

public class CardTemplate: PFObject, PFSubclassing
{

    public static func parseClassName() -> String {
        return self.ClassName
    }
    
    // MARK: - Classname
    
    private static let ClassName = "CardTemplate"

    // MARK: - Tuple Struct
    private struct ClassesOfType
    {
        let count: Int
        let type: String
    }
    
    // MARK: - Static Initializers
    
    static func create(name: String) -> CardTemplate {
        let cardTemplate = CardTemplate(className: self.ClassName)
        cardTemplate.setObject(name, forKey: Key.Name)
        cardTemplate.setObject(false, forKey: Key.IsActive)
        return cardTemplate
    }
    
    static func createWithEndDate(cardTemplate: CardTemplate, endDate: NSDate) -> CardTemplate {
        cardTemplate.setObject(endDate, forKey: Key.EndDate)
        return cardTemplate
    }
    
    static func createWithTypeCount(cardTemplate: CardTemplate, type: String, count: Int) -> CardTemplate {
        if cardTemplate.typeCounts[type] != nil {
            cardTemplate.typeCounts.updateValue(count, forKey: type)
        } else {
            cardTemplate.typeCounts[type] = count
        }
        cardTemplate.typeCountsArray = CardTemplate.makeTypeCountsArray(cardTemplate.typeCounts)
        return cardTemplate
    }
    
    static func createWithRemoveTypeCount(cardTemplate: CardTemplate, type: String) -> CardTemplate {
        cardTemplate.typeCounts[type] = nil
        cardTemplate.typeCountsArray = CardTemplate.makeTypeCountsArray(cardTemplate.typeCounts)
        return cardTemplate
    }
    
    static func createAsActive(cardTemplate: CardTemplate) -> CardTemplate {
        cardTemplate.setObject(true, forKey: Key.IsActive)
        return cardTemplate
    }
    
    private static func makeTypeCount(#type: String, count: Int) -> String {
        return "\(count):\(type)"
    }
    
    private static func splitTypeCount(typeCount: String) -> (type: String, count: Int) {
        let tokens = typeCount.componentsSeparatedByString(":")
        return (type: tokens[1], count: tokens[0].toInt()!)
    }
    
    // MARK: - Keys
    
    private struct Key
    {
        static let Name = "name"
        static let EndDate = "endDate"
        static let TypeCounts = "typeCounts"
        static let IsActive = "isActive"
    }
    
    // TODO: make this dynamic
    public static let ClassTypes = [ "Any Class", "Barre", "Spin", "Yoga" ]
    
    // MARK: - Properties
    
    var name: String! {
        return objectForKey(Key.Name) as! String
    }
    
    var endDate: NSDate {
        return objectForKey(Key.EndDate) as! NSDate
    }
    
    private var typeCountsArray: [String] {
        get {
            let typeCountsArray = (objectForKey(Key.TypeCounts) as! [AnyObject]).map { $0 as! String }
            typeCounts = CardTemplate.makeDict(typeCountsArray)
            return typeCountsArray
        } set {
            typeCounts = CardTemplate.makeDict(newValue)
            if !newValue.isEmpty {
                setObject(newValue, forKey: Key.TypeCounts)
            } else {
                setObject(NSNull(), forKey: Key.TypeCounts)
            }
        }
    }
    
    var typeCounts = [String:Int]()
    
    var isActive: Bool {
        return objectForKey(Key.IsActive) as! Bool
    }
    
    public var anyClassKey: String {
        return CardTemplate.ClassTypes[0]
    }
    
    public var hasAnyClassKey: Bool {
        return typeCounts[anyClassKey] != nil
    }
    
    // MARK: - Utilities
    
    // TODO: must be a better way to do this
    private static func makeDict(typeCounts: [String]) -> [String:Int] {
        var dict = [String:Int]()
        for typeCount in typeCounts {
            let tuple = splitTypeCount(typeCount)
            dict[tuple.type] = tuple.count
        }
        return dict
    }
    
    // TODO: must be a better way to do this
    private static func makeTypeCountsArray(dict: [String:Int]) -> [String] {
        var typeCounts = [String]()
        for (type: String, count: Int) in dict {
            typeCounts.append(makeTypeCount(type: type, count: count))
        }
        return typeCounts
    }
    
}