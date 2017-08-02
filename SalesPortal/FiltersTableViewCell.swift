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
    
    @IBOutlet weak var conditionComboBox: XuniComboBox!
    @IBOutlet weak var operatorComboBox: XuniComboBox!
    @IBOutlet weak var valueText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
