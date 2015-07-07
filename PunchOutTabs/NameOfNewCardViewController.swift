//
//  NewCardViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class NameOfNewCardViewController: UIViewController, UITextFieldDelegate
{
    
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let Next = "Next"
        static let Cancel = "Cancel"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var cardNameField: UITextField! {
        didSet {
            cardNameField.delegate = self
            cardNameField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextPressed() {
        activityIndicator.startAnimating()
        PFCloud.callFunctionInBackground("nameOfNewCardNextPressed", withParameters: ["name": cardNameField.text]) { (result, error) in
            self.activityIndicator.stopAnimating()
            if result != nil {
                self.performSegueWithIdentifier(SegueIdentifier.Next, sender: nil)
            } else {
                UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == SegueIdentifier.Next {
            // nothing to do
        } else if segue.identifier == SegueIdentifier.Cancel {
            let tabBarController = segue.destinationViewController as! MustLoginTabBarController
            tabBarController.selectMyCards()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cardNameField.resignFirstResponder()
        nextPressed()
        return true
    }

}
