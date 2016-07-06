//
//  OrderViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/3/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit

class OrderHeaderViewController: DataGridViewController, ShipDateDelegate {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var shipDateButton: UIButton!
    @IBOutlet weak var orderTypeButton: UIButton!
    
    weak var order: Order?
    
    @IBAction func unwindToOrderHeader(segue: UIStoryboardSegue){
        flexGrid.invalidate()
        filterGrid("")
        if let order = order {
            orderTypeButton.setTitle(order.orderType.rawValue, forState: .Normal)
        }
        
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.moduleType = Module.OrderHeader
//        self.classType = OrderInventory.self
//    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.moduleType = Module.OrderHeader
        self.classType = OrderInventory.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let orderTabBarController = self.tabBarController as! OrderTabBarController
        order = orderTabBarController.order
        initOrder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        flexGrid.invalidate()
        filterGrid("")
        isLoaded = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if isLoaded {
            initOrder()
        } else {
            SwiftSpinner.show("Loading...", animated: false) {
                _ in
                self.initGrid()
                self.loadMyView()
                self.loadAllViews()
                dispatch_async(dispatch_get_main_queue()) {
                    SwiftSpinner.hide()
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        flexGrid.finishEditing(false)
        flexGrid.saveUserDefaults(moduleType)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        flexGrid.finishEditing(false)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showShipDateViewController" {
            guard let shipDateViewController = segue.destinationViewController as? ShipDateViewController else {
                return
            }
            shipDateViewController.order = order
            shipDateViewController.delegate = self
        }
        if segue.identifier == "showOrderTypePickerViewController" {
            guard let orderTypePickerViewController = segue.destinationViewController as? OrderTypePickerViewController else {
                return
            }
            orderTypePickerViewController.order = order
            order?.errorDelegate = orderTypePickerViewController
        }
        if segue.identifier == "showOrderNotesViewController" {
            guard let orderNotesViewController = segue.destinationViewController as? OrderNotesViewController else {
                return
            }
            orderNotesViewController.order = order
        }
    }

    
    func initOrder() {
        guard let order = order else {
            return
        }
        accountLabel.text = order.account.customerName
        shipDateButton.setTitle(order.shipDate.getShipDatePrint(), forState: .Normal)
        orderTypeButton.setTitle(order.orderType.rawValue, forState: .Normal)
    }
    
    func beginningEdit(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!) -> Bool {
        activeField = panel.getCellRectForRow(range.row, inColumn: range.col)
        return false
    }
    
    func cellEditEnded(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!) {
        activeField = nil
    }
   
    func loadAllViews() {
        let orderTabBarController = self.tabBarController as! OrderTabBarController
        if let myViewControllers = orderTabBarController.viewControllers {
            for viewController in myViewControllers {
                if !viewController.isKindOfClass(OrderHeaderViewController) {
                    _ = viewController.view
                }
            }
        }
    }
    
    override func filterGridColumns<T: NSObject>(searchText: String?, classType: T.Type, isIndex: Bool = false) {
        flexGrid.collectionView.filter = {(item : NSObject?) -> Bool in
            let row = item as! OrderInventory
            return row.cases > 0 || row.bottles > 0
            } as IXuniPredicate
        resetGrid()
    }
    
    override func clearSelectedCells() {
        guard flexGrid.rows.count > 0 && flexGrid.columns.count > 0 else {
            return
        }
        flexGrid.selection = FlexCellRange(row: 0, col: 1)
        flexGrid.selection = FlexCellRange(row: 0, col: 0)
    }


    
    func loadMyView() {
        do {
            try DbOperation.databaseInit()
            loadData(isSynched: false)
            loadGrid()
            filterGrid("")
        } catch {
            sendAlert(ErrorCode.DbError)
        }
    }
    
    override func initGrid() {
        flexGrid.isReadOnly = false
        flexGrid.delegate = self
        flexGrid.gridLayout(moduleType)
    }
    
    func loadGrid() {
        guard let order = order else {
            completionError(ErrorCode.UnknownError)
            return
        }
        if flexGrid.collectionView != nil {
            flexGrid.collectionView.removeAllObjects()
        }
        if flexGrid.itemsSource != nil {
            flexGrid.itemsSource.removeAllObjects()
        }
        flexGrid.itemsSource = order.orderInventory
    }
    
    override func loadData(isSynched isSynched: Bool) {
        guard let order = order else {
            completionError(ErrorCode.UnknownError)
            return
        }
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        order.orderInventory?.removeAllObjects()
        let orderInventoryService = OrderInventoryService(module: moduleType, apiCredentials: credentials, date: order.shipDate, account: order.account)
        let orderInventoryQuery = orderInventoryService.queryDb
        order.orderInventory = orderInventoryQuery.gridData
        if let orderInventorySearchData = orderInventoryQuery.searchData {
            order.searchData = orderInventorySearchData
        }
        let invLastSync = orderInventoryService.queryLastSync
        guard invLastSync != nil && self.order?.orderInventory != nil else {
            guard !isSynched else {
                self.completionError(ErrorCode.DbError)
                return
            }
            self.syncInventory()
            return
        }
        gridData = order.orderInventory
        searchData = order.searchData
    }
    
    func clearAllGridSource() {
        order?.orderTotal = 0
        order?.mixPriceDict.removeAll()
        if flexGrid.collectionView != nil {
            flexGrid.collectionView.removeAllObjects()
        }
        if flexGrid.itemsSource != nil {
            flexGrid.itemsSource.removeAllObjects()
        }
        let orderTabBarController = self.tabBarController as! OrderTabBarController
        guard let myViewControllers = orderTabBarController.viewControllers else {
            return
        }
        for viewController in myViewControllers {
            if viewController.isKindOfClass(OrderInventoryViewController) {
                if let orderInventoryViewController = viewController as? OrderInventoryViewController {
                    if orderInventoryViewController.isViewLoaded() {
                        orderInventoryViewController.clearGridSource()
                    }
                }
            }
            if viewController.isKindOfClass(OrderHistoryViewController) {
                if let orderInventoryViewController = viewController as? OrderHistoryViewController {
                    if orderInventoryViewController.isViewLoaded() {
                        orderInventoryViewController.clearGridSource()
                    }
                }
            }
        }
    }

    func setAllGridSource() {
        flexGrid.itemsSource = order?.orderInventory
        let orderTabBarController = self.tabBarController as! OrderTabBarController
        guard let myViewControllers = orderTabBarController.viewControllers else {
            return
        }
        for viewController in myViewControllers {
            if viewController.isKindOfClass(OrderInventoryViewController) {
                if let orderInventoryViewController = viewController as? OrderInventoryViewController {
                    if orderInventoryViewController.isViewLoaded() {
                        orderInventoryViewController.setGridSource()
                    }
                }
            }
            if viewController.isKindOfClass(OrderHistoryViewController) {
                if let orderInventoryViewController = viewController as? OrderHistoryViewController {
                    if orderInventoryViewController.isViewLoaded() {
                        orderInventoryViewController.setGridSource()
                    }
                }
            }
        }
    }

    func shipMonthChanged() {
        guard let order = order else {
            return
        }
        SwiftSpinner.show("Loading...", animated: false) {
            _ in
            order.saveCurrentLines()
            self.loadData(isSynched: true)
            self.clearAllGridSource()
            self.setAllGridSource()
            order.loadSavedLines()
            self.filterGrid("")
            dispatch_async(dispatch_get_main_queue()) {
                SwiftSpinner.hide()
            }
        }
        
    }
    
    func syncInventory() {
        guard let order = order else {
            completionError(ErrorCode.UnknownError)
            return
        }
        guard let credentials = Credentials.getCredentials() else {
            self.displayLogIn()
            return
        }
        SwiftSpinner.show("Syncing...", animated: false)
        let orderInventoryService = OrderInventoryService(module: moduleType, apiCredentials: credentials, date: order.shipDate, account: order.account)
        do {
            let lastAllSync = try orderInventoryService.queryAllLastSync()
            orderInventoryService.getApi(lastAllSync) {
                (let inventorySyncCompletion, error) in
                guard let inventorySync = inventorySyncCompletion else  {
                    self.completionError(error ?? ErrorCode.UnknownError)
                    return
                }
                do {
                    try orderInventoryService.updateDb(inventorySync)
                } catch {
                    self.completionError(ErrorCode.DbError)
                }
                orderInventoryService.updateLastSync()
                self.loadData(isSynched: true)
            }
        } catch {
            self.completionError(ErrorCode.DbError)
        }
    }
    
}
