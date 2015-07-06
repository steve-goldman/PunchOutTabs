//
//  MySignUpViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/5/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class MySignUpViewController: UIViewController
{
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let SignedUp = "Signed Up"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var usernameField: UITextField! {
        didSet {
            usernameField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.secureTextEntry = true
        }
    }
    
    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
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
        let username = usernameField.text
        let password = passwordField.text
        let emailAddress = emailAddressField.text
        
        let result = SignUpValidator.validate(username: username, password: password, email: emailAddress)
        if result.valid {
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = emailAddress
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
                            UIAlertView(title: "Could not log in", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                        }
                    }
                } else {
                    UIAlertView(title: "Could not sign up", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        } else {
            UIAlertView(title: result.errorSection, message: result.errorMessage, delegate: nil, cancelButtonTitle: "Got it").show()
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.SignedUp {
            let destinationController = segue.displayController as! MustLoginTabBarController
            destinationController.alertView = UIAlertView(title: "Welcome to Punchy", message: "We're excited you're with us!", delegate: nil, cancelButtonTitle: "Continue")
        }
    }

}
