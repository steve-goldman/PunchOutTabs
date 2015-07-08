//
//  ForgotPasswordViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/5/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate
{
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let PasswordRequested = "Password Reset Requested"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var emailAddressField: UITextField! {
        didSet {
            emailAddressField.delegate = self
            emailAddressField.becomeFirstResponder()
        }
    }

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
        controllerViewStyle = ControllerViewStyle(viewController: self, params: ControllerViewStyle.ForgotPasswordParams)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controllerViewStyle.layoutViews()
    }
    
    // MARK: - Actions
    
    @IBAction func resetPasswordPressed()
    {
        activityIndicator.startAnimating()
        PFUser.requestPasswordResetForEmailInBackground(emailAddressField.text) { (success, error) in
            self.activityIndicator.stopAnimating()
            if success {
                self.performSegueWithIdentifier(SegueIdentifier.PasswordRequested, sender: nil)
            } else {
                UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
            }
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
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailAddressField.resignFirstResponder()
        resetPasswordPressed()
        return true
    }

}
