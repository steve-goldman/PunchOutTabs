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

    // MARK: - Classname
    
    private static let ClassName = "CardTemplate"

    public static func parseClassName() -> String {
        return self.ClassName
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
    
    public var name: String! {
        get {
            return objectForKey(Key.Name) as! String
        }
        set {
            setObject(newValue, forKey: Key.Name)
        }
    }
    
    public var endDate: NSDate {
        get {
            return objectForKey(Key.EndDate) as! NSDate
        }
        set {
            setObject(newValue, forKey: Key.EndDate)
        }
    }
    
    // since we can't monitor a dictionary for changes to its contents, we'll
    // expose the type counts with these methods
    
    public func getTypes() -> [String] {
        return makeDict().keys.array
    }
    
    public func getCountForType(type: String) -> Int {
        return makeDict()[type]!
    }
    
    public func setType(type: String, count: Int) {
        var dict = makeDict()
        if (dict[type] != nil) {
            dict.updateValue(count, forKey: type)
        } else {
            dict[type] = count
        }
        setObject(makeArray(dict), forKey: Key.TypeCounts)
    }
    
    public func unsetType(type: String) {
        var dict = makeDict()
        dict[type] = nil
        setObject(makeArray(dict), forKey: Key.TypeCounts)
    }
    
    var isActive: Bool {
        get {
            return objectForKey(Key.IsActive) as! Bool
        }
        set {
            setObject(newValue, forKey: Key.IsActive)
        }
    }
    
    // MARK: - Utilities
    
    // TODO: must be a better way to do this
    private func makeDict() -> [String:Int] {
        var dict = [String:Int]()
        if let typeCounts = objectForKey(Key.TypeCounts) as? [String] {
            for typeCount in typeCounts {
                let tokens = typeCount.componentsSeparatedByString(":")
                dict[tokens[1]] = tokens[0].toInt()
            }
        }
        return dict
    }
    
    // TODO: must be a better way to do this
    private func makeArray(dict: [String:Int]) -> [String] {
        var typeCounts = [String]()
        for (type: String, count: Int) in dict {
            typeCounts.append("\(count):\(type)")
        }
        return typeCounts
    }
    
}