//
//  AccountOrderInventoryViewController.swift
//  SalesPortal
//
//  Created by administrator on 2/7/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

class AccountOrderInventoryViewController: OrderInventoryViewController, isOrderInventoryVc {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.accountOrderInventory
        classType = AccountOrderInventory.self
    }

    
    override func setTitleLabel() {
        if let order = order, let account = order.account {
            let accountState = account.priceLevel
            let orderMonth = order.shipDate?.getDate()?.getMonthString() ?? Date().getMonthString()
            titleLabel.text = accountState.labelText() + " " + orderMonth
        }
    }
    
    override func setAccountInventoryDelegate(_ orderInventory: OrderInventory) {
        if let accountOrderInventory = orderInventory as? AccountOrderInventory,
            let accountOrder = order as? AccountOrder {
            accountOrderInventory.delegate = accountOrder
            accountOrderInventory.orderType = order?.orderType
        }
    }
    
}
