//
//  MySignUpViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/5/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class MySignUpViewController: UIViewController, UITextFieldDelegate
{
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let SignedUp = "Signed Up"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var usernameField: UITextField! {
        didSet {
            usernameField.delegate = self
            usernameField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.delegate = self
            passwordField.secureTextEntry = true
        }
    }
    
    @IBOutlet weak var emailAddressField: UITextField! {
        didSet {
            emailAddressField.delegate = self
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var controllerViewStyle: ControllerViewStyle!
    
    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        controllerViewStyle = ControllerViewStyle(viewController: self, params: ControllerViewStyle.SignUpParams)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controllerViewStyle.layoutViews()
    }
    
    // MARK: - Actions

    @IBAction func signUpPressed()
    {
        let password = passwordField.text
        
        // need to handle password validation outside of parse cloud
        if (count(password) < PFUser.PasswordMinLength || password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty) {
            UIAlertView(title: "Oops...", message: "Password must be at least \(PFUser.PasswordMinLength) characters", delegate: nil, cancelButtonTitle: "Got it").show()
            return
        }
        
        let username = usernameField.text

        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.email = emailAddressField.text
        activityIndicator.startAnimating()
        newUser.signUpInBackgroundWithBlock { (success, error) in
            self.activityIndicator.stopAnimating()
            if success {
                self.activityIndicator.startAnimating()
                PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
                    self.activityIndicator.stopAnimating()
                    if user != nil {
                        self.performSegueWithIdentifier(SegueIdentifier.SignedUp, sender: nil)
                    } else {
                        UIAlertView(title: "Oops...", message: "Could not log in: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                    }
                }
            } else {
                UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SignedUp {
            let destinationController = segue.displayController as! MustLoginTabBarController
            destinationController.alertView = UIAlertView(title: "Welcome to Punchy", message: "We're excited you're with us!", delegate: nil, cancelButtonTitle: "Continue")
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            emailAddressField.becomeFirstResponder()
        } else if textField == emailAddressField {
            emailAddressField.resignFirstResponder()
            signUpPressed()
        }
        return true
    }
}
