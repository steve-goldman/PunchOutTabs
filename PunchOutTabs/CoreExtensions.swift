//
//  CoreExtensions.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

extension UIStoryboardSegue
{
    
    // MARK: - Properties
    
    var displayController: UIViewController {
        if let navController = destinationViewController as? UINavigationController {
            return navController.visibleViewController
        }
        
        return destinationViewController as! UIViewController
    }
    
}
