//
//  LeaderboardTableViewCell.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/25/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var tallyLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setElement(element: LeaderboardElement) {
        nameLabel?.text = element.name
        tallyLabel?.text = "\(element.tally)"
    }
}
