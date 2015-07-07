//
//  EndDateOfNewCardViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class EndDateOfNewCardViewController: UIViewController
{
    
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        static let Next = "Next"
    }
    
    private struct Delta
    {
        private static func daysToTimeInterval(days: Int) -> NSTimeInterval {
            return Double(days) * 24 * 60 * 60
        }
        
        static let Initial = Delta.daysToTimeInterval(7)
        static let Min = Delta.daysToTimeInterval(0)
        static let Max = Delta.daysToTimeInterval(365)
    }

    // MARK: - Properties
    
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            let now = NSDate()
            datePicker.date = now.dateByAddingTimeInterval(Delta.Initial)
            datePicker.minimumDate = now.dateByAddingTimeInterval(Delta.Min)
            datePicker.maximumDate = now.dateByAddingTimeInterval(Delta.Max)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextPressed() {
        // validation is handled by the UI (min and max date)
        
        // update the card template
        let cardTemplate = PFUser.currentUser()!.pendingNewCard
        PFUser.currentUser()!.pendingNewCard = CardTemplate.createWithEndDate(cardTemplate!, endDate: datePicker.date)
        activityIndicator.startAnimating()
        PFUser.currentUser()!.pendingNewCard!.saveInBackgroundWithBlock { (success, error) in
            self.activityIndicator.stopAnimating()
            if success {
                self.performSegueWithIdentifier(SegueIdentifier.Next, sender: nil)
            } else {
                UIAlertView(title: "Could not set end date", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.Next {
            // nothing to do here
        }
    }
}
