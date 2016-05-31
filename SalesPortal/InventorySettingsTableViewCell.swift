//
//  SettingsTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 10/9/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit

class InventorySettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsLabel: UILabel!                                                                                                              
    @IBOutlet weak var settingsPicker: UIPickerView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
