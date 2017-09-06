//
//  OrderViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/3/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit
import XuniInputKit

class AccountOrderHeaderViewController: OrderHeaderViewController, OrderDelegate, isOrderHeaderVc {

    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.accountOrder
        classType = OrderInventory.self
    }
    
    override func exitVc() {
        exitOrder()
        super.exitVc()
    }
    
    
    fileprivate func exitOrder() {
        if let accountOrder = order as? AccountOrder {
            accountOrder.orderDelegate = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let accountOrder = order as? AccountOrder {
            accountOrder.orderDelegate = self
        }
    }
    
    override func setComboBoxItemsSource() {
        headerComboBox.delegate = self
        headerComboBox.itemsSource = ComboData.orderTypeData()
    }

    
    override func initOrder() {
        accountLabel.text = order?.account?.customerName
        shipDateButton.setTitle(order?.shipDate?.getShipDatePrint(), for: UIControlState())
        if let orderTypeIndex = order?.orderType.getIndex {
           headerComboBox.selectedIndex = UInt(orderTypeIndex)
        }
    }
    
    override func selectedIndexChanged(_ sender: XuniComboBox!) {
        let index = Int(sender.selectedIndex)
        let rawValue = OrderType.rawValues[index]
        if let orderType = OrderType(rawValue: rawValue) {
            order?.orderType = orderType
        }
    }
    
    override func shipMonthChanged() {
        SwiftSpinner.show("Loading...", animated: false) {
            [unowned self] _ in
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

    override func orderTypeChanged(orderType: OrderType) {
        toggleNonBillHoldViews(enabled: orderType != .BillHold)
        toggleMoboView(enabled: orderType == .Standard || orderType == .BillHold)
        toggleShipDate()
        flexGrid.invalidate()
        filterGrid("")
    }
    
    fileprivate func toggleNonBillHoldViews(enabled: Bool) {
        let orderTabBarController = tabBarController as! OrderTabBarController
        if let myViewControllers = orderTabBarController.viewControllers {
            for viewController in myViewControllers {
                if viewController.isKind(of: OrderInventoryViewController.self) {
                    if let myViewController = viewController as? OrderInventoryViewController {
                        myViewController.myTabBarItem.isEnabled = enabled
                    }
                }
                if viewController.isKind(of: OrderHistoryViewController.self) {
                    if let myViewController = viewController as? OrderHistoryViewController {
                        myViewController.myTabBarItem.isEnabled = enabled
                    }
                }
            }
        }
    }
    
    fileprivate func toggleMoboView(enabled: Bool) {
        let orderTabBarController = tabBarController as! OrderTabBarController
        if let myViewControllers = orderTabBarController.viewControllers {
            for viewController in myViewControllers {
                if viewController.isKind(of: OrderMobosViewController.self) {
                    if let myViewController = viewController as? OrderMobosViewController {
                        myViewController.myTabBarItem.isEnabled = enabled
                    }
                }
            }
        }
    }

    override func getfilterPredicate(_ orderInventory: OrderInventory) -> Bool {
        return orderInventory.cases > 0 || orderInventory.bottles > 0
    }

    override func getOrderInventoryService(_ order: isOrderType, credentials: [String :  String]) -> OrderSyncServiceType? {
        guard let account = order.account else {
            return nil
        }
        let shipDate = order.shipDate ?? Date().getNextShip(account.shipDays).shipDate
        return AccountOrderInventoryService(module: moduleType, apiCredentials: credentials, date: shipDate, account:account)
    }

    override func loadData(isSynched: Bool) {
        super.loadData(isSynched: isSynched)
        loadMobos()
    }
    
    fileprivate func loadMobos() {
        guard let accountOrder = order as? AccountOrder,
            let account = accountOrder.account else {
                completionError(ErrorCode.unknownError)
                return
        }
        guard accountOrder.orderMobos == nil else {
            return
        }
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        let orderMoboService = OrderMoboService(module: Module.orderMobos, apiCredentials: credentials, account: account)
        let orderMoboQuery = orderMoboService.queryDb()
        accountOrder.orderMobos = orderMoboQuery.gridData
        if let orderMoboSearchData = orderMoboQuery.searchData {
            accountOrder.moboSearchData = orderMoboSearchData
        }
    }
    
    
    override func clearAllGridSource() {
        guard let accountOrder = order as? AccountOrder else {
                return
        }
        accountOrder.orderTotal = 0
        accountOrder.mixPriceDict.removeAll()
        super.clearAllGridSource()
    }
    
    override func shipMonthSave() {
        guard let accountOrder = order as? AccountOrder else {
            return
        }
        accountOrder.saveCurrentLines()
        accountOrder.saveMoboList()
    }

}
