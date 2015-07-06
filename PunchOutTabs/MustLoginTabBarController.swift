//
//  MustLoginTabBarController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/28/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class MustLoginTabBarController: UITabBarController
{
    
    override func viewDidAppear(animated: Bool) {
        // if not logged in, show the login screen
        if PFUser.currentUser() == nil {
            // present login controller
            performSegueWithIdentifier("Login", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Login" {
            // TODO: anything to do here?
        }
    }
    
    // MARK: - PFLogInViewControllerDelegate
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if count(username) != 0 && count(password) != 0 {
            return true
        }
        
        UIAlertView(title: "Missing information", message: "Must supply username and password", delegate: nil, cancelButtonTitle: "Got it").show()
        
        return false
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - PFSignUpViewControllerDelegate
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        
        let signupResult = SignUpValidator.validate(username: info["username"] as! String, password: info["password"] as! String, email: info["email"] as! String)
        
        if !signupResult.valid {
            UIAlertView(title: signupResult.errorSection, message: signupResult.errorMessage, delegate: nil, cancelButtonTitle: "Got it").show()
            return false
        }
        
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        UIAlertView(title: "Welcome to Punchy", message: "We're excited you're with us!", delegate: nil, cancelButtonTitle: "Continue").show()
        PFUser.logInWithUsername(user.username!, password: user.password!)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
