//
//  BoolFiltersTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 12/16/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit

class BoolFiltersTableViewCell: UITableViewCell, UIPickerViewDelegate {
    
    @IBOutlet weak var operatorPicker: UIPickerView!
    @IBOutlet weak var conditionPicker: UIPickerView!
    @IBOutlet weak var boolPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
