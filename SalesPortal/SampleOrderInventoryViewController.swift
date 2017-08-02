//
//  SampleOrderInventoryViewController.swift
//  SalesPortal
//
//  Created by administrator on 2/13/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

class SampleOrderInventoryViewController: OrderInventoryViewController {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.sampleOrderInventory
        classType = SampleOrderInventory.self
    }
    
    override func setTitleLabel() {
        if let order = order, let credentials = Credentials.getCredentials() {
            let state = credentials["state"] ?? "Y"
            let stateText = States(rawValue: state)?.labelText() ?? "NY"
            let orderMonth = order.shipDate?.getDate()?.getMonthString() ?? Date().getMonthString()
            titleLabel.text = stateText + " " + orderMonth
        }
    }
    
}
