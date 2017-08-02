//
//  DateFiltersTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 12/14/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit


class DateFiltersTableViewCell: UITableViewCell {

    @IBOutlet weak var operatorComboBox: XuniComboBox!
    @IBOutlet weak var conditionComboBox: XuniComboBox!
    @IBOutlet weak var dateButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
