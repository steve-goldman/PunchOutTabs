//
//  MyLoginViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/3/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import ParseUI

class MyLogInViewController: PFLogInViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for now, you have to sign in to do anything, so there's no way to
        // dismiss this screen
        logInView?.dismissButton?.hidden = true
        
        var logoView = UIImageView(image: UIImage(named: "punchy_logo"))
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        
        logInView?.logo = logoView
    }
    
    override func viewDidLayoutSubviews() {
        logInView?.logo?.frame.origin.y = 100
    }
}
