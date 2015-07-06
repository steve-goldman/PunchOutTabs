//
//  ForgotPasswordViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/5/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController
{
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let PasswordRequested = "Password Reset Requested"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var controllerViewStyle: ControllerViewStyle!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        controllerViewStyle = ControllerViewStyle(viewController: self, params: ControllerViewStyle.ForgotPasswordParams)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controllerViewStyle.layoutViews()
    }
    
    // MARK: - Actions
    
    @IBAction func resetPasswordPressed()
    {
        let emailAddress = emailAddressField.text
        
        let result = SignUpValidator.validateEmail(emailAddress)
        if result.valid {
            activityIndicator.startAnimating()
            PFUser.requestPasswordResetForEmailInBackground(emailAddress) { (success, error) in
                self.activityIndicator.stopAnimating()
                if success {
                    self.performSegueWithIdentifier(SegueIdentifier.PasswordRequested, sender: nil)
                } else {
                    UIAlertView(title: "Could not request new password", message: "Something went wrong: \(error?.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        } else {
            UIAlertView(title: result.errorSection, message: result.errorMessage, delegate: nil, cancelButtonTitle: "Got it").show()
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SegueIdentifier.PasswordRequested {
            let destinationController = segue.displayController as! MyLogInViewController
            destinationController.alertView = UIAlertView(title: "Password reset requested", message: "Please check your email for instructions on resetting your password", delegate: nil, cancelButtonTitle: "Continue")
        }
    }

}
