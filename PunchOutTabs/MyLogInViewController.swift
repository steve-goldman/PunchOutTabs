//
//  MyLoginViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/3/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class MyLogInViewController: UIViewController, UITextFieldDelegate
{
    
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let LoggedIn = "Logged In"
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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    private var controllerViewStyle: ControllerViewStyle!
    
    var alertView: UIAlertView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        controllerViewStyle = ControllerViewStyle(viewController: self, params: ControllerViewStyle.LoginParams)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controllerViewStyle.layoutViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if alertView != nil {
            alertView!.show()
            alertView = nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginPressed()
    {
        let username = usernameField.text
        let password = passwordField.text
        
        if count(username) == 0 || count(password) == 0 {
            UIAlertView(title: "Missing information", message: "Must supply username and password", delegate: nil, cancelButtonTitle: "Got it").show()
        } else {
            activityIndicator.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
                self.activityIndicator.stopAnimating()
                if user != nil {
                    self.performSegueWithIdentifier(SegueIdentifier.LoggedIn, sender: nil)
                } else {
                    UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.LoggedIn {
            // TODO: anything here?
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
            loginPressed()
        }
        return true
    }
}
