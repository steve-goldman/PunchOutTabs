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
    
    @IBOutlet weak var centerLabel: UILabel!
    
    private var cardBoxViewManager: TwoTwoByTwoCardBoxViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardDataSource = UserDefaultsCardDataSource(key: "mycard", count: TwoTwoByTwoCardBoxViewManager.NumBoxes)

        var i = 0
        
        cardBoxViewManager = TwoTwoByTwoCardBoxViewManager(parentView: view, forceSquare: true) {
            let index = i++
            let cardBoxView = CardBoxView.create(index: index)
            cardBoxView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cardBoxTapped:"))
            cardBoxView.stamped = self.cardDataSource.isStamped(index)
            return cardBoxView
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardBoxViewManager.update(index: 0, frame: CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: centerLabel.frame.minY - topLayoutGuide.length))
        
        cardBoxViewManager.update(index: 1, frame: CGRect(x: 0, y: centerLabel.frame.maxY, width: view.frame.width, height: view.frame.maxY - bottomLayoutGuide.length - centerLabel.frame.maxY))
    }
    
    func cardBoxTapped(gesture: UITapGestureRecognizer) {
        let cardBoxView = gesture.view as! CardBoxView
        if cardBoxView.contains(gesture.locationInView(cardBoxView)) {
            let stamped = !cardDataSource.isStamped(cardBoxView.index)
            cardDataSource.stamp(cardBoxView.index, stamped: stamped)
            cardBoxView.stamped = stamped
            performSegueWithIdentifier("Stamp", sender: self)
        }
    }
    
}
