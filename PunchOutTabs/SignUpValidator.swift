//
//  SignUpValidator.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/28/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import Foundation

public class SignUpValidator
{
    
    // MARK: - Constants
    
    private struct Length
    {
        static let UsernameMin = 6
        static let UsernameMax = 20
        static let PasswordMin = 6
    }
    
    private struct Regex {
        static let Username = "^([a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)*$"
        static let EmailAddress = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    }
    
    public static let Username = "Username"
    public static let Password = "Password"
    public static let Email = "Email"
    
    // MARK: - Typealiases
    
    public typealias ValidatorResult = (valid: Bool, errorSection: String?, errorMessage: String?)

    // MARK: - Validators
    
    public static func validate(#username: String, password: String, email: String) -> ValidatorResult {

        // uesrname must be of appropriate length and contents
        if count(username) < Length.UsernameMin || count(username) > Length.UsernameMax {
            return (false, Username, "Username must be between \(Length.UsernameMin) and \(Length.UsernameMax) characters")
        }
            
        if username.rangeOfString(Regex.Username, options: .RegularExpressionSearch) == nil {
            return (false, Username, "Username must begin with a letter and contain only letters, numbers, and underscores")
        }
        
        // password must be long enough and not be all spaces
        if count(password) < Length.PasswordMin || count(password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            return (false, Password, "Password must be at least \(Length.PasswordMin) characters")
        }
        
        return SignUpValidator.validateEmail(email)
    }
    
    public static func validateEmail(email: String) -> ValidatorResult {
        
        // email address must match the regex
        if email.rangeOfString(Regex.EmailAddress, options: .RegularExpressionSearch) == nil {
            return (false, Email, "Email address must be valid")
        }
        
        return (true, nil, nil)
    }
}
