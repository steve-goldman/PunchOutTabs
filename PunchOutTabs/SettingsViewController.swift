//
//  SettingsViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController
{
    
    // MARK: - Constants
    
    private struct SegueIdentfier
    {
        static let LoggedOut = "Logged Out"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var loggedInAsField: UILabel! {
        didSet {
            loggedInAsField.text! += PFUser.currentUser()!.username!
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    private var controllerViewStyle: ControllerViewStyle!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerViewStyle = ControllerViewStyle(viewController: self, params: ControllerViewStyle.SettingsParams)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controllerViewStyle.layoutViews()
    }
    
    // MARK: - Actions

    @IBAction func logoutPressed() {
        activityIndicator.startAnimating()
        PFUser.logOutInBackgroundWithBlock { (error) in
            self.activityIndicator.stopAnimating()
            if error == nil {
                self.performSegueWithIdentifier(SegueIdentfier.LoggedOut, sender: nil)
            } else {
                UIAlertView(title: "Could not log out", message: "Something went wrong: \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Got it").show()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentfier.LoggedOut {
            let logInViewController = segue.displayController as! MyLogInViewController
            logInViewController.alertView = UIAlertView(title: "Goodbye", message: "You have been logged out", delegate: nil, cancelButtonTitle: "Continue")
        }
    }
}
