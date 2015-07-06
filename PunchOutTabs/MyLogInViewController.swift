//
//  MyLoginViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/3/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class MyLogInViewController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        passwordField.secureTextEntry = true
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func loginPressed()
    {
        let username = usernameField.text!
        let password = passwordField.text!
        
        if count(username) == 0 || count(password) == 0 {
            UIAlertView(title: "Missing information", message: "Must supply username and password", delegate: nil, cancelButtonTitle: "Got it").show()
        } else {
            activityIndicator.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
                self.activityIndicator.stopAnimating()
                if user != nil {
                    self.performSegueWithIdentifier("LoggedIn", sender: nil)
                } else {
                    UIAlertView(title: "Could not log in", message: "Something went wrong: \(error?.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        }
    }
    
    
    @IBAction func forgotPasswordPressed() {
        
    }
    
    @IBAction func signUpButtonPressed() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LoggedIn" {
            // TODO: anything here?
        }
    }
}
