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
    private struct Constants
    {
        static let UsernameMinLength = 6
        static let UsernameMaxLength = 20
        static let UsernameRegex = "^([a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)*$"
        static let PasswordMinLength = 6
        static let EmailAddressRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    }
    
    public static let Username = "Username"
    public static let Password = "Password"
    public static let Email = "Email"

    public static func validate(#username: String, password: String, email: String) -> (valid: Bool, errorSection: String?, errorMessage: String?) {

        // uesrname must be of appropriate length and contents
        if count(username) < Constants.UsernameMinLength || count(username) > Constants.UsernameMaxLength {
            return (false, Username, "Username must be between \(Constants.UsernameMinLength) and \(Constants.UsernameMaxLength) characters")
        }
            
        if username.rangeOfString(Constants.UsernameRegex, options: .RegularExpressionSearch) == nil {
            return (false, Username, "Username must begin with a letter and contain only letters, numbers, and underscores")
        }
        
        // password must be long enough and not be all spaces
        if count(password) < Constants.PasswordMinLength || count(password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == 0 {
            return (false, Password, "Password must be at least \(Constants.PasswordMinLength) characters")
        }
        
        // email address must match the regex
        if email.rangeOfString(Constants.EmailAddressRegex, options: .RegularExpressionSearch) == nil {
            return (false, Email, "Email address must be valid")
        }

        return (true, nil, nil)
    }
}
