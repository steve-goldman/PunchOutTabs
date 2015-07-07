//
//  CardTemplateValidator.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

public class CardTemplateValidator
{
    
    // MARK: - Constants
    
    private struct Length
    {
        static let NameMin = 4
        static let NameMax = 32
    }
    
    private struct Bound
    {
        static let CountMin = 1
        static let CountMax = 999
    }
    
    public static let Name = "Name"
    public static let TypeCount = "Type Count"
    
    // MARK: - Typealiases
    
    public typealias ValidatorResult = (valid: Bool, errorSection: String?, errorMessage: String?)
    
    // MARK: - Validators
    
    public static func validate(#name: String) -> ValidatorResult {
        
        if count(name) < Length.NameMin || count(name) > Length.NameMax {
            return (false, Name, "Name must be between \(Length.NameMin) and \(Length.NameMax) characters")
        }
        
        // TODO: think about name uniqueness
        
        return (true, nil, nil)
    }
    
    public static func validate(cardTemplate: CardTemplate, type: String, count: Int) -> ValidatorResult {
        
        if !cardTemplate.typeCounts.isEmpty {

            if (type == cardTemplate.anyClassKey && !cardTemplate.hasAnyClassKey) || (type != cardTemplate.anyClassKey && cardTemplate.hasAnyClassKey) {
                return (false, TypeCount, "If '\(cardTemplate.anyClassKey)' is included, nothing else may be")
            }
        }
        
        if count < Bound.CountMin || count > Bound.CountMax {
            return (false, TypeCount, "Number of classes must be between \(Bound.CountMin) and \(Bound.CountMax)")
        }
        
        return (true, nil, nil)
    }
    
    public static func validate(cardTemplate: CardTemplate) -> ValidatorResult {
        
        if cardTemplate.typeCounts.isEmpty {
            return (false, TypeCount, "Add at least one number of classes for a type of class")
        }
        
        return (true, nil, nil)
    }
}
