
import UIKit
import XuniFlexGridKit
import MessageUI

class InventoryViewController: DataGridViewController, InventoryDataSettingsDelegate, ColumnsDelegate  {
    
    var dataSettings: InventoryDataSettings?

    @IBAction func refreshGrid(sender: AnyObject) {
        if let dataSettings = dataSettings {
          dataSettings.refreshDates()  
        }
        syncInventory()
    }
    
    @IBAction func unwindFromLogin(segue: UIStoryboardSegue){
        displayView()
    }
    
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.moduleType = Module.Inventory
//        self.classType = Inventory.self
//    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.moduleType = Module.Inventory
        self.classType = Inventory.self
    }
    
    func changedDataSettings() {
        setTitleLabel()
        isSettingsChanged = true
    }
    
    func changedStateSettings() {
        if let dataSettings = dataSettings {
            Credentials.saveStateCredentials(state: dataSettings.repState)
        }
    }
    
    override func setTitleLabel() {
        if let dataSettings = dataSettings {
           titleLabel.text = "\(dataSettings.repState) \(dataSettings.month) pricing"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettingsViewController" {
            guard let settingsViewController = segue.destinationViewController as? InventorySettingsViewController else {
                return
            }
            settingsViewController.dataSettings = dataSettings
            isSettingsChanged = false
        }
        if segue.identifier == "showColumnsViewController" {
            guard let columnsViewController = segue.destinationViewController as? ColumnsViewController else {
                return
            }
            columnsViewController.columnsDelegate = self
            columnsViewController.columnSettings = flexGrid.columns
            columnsViewController.module = moduleType
        }
        if segue.identifier == "showFiltersViewController" {
            segueFiltersViewController(segue: segue, sender: sender)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = self.tabBarController as? MainTabBarController
        dataSettings = mainViewController?.inventoryDataSettings
        gridData = mainViewController?.inventory
        if let dataSettings = dataSettings {
            dataSettings.delegate = self
        }
        flexGrid.isReadOnly = true
        flexGrid.alternatingRowBackgroundColor = GridSettings.alternatingRowBackgroundColor
        flexGrid.gridLinesVisibility = GridSettings.gridLinesVisibility
        flexGrid.selectionMode = GridSettings.defaultSelectionMode
        flexGrid.delegate = self
        setTitleLabel()
        gridColumnLayout()
        //flexGrid.itemsSource = inventory
        longPressInitialize()
        //SwiftSpinner.show("Loading...", animated: false) {
        //    _ in
            self.displayView()
        //}
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isSettingsChanged {
           loadingData(true)
        } else if isFilterChanged {
            filterRefresh()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        flexGrid.saveUserDefaults(moduleType)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    func displayView() {
        do {
            try DbOperation.databaseInit()
            loadData(isSynched: false)
        } catch {
            sendAlert(ErrorCode.DbError)
        }
    }

    
    override func loadData(isSynched isSynched: Bool) {
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        guard let dataSettings = dataSettings else {
            self.completionError(ErrorCode.DbError)
            return
        }
        gridData?.removeAllObjects()
        let inventoryService = InventoryService(module: moduleType, apiCredentials: credentials, date: dataSettings.date)
        let inventoryQuery = inventoryService.queryDb
        gridData = inventoryQuery.gridData
        if let inventorySearchData = inventoryQuery.searchData {
            searchData = inventorySearchData
        }
        let invLastSync = inventoryService.queryLastSync
        guard invLastSync != nil && self.gridData != nil else {
            guard !isSynched else {
                self.completionError(ErrorCode.DbError)
                return
            }
            self.syncInventory()
            return
        }
        if flexGrid.collectionView != nil {
            flexGrid.collectionView.removeAllObjects()
        }
        if flexGrid.itemsSource != nil {
            flexGrid.itemsSource.removeAllObjects()
        }
        self.flexGrid.itemsSource = gridData
        //flexGrid.collectionView.removeAllObjects()
        //flexGrid.collectionView = nil
        //self.flexGrid.itemsSource.removeAllObjects()
        //self.flexGrid.itemsSource = nil
        
        
        //inventory?.removeAllObjects()
        //inventory = nil
        self.isFilterChanged = false
        self.filterGridColumns(self.searchBar.text!, classType: classType)
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.hide()
        }
        
    }
    
    func syncInventory() {
        guard let credentials = Credentials.getCredentials(), let credentialState = credentials["state"] else {
            self.displayLogIn()
            return
        }
        guard let dataSettings = dataSettings else {
            completionError(ErrorCode.UnknownError)
            return
        }
        dataSettings.repState = "N\(credentialState)"
        SwiftSpinner.show("Syncing...", animated: false)
        let inventoryService = InventoryService(module: moduleType, apiCredentials: credentials, date: dataSettings.date)
        do {
            let lastAllSync = try inventoryService.queryAllLastSync()
            inventoryService.getApi(lastAllSync) {
                (let inventorySyncCompletion, error) in
                guard let inventorySync = inventorySyncCompletion else  {
                    self.completionError(error ?? ErrorCode.UnknownError)
                    return
                }
                do {
                    try inventoryService.updateDb(inventorySync)
                } catch {
                    self.completionError(ErrorCode.DbError)
                }
                //let invLastSync = NSDate().getDateTimeString()
                inventoryService.updateLastSync()
                self.loadData(isSynched: true)
            }
        } catch {
            self.completionError(ErrorCode.DbError)
        }
        isSettingsChanged = false
    }

    
}