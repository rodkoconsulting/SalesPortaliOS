//
//  BoolFiltersTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 12/16/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit

class BoolFiltersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var operatorComboBox: XuniComboBox!
    @IBOutlet weak var conditionComboBox: XuniComboBox!
    @IBOutlet weak var boolComboBox: XuniComboBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
