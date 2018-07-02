//
//  SampleOrderHeaderViewController.swift
//  SalesPortal
//
//  Created by administrator on 2/6/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import XuniInputKit

class SampleOrderHeaderViewController: OrderHeaderViewController, isOrderHeaderVc {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.sampleOrder
        classType = SampleOrderInventory.self
    }
    
    override func setComboBoxItemsSource() {
        guard let shipToList = order?.shipToList else {
            return
        }
        headerComboBox.delegate = self
        headerComboBox.itemsSource = ComboData.addressData(shipToList)
    }
    
    override func shipMonthSave() {
        guard let accountOrder = order as? SampleOrder else {
            return
        }
        accountOrder.saveCurrentLines()
    }
    
    override func shipMonthChanged() {
        SwiftSpinner.show("Loading...", animated: false) {
            self.shipMonthSave()
            self.loadData(isSynched: true)
            self.clearAllGridSource()
            self.order?.loadSavedLines()
            self.setAllGridSource()
            self.loadGroup()
            self.filterGrid("")
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
        }
    }
        
    override func initOrder() {
        accountLabel.text = "Sample Order"
        shipDateButton.setTitle(order?.shipDate?.getShipDatePrint(), for: UIControlState())
        if let shipToList = order?.shipToList as? [SampleOrderAddress], let shipTo = order?.shipTo as? SampleOrderAddress, let shipToIndex = shipToList.index(of: shipTo) {
            headerComboBox.selectedIndex = UInt(shipToIndex)
        }
    }
    
    override func selectedIndexChanged(_ sender: XuniComboBox!) {
        flexGrid.finishEditing(false)
        guard let order = order, let shipToList = order.shipToList else {
            return
        }
        let index = Int(sender.selectedIndex)
        order.shipTo = shipToList[index]
    }
    
    override func getfilterPredicate(_ orderInventory: OrderInventory) -> Bool {
        return orderInventory.bottles > 0
    }
    
    override func getOrderInventoryService(_ order: isOrderType, credentials: [String :  String]) -> OrderSyncServiceType? {
        let shipDate = order.shipDate ?? OrderType.Standard.shipDate(account: nil)
        return SampleOrderInventoryService(module: moduleType, apiCredentials: credentials, date: shipDate!)
    }
    
}
