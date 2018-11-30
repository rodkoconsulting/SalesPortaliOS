import UIKit
import XuniFlexGridKit
import MessageUI

class InventoryViewController: DataGridViewController, InventoryDataSettingsDelegate {
    
    weak var dataSettings: InventoryDataSettings?

    @IBAction func refreshGrid(_ sender: AnyObject) {
        if let dataSettings = dataSettings {
          dataSettings.refreshDates()  
        }
        syncInventory()
    }
    
    @IBAction func unwindFromLogin(_ segue: UIStoryboardSegue){
        displayView()
    }
    
    
    @IBAction func unwindFromSettings(_ segue: UIStoryboardSegue) {
        
    }
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.inventory
        classType = Inventory.self
    }
    
    func changedDataSettings() {
        setTitleLabel()
        isSettingsChanged = true
    }
    
    func changedStateSettings() {
        if let dataSettings = dataSettings {
            Credentials.saveStateCredentials(state: dataSettings.repState.rawValue)
        }
    }
    
    override func setTitleLabel() {
        if let dataSettings = dataSettings {
           titleLabel.text = dataSettings.repState.labelText() + " " + dataSettings.month
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showSettingsViewController" {
            guard let settingsViewController = segue.destination as? InventorySettingsViewController else {
                return
            }
            settingsViewController.dataSettings = dataSettings
            isSettingsChanged = false
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginBackgroundTask()
        SwiftSpinner.show("Loading...", animated: false) {
            [unowned self] () -> Void in
            do {
                try _ = DbOperation.databaseInit()
            } catch {
                self.sendAlert(ErrorCode.dbError)
            }
            self.setTitleLabel()
            self.displayView()
        }
    }
    
    override func loadSettings() {
        let mainViewController = tabBarController as? MainTabBarController
        dataSettings = mainViewController?.inventoryDataSettings
        if let dataSettings = dataSettings {
            dataSettings.delegate = self
        }
        gridData = mainViewController?.inventory
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isSettingsChanged {
           loadingData(true)
        } else if isFilterChanged {
            filterRefresh()
        }
        isSettingsChanged = false
    }
    
    override func setItemLabels(selectedRow: Int32) {
        guard selectedRow >= 0 && UInt(selectedRow) < flexGrid.rows.count else {
            return
        }
        let flexRow = flexGrid.rows.object(at: UInt(selectedRow))
        guard let inventory = flexRow.dataItem as? Inventory else {
            return
        }
        if descriptionLabel != nil {
            descriptionLabel.text = inventory.itemDescription
            restrictionLabel.text = inventory.restrictedList
        }
    }
    
    override func clearItemLabels() {
        descriptionLabel.text = ""
        restrictionLabel.text = ""
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flexGrid.saveUserDefaults(moduleType)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    func displayView() {
        loadData(isSynched: false)
    }

    
    override func loadData(isSynched: Bool) {
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        guard let dataSettings = dataSettings else {
            completionError(ErrorCode.dbError)
            return
        }
        gridData?.removeAllObjects()
        let inventoryService = InventoryService(module: moduleType, apiCredentials: credentials, date: dataSettings.date)
        let inventoryQuery = inventoryService.queryDb()
        gridData = inventoryQuery.gridData
        isManager = inventoryQuery.isManager
        if let inventorySearchData = inventoryQuery.searchData {
            searchData = inventorySearchData
        }
        let invLastSync = inventoryService.queryLastSync
        guard invLastSync != nil && gridData != nil else {
            guard !isSynched else {
                completionError(ErrorCode.dbError)
                return
            }
            syncInventory()
            return
        }
        if let collectionView = flexGrid.collectionView {
            collectionView.removeAllObjects()
        }
        if let itemsSource = flexGrid.itemsSource {
            itemsSource.removeAllObjects()
        }
        flexGrid.itemsSource = gridData
        isFilterChanged = false
        filterGridColumns(searchBar.text!, classType: classType)
        DispatchQueue.main.async {
            SwiftSpinner.hide(){
                [unowned self] in
                self.endBackgroundTask()
            }
        }
    }
    
    func syncInventory() {
        guard let credentials = Credentials.getCredentials(), let credentialState = credentials["state"] else {
            displayLogIn()
            return
        }
        guard let dataSettings = dataSettings else {
            completionError(ErrorCode.unknownError)
            return
        }
        dataSettings.repState = States(rawValue: credentialState) ?? States.NY
        if (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            beginBackgroundTask()
        }
        SwiftSpinner.show("Syncing...", animated: false)
            let inventoryService = InventoryService(module: self.moduleType, apiCredentials: credentials, date: dataSettings.date)
            do {
                let lastAllSync = try inventoryService.queryAllLastSync()
                inventoryService.getApi(lastAllSync) {
                    [unowned self](inventorySyncCompletion, error) in
                    guard let inventorySync = inventorySyncCompletion else  {
                        self.completionError(error ?? ErrorCode.unknownError)
                        return
                    }
                    do {
                        try inventoryService.updateDb(inventorySync)
                    } catch {
                        self.completionError(ErrorCode.dbError)
                    }
                    inventoryService.updateLastSync()
                    self.loadData(isSynched: true)
                }
            } catch {
                self.completionError(ErrorCode.dbError)
            }
            self.isSettingsChanged = false
    }
}
