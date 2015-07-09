//
//  CardViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class CardViewController: UIViewController
{

    //
    // MARK: - Properties
    //
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            if cardTemplate == nil {
                activityIndicator.startAnimating()
            }
        }
    }
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var cardTemplate: CardTemplate!
    
    var cardInstance: CardInstance! {
        didSet {
            activityIndicator?.startAnimating()
            cardTemplate = PFObject(withoutDataWithClassName: CardTemplate.ClassName, objectId: cardInstance.cardTemplate.objectId) as! CardTemplate
            cardTemplate.fetchIfNeededInBackgroundWithBlock { [unowned self] (cardTemplate, error) -> Void in
                self.activityIndicator?.stopAnimating()
                if cardTemplate != nil {
                    // TODO: is this closure capture?? -- fix if so
                    self.navTitle.title = self.cardTemplate.name
                } else {
                    UIAlertView(title: "Oops...", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "Got it").show()
                }
            }
        }
    }
    
    var index: Int!
    
    //
    // MARK: - Lifecycle
    //
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
}
