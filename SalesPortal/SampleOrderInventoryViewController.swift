//
//  SampleOrderInventoryViewController.swift
//  SalesPortal
//
//  Created by administrator on 2/13/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation
import XuniFlexGridKit

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
    
    override func filterGridColumns<T: NSObject>(_ searchText: String?, classType: T.Type, isIndex: Bool = false) {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        collectionView.filter = {[unowned self](item : NSObject?) -> Bool in
            guard let row = item as? SampleOrderInventory else {
                return false
            }
            guard !isIndex else {
                return self.flexGrid.filterIndex(searchText, row: row, moduleType: self.moduleType) && self.flexGrid.filterColumns(nil, row: row)
            }
            return self.flexGrid.filterColumns(searchText, row: row)
            } as IXuniPredicate
        resetGrid()
    }
    
}
