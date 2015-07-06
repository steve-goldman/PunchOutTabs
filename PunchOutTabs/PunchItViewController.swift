//
//  PunchItViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

class PunchItViewController: UIViewController
{
    
    // MARK: - Properties
    
    private var controllerViewStyle: ControllerViewStyle!
    
    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        controllerViewStyle = ControllerViewStyle(viewController: self, params: ControllerViewStyle.PunchItParams)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controllerViewStyle.layoutViews()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}
