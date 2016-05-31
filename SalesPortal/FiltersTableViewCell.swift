//
//  FiltersTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 11/20/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit

class FiltersTableViewCell: UITableViewCell, UIPickerViewDelegate {

    @IBOutlet weak var conditionPicker: UIPickerView!
    @IBOutlet weak var operatorPicker: UIPickerView!
    @IBOutlet weak var valueText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
