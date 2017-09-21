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

protocol isOrderHeaderVc: class {
    func setComboBoxItemsSource()
    func initOrder()
    func selectedIndexChanged(_ sender: XuniComboBox!)
    func orderTypeChanged(orderType: OrderType)
    func getfilterPredicate(_ orderInventory: OrderInventory) -> Bool
    func getOrderInventoryService(_ order: isOrderType, credentials: [String :  String]) -> OrderSyncServiceType?
    func shipMonthSave()
    func shipMonthChanged()
}

class OrderHeaderViewController: DataGridViewController, ShipDateDelegate, XuniDropDownDelegate,XuniComboBoxDelegate,OrderInventoryErrorDelegate {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var shipDateButton: UIButton!
    @IBOutlet weak var headerComboBox: XuniComboBox!
    
    weak var order: isOrderType?
    
    
    @IBAction func unwindToOrderHeader(_ sender: UIStoryboardSegue){
        
    }
    
    func setComboBoxItemsSource() {
        // implement in child
    }
    
    func saveOrderDelegate() {
        try! order?.saveOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let orderTabBarController = tabBarController as! OrderTabBarController
        order = orderTabBarController.order
        setComboBoxItemsSource()
        guard headerComboBox.itemsSource != nil else {
            sendMessage(title: "Error", message: "No Ship-To Addresses Available")
            return
        }
        headerComboBox.displayMemberPath = "name"
        headerComboBox.isEditable = false
        headerComboBox.textFont = GridSettings.defaultFont
        headerComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        let listCount = headerComboBox.itemsSource.count > 6 ? 6 : headerComboBox.itemsSource.count
        headerComboBox.dropDownHeight = Double(listCount * Constants.ComboCellHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        flexGrid.invalidate()
        filterRefresh()
        isLoaded = true
    }
    
    override func filterRefresh(){
        let filterImage = flexGrid.hasFilters() ? UIImage(named: "Full Filters") : UIImage(named: "Clear Filters")
        filterGrid("")
        removeFilterButton.image = filterImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isLoaded {
            loadViews()
        }
        initOrder()
    }
    
    fileprivate func loadViews() {
        SwiftSpinner.show("Loading...", animated: false) {
            self.loadMyView()
            self.loadAllViews()
            self.loadSavedData()
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                self.sendOverSellAlert()
            }
        }
    }
    
    func sendOverSellAlert() {
        guard let count = order?.overSoldItems.characters.count else {
            return
        }
        if count > 0 {
            guard let overSoldList = order?.overSoldItems[(order?.overSoldItems.startIndex)!..<(order?.overSoldItems.characters.index((order?.overSoldItems.startIndex)!, offsetBy: count - 1))!] else {
                return
            }
            sendAlert(ErrorCode.noQuantity(itemCode: overSoldList))
        }
    }

    override func exitVc() {
        flexGrid.finishEditing(false)
        flexGrid.saveUserDefaults(moduleType)
        exitInventory()
        exitComboBox()
        super.exitVc()
    }
    
    
    fileprivate func exitInventory() {
        guard flexGrid.rows.count > 0 else {
            return
        }
        for index in 0...flexGrid.rows.count - 1 {
            let flexRow = flexGrid.rows.object(at: index)
            guard let inventory = flexRow.dataItem as? OrderInventory else {
                    continue
            }
            inventory.errorDelegate = nil
        }
    }
    
    fileprivate func exitComboBox() {
        headerComboBox.selectedItem = nil
        if headerComboBox.itemsSource != nil {
            headerComboBox.itemsSource.removeAllObjects()
            headerComboBox.collectionView.removeAllObjects()
        }
        headerComboBox.delegate = nil
        headerComboBox = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        flexGrid.finishEditing(false)
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showShipDateViewController" {
            guard let shipDateViewController = segue.destination as? ShipDateViewController else {
                return
            }
            shipDateViewController.order = order
            shipDateViewController.delegate = self
        }
        if segue.identifier == "showOrderNotesViewController" {
            guard let sampleOrderNotesViewController = segue.destination as? OrderNotesViewController else {
                return
            }
            sampleOrderNotesViewController.order = order
        }
    }
    
    
    func initOrder() {
        // implement in child
    }
    
    func groupCollapsedChanging(_ sender: FlexGrid!, panel: GridPanel!, forRange range: GridCellRange!) -> Bool {
        return true
    }
    
    func selectedIndexChanged(_ sender: XuniComboBox!) {
        // implement in child
    }
    
    func orderTypeChanged(orderType: OrderType) {
        // implement in child
    }
    
    fileprivate func loadSavedData() {
        guard let order = order else {
            return
        }
        if order.isSaved {
            orderTypeChanged(orderType: order.orderType)
            order.loadSavedLines()
            order.isSaved = false
        }
    }
    
    func beginningEdit(_ sender: FlexGrid!, panel: GridPanel!, forRange range: GridCellRange!) -> Bool {
        guard panel != nil else {
            return false
        }
        let flexRow = flexGrid.rows.object(at: UInt(range.row))
        guard let inventory = flexRow.dataItem as? OrderInventory else {
            return false
        }
        activeField = panel.getCellRect(forRow: range.row, inColumn: range.col)
        inventory.errorDelegate = self
        return false
    }
    
    func cellEditEnded(_ sender: FlexGrid!, panel: GridPanel!, forRange range: GridCellRange!) {
        activeField = nil
    }
    
    func loadAllViews() {
        autoreleasepool{
            let orderTabBarController = tabBarController as! OrderTabBarController
            if let myViewControllers = orderTabBarController.viewControllers {
                for viewController in myViewControllers {
                    if viewController.isKind(of: OrderInventoryViewController.self) || viewController.isKind(of: OrderHistoryViewController.self) {
                        _ = viewController.view
                    }
                }
            }}
    }
    
    func toggleShipDate() {
        shipDateButton.setTitle(order?.shipDate?.getShipDatePrint(), for: UIControlState())
        shipDateButton.isEnabled = order?.shipDate != nil
    }
    
    func getfilterPredicate(_ orderInventory: OrderInventory) -> Bool {
        // implement in child
        return false
    }
    
    
    override func filterGridColumns<T: NSObject>(_ searchText: String?, classType: T.Type, isIndex: Bool = false) {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        collectionView.filter = {(item : NSObject?) -> Bool in
            unowned let row = item as! OrderInventory
            return self.getfilterPredicate(row) && self.flexGrid.filterColumns(nil, row: row)
            } as IXuniPredicate
        resetGrid()
    }
    
    func loadMyView() {
        loadData(isSynched: false)
        loadGrid()
        filterGrid("")
    }
    
    override func initGrid() {
        super.initGrid()
        flexGrid.isReadOnly = false
    }
    
    func loadGrid() {
        guard let order = order else {
            completionError(ErrorCode.unknownError)
            return
        }
        if let collectionView = flexGrid.collectionView {
            collectionView.removeAllObjects()
        }
        if let itemsSource = flexGrid.itemsSource {
            itemsSource.removeAllObjects()
        }
        flexGrid.itemsSource = order.orderInventory
        loadGroup()
    }
    
    func loadGroup() {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        let gd: XuniPropertyGroupDescription = XuniPropertyGroupDescription(property: "groupKey")
        flexGrid.groupHeaderFormat = "Totals:"
        collectionView.groupDescriptions.add(gd)
    }
    
    func getOrderInventoryService(_ order: isOrderType, credentials: [String :  String]) -> OrderSyncServiceType? {
        // implement in child
        return nil
    }
    
    override func loadData(isSynched: Bool) {
        guard let order = order else {
            completionError(ErrorCode.unknownError)
            return
        }
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        order.orderInventory?.removeAllObjects()
        let orderInventoryServiceGet = getOrderInventoryService(order, credentials: credentials)
        guard let orderInventoryService = orderInventoryServiceGet else {
            completionError(ErrorCode.unknownError)
            return
        }
        let orderInventoryQuery = orderInventoryService.queryDb()
        order.orderInventory = orderInventoryQuery.gridData
        isManager = orderInventoryQuery.isManager
        if let orderInventorySearchData = orderInventoryQuery.searchData {
            order.searchData = orderInventorySearchData
        }
        let invLastSync = orderInventoryService.queryLastSync
        guard invLastSync != nil && order.orderInventory != nil else {
            guard !isSynched else {
                completionError(ErrorCode.dbError)
                return
            }
            syncData(orderInventoryService: orderInventoryService)
            return
        }
        gridData = order.orderInventory
        searchData = order.searchData
    }
    
    func clearChildControllers(_ myViewControllers: [UIViewController]) {
        for viewController in myViewControllers {
            if viewController.isKind(of: OrderInventoryViewController.self) {
                if let orderInventoryViewController = viewController as? OrderInventoryViewController {
                    if orderInventoryViewController.isViewLoaded {
                        orderInventoryViewController.clearGridSource()
                    }
                }
            }
            if viewController.isKind(of: OrderHistoryViewController.self) {
                if let orderInventoryViewController = viewController as? OrderHistoryViewController {
                    if orderInventoryViewController.isViewLoaded {
                        orderInventoryViewController.clearGridSource()
                    }
                }
            }
        }
    }
    
    func clearAllGridSource() {
        if let collectionView = flexGrid.collectionView {
            collectionView.removeAllObjects()
        }
        if let itemsSource = flexGrid.itemsSource {
            itemsSource.removeAllObjects()
        }
        let orderTabBarController = tabBarController as! OrderTabBarController
        guard let myViewControllers = orderTabBarController.viewControllers else {
            return
        }
        clearChildControllers(myViewControllers)
    }
    
    func setChildControllers(_ myViewControllers: [UIViewController]) {
        for viewController in myViewControllers {
            if viewController.isKind(of: OrderInventoryViewController.self) {
                if let orderInventoryViewController = viewController as? OrderInventoryViewController {
                    if orderInventoryViewController.isViewLoaded {
                        orderInventoryViewController.initData()
                        orderInventoryViewController.setGridSource()
                    }
                }
            }
            if viewController.isKind(of: OrderHistoryViewController.self) {
                if let orderInventoryViewController = viewController as? OrderHistoryViewController {
                    if orderInventoryViewController.isViewLoaded {
                        orderInventoryViewController.initData()
                        orderInventoryViewController.setGridSource()
                    }
                }
            }
        }
    }
    
    
    func setAllGridSource() {
        flexGrid.itemsSource = order?.orderInventory
        let orderTabBarController = tabBarController as! OrderTabBarController
        guard let myViewControllers = orderTabBarController.viewControllers else {
            return
        }
        setChildControllers(myViewControllers)
    }
    
    func shipMonthSave() {
        // implement in child
    }
    
    func shipMonthChanged() {
        // implement in child
    }
    
    
    func syncData(orderInventoryService: OrderSyncServiceType) {
        SwiftSpinner.show("Syncing...", animated: false)
        do {
            let lastInventorySync = try orderInventoryService.queryAllLastSync()
            orderInventoryService.getApi(lastInventorySync) {
                [unowned self](inventorySyncCompletion, error) in
                guard let inventorySync = inventorySyncCompletion else  {
                    self.completionError(error ?? ErrorCode.unknownError)
                    return
                }
                do {
                    try orderInventoryService.updateDb(inventorySync)
                } catch {
                    self.completionError(ErrorCode.dbError)
                }
                orderInventoryService.updateLastSync()
            }
        } catch {
            completionError(ErrorCode.dbError)
        }
    }
    
    
    fileprivate func transmitOrder() {
        guard let order = order else {
            return
        }
        guard let credentials = Credentials.getCredentials() else {
            completionError(ErrorCode.noCredentials)
            return
        }
        SwiftSpinner.show("Transmitting...", animated: false) {
            let orderService = OrderService(order: order, apiCredentials: credentials)
            do {
                try order.saveOrder()
                orderService.sendOrder() {
                    [unowned self](success, error) in
                    guard success else {
                        self.completionError(error ?? ErrorCode.noInternet)
                        return
                    }
                    orderService.depleteDb()
                    try! self.order?.deleteOrder()
                    DispatchQueue.main.async {
                        SwiftSpinner.hide(){
                            [unowned self] in
                            self.sendMessage(title: "Transmit Order", message: "Order Sent!")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    SwiftSpinner.hide() {
                        [unowned self] in
                        self.completionError(ErrorCode.dbError)
                    }
                }
            }
        }
    }
    
    
    fileprivate func deleteOrder() {
        SwiftSpinner.show("Deleting...", animated: false) {
            [unowned self] in
            DispatchQueue.main.async {
                [unowned self] in
                do {
                    try self.order?.deleteOrder()
                    SwiftSpinner.hide() {
                        [unowned self] in
                        self.sendMessage(title: "Delete Order", message: "Order Deleted!")
                    }
                } catch {
                    SwiftSpinner.hide() {
                        [unowned self] in
                        self.completionError(ErrorCode.dbError)
                    }
                }
            }
        }
    }
    
    fileprivate func cancelOrder() {
        let message = order?.orderNo == nil ? "Order Cancelled!" : "Changes Cancelled!"
        sendMessage(title: "Cancel", message: message)
    }
    
    fileprivate func saveOrder() {
        SwiftSpinner.show("Saving...", animated: false) {
            [unowned self] _ in
            DispatchQueue.main.async {
                [unowned self] in
                do {
                    try self.order?.saveOrder()
                    SwiftSpinner.hide() {
                        [unowned self] in
                        self.sendMessage(title: "Save Order", message: "Order Saved!")
                    }
                } catch {
                    SwiftSpinner.hide() {
                        [unowned self] in
                        self.completionError(ErrorCode.dbError)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if flexGrid != nil {
            flexGrid.finishEditing(false)
            flexGrid.saveUserDefaults(moduleType)
        }
        super.viewWillDisappear(animated)
    }
    
    override func showShareActionSheet(flexGrid: FlexGrid, moduleType: Module, sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Send Data", message: nil, preferredStyle: .actionSheet)
        let cancelTitle = "Cancel Order"
        let copyButton = UIAlertAction(title: "Copy", style: .default) {
            [unowned self] (alert) -> Void in
            self.copyData(flexGrid, moduleType: moduleType)
        }
        let emailButton = UIAlertAction(title: "Email", style: .default) {
            [unowned self] (alert) -> Void in
            self.emailData(flexGrid, moduleType: moduleType)
        }
        let transmitButton = UIAlertAction(title: "Transmit", style: .default) {
            [unowned self] (alert) -> Void in
            self.transmitOrder()
        }
        let saveButton = UIAlertAction(title: "Save", style: .default) {
            [unowned self] (alert) -> Void in
            self.saveOrder()
        }
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) {
            [unowned self] (alert) -> Void in
            self.deleteOrder()
        }
        let cancelOrderButton = UIAlertAction(title: cancelTitle, style: .destructive) {
            [unowned self] (alert) -> Void in
            self.cancelOrder()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {
            (alert) -> Void in
        }
        if flexGrid.selection.row >= 0 {
            actionSheet.addAction(copyButton)
        }
        if flexGrid.rows.count > 0 {
            actionSheet.addAction(emailButton)
            actionSheet.addAction(transmitButton)
            actionSheet.addAction(saveButton)
        }
        if order?.orderNo != nil {
            actionSheet.addAction(deleteButton)
        } else {
            actionSheet.addAction(cancelOrderButton)
        }
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(actionSheet, animated: true, completion: nil)
    } 
}
