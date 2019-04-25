//
//  FiltersTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 11/20/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit

class FiltersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var conditionComboBox: ComboBox!
    @IBOutlet weak var operatorComboBox: ComboBox!
    @IBOutlet weak var valueText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
