//
//  CardClassesOfTypeTableViewCell.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

class TypeCountsTableViewCell: UITableViewCell
{

    // MARK: - Properties
    
    var type: String? {
        didSet {
            typeLabel.text = type!
        }
    }
    
    var count: Int? {
        didSet {
            countLabel.text = "\(count!)"
        }
    }
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
}
