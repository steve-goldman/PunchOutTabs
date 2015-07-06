//
//  MustLoginTabBarController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/28/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class MustLoginTabBarController: UITabBarController
{
    
    // MARK: - Properties
    
    var alertView: UIAlertView?
    
    // MARK: - Constants
    
    private struct SegueIdentifier
    {
        private static let LogIn = "Log In"
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(animated: Bool)
    {
        if let user = PFUser.currentUser() {
            if alertView != nil {
                alertView!.show()
                alertView = nil
            }
        } else {
            // present login controller
            performSegueWithIdentifier(SegueIdentifier.LogIn, sender: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.LogIn {
            // TODO: anything to do here?
        }
    }
    
}
