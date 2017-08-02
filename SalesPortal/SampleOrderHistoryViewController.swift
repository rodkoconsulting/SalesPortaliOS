//
//  SampleOrderHistoryViewController.swift
//  SalesPortal
//
//  Created by administrator on 2/13/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

class SampleOrderHistoryViewController: OrderHistoryViewController {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.sampleOrderHistory
        classType = SampleOrderInventory.self
    }
    
}
