//
//  CardViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    var cardDataSource: CardDataSource!
    
    @IBOutlet weak var boxContainerView: UIView! {
        didSet {
            cardDataSource = UserDefaultsCardDataSource(key: "mycard", count: boxContainerView.subviews.count)
            
            for subView in boxContainerView.subviews {
                subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tappedBox:"))
            }
            
            updateUI()
        }
    }
    
    private func updateUI() {
        for (i, value) in enumerate(boxContainerView.subviews) {
            let subview = value as! UIView
            subview.backgroundColor = cardDataSource.isStamped(i) ? UIColor.redColor() : UIColor.blackColor()
        }
    }
    
    func tappedBox(gesture: UITapGestureRecognizer) {
        for (i, value) in enumerate(boxContainerView.subviews) {
            if gesture.view == value as? UIView {
                cardDataSource.stamp(i, stamped: !cardDataSource.isStamped(i))
                updateUI()
            }
        }
    }
    
}
