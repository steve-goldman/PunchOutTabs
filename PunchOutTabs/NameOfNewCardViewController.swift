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
        let name = cardNameField.text
        
        let result = CardTemplateValidator.validate(name: name)
        if result.valid {
            // create a new card template and save it
            let cardTemplate = CardTemplate.create(name)
            activityIndicator.startAnimating()
            cardTemplate.saveInBackgroundWithBlock { (success, error) in
                self.activityIndicator.stopAnimating()
                if success {
                    // remove the previous card the user may have been working on
                    if PFUser.currentUser()!.pendingNewCard != nil {
                        PFUser.currentUser()!.pendingNewCard?.deleteInBackground()
                    }
                    
                    // associate the card with the user and save the user
                    PFUser.currentUser()!.pendingNewCard = cardTemplate
                    self.activityIndicator.startAnimating()
                    PFUser.currentUser()!.saveInBackgroundWithBlock { (success, error) in
                        self.activityIndicator.stopAnimating()
                        if success {
                            self.performSegueWithIdentifier(SegueIdentifier.Next, sender: nil)
                        } else {
                            UIAlertView(title: "Could not set name", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                        }
                    }
                } else {
                    UIAlertView(title: "Could not set name", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        } else {
            UIAlertView(title: result.errorSection, message: result.errorMessage, delegate: nil, cancelButtonTitle: "Got it").show()
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
