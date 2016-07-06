import UIKit
import XuniFlexGridKit
import MessageUI

class AccountsViewController: DataGridViewController, ColumnsDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = self.tabBarController as? MainTabBarController
        gridData = mainViewController?.accounts
        initGrid()
        longPressInitialize(flexGrid)
        SwiftSpinner.show("Loading...", animated: false) {
            _ in
            self.displayView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFilterChanged {
            filterRefresh()
        }
    }
    
    override func setItemLabels(selectedRow selectedRow: Int32) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        flexGrid.saveUserDefaults(moduleType)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        if segue.identifier == "showOrderTabBarController" {
            guard let row = sender as? FlexRow,
                let account = row.dataItem as? Account,
                let orderTabBarController = segue.destinationViewController as? OrderTabBarController else {
                    return
            }
            orderTabBarController.order = Order(account: account)
        }
    }

    override func handleLongPress(sender: UILongPressGestureRecognizer) {
        let pressedPoint = sender.locationInView(flexGrid)
        let hit = FlexHitTestInfo(grid: flexGrid, atPoint: pressedPoint)
        if sender.state == UIGestureRecognizerState.Began && hit.cellType == FlexCellType.ColumnHeader {
            guard let column = flexGrid.columns.objectAtIndex(UInt(hit.column)) as? GridColumn else {
                return
            }
            showFilterActionSheet(column: column, rowIndex: hit.row, panel: hit.gridPanel, flexGrid: flexGrid)
        }
    }
  
    @IBAction func refreshGrid(sender: AnyObject) {
        syncAccounts()
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.moduleType = Module.Accounts
        self.classType = Account.self
    }
    
    
    //func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    //    if clearFilterButton.enabled == false {
    //        clearFilterButton.enabled = true
    //    }
    // }
    
    override func clearSelectedCells() {
        guard flexGrid.rows.count > 0 && flexGrid.columns.count > 0 else {
            return
        }
        flexGrid.selection = FlexCellRange(row: 0, col: 1)
        flexGrid.selection = FlexCellRange(row: 0, col: 0)
    }

    func displayView() {
        do {
            try DbOperation.databaseInit()
            loadData(isSynched: false)
        } catch {
            sendAlert(ErrorCode.DbError)
        }
    }
    
    override func cellDoubleTapped(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!) -> Bool {
        guard panel != nil else {
            return false
        }
        switch panel.cellType {
            case FlexCellType.ColumnHeader:
                guard let column = flexGrid.columns.objectAtIndex(UInt(range.col)) as? GridColumn else {
                    return false
                }
                showFilterActionSheet(column: column, rowIndex: range.row, panel: panel)
            case FlexCellType.Cell:
                guard let row = flexGrid.rows.objectAtIndex(UInt(range.row)) as? FlexRow else {
                    return false
                }
                self.performSegueWithIdentifier("showOrderTabBarController", sender: row)
            default:
                return false
                
            }
        return false
        }
    
    override func loadData(isSynched isSynched: Bool) {
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        gridData?.removeAllObjects()
        let accountService = AccountService(module: moduleType, apiCredentials: credentials)
        let accountQuery = accountService.queryDb
        gridData = accountQuery.gridData
        if let accountSearchData = accountQuery.searchData {
            searchData = accountSearchData
        }
        let accountLastSync = accountService.queryLastSync
        guard accountLastSync != nil && self.gridData != nil else {
            guard !isSynched else {
                self.completionError(ErrorCode.DbError)
                return
            }
            self.syncAccounts()
            return
        }
        if flexGrid.collectionView != nil {
            flexGrid.collectionView.removeAllObjects()
        }
        if flexGrid.itemsSource != nil {
            flexGrid.itemsSource.removeAllObjects()
        }
        self.flexGrid.itemsSource = gridData
        self.isFilterChanged = false
        self.filterGridColumns(self.searchBar.text!, classType: classType)
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.hide()
        }
        
    }
    
    func syncAccounts() {
        guard let credentials = Credentials.getCredentials(), let _ = credentials["state"] else {
            self.displayLogIn()
            return
        }
        SwiftSpinner.show("Syncing...", animated: false)
        let accountService = AccountService(module: moduleType, apiCredentials: credentials)
        do {
            let lastAllSync = try accountService.queryAllLastSync()
            accountService.getApi(lastAllSync) {
                (let accountSyncCompletion, error) in
                guard let accountSync = accountSyncCompletion else  {
                    self.completionError(error ?? ErrorCode.UnknownError)
                    return
                }
                do {
                    try accountService.updateDb(accountSync)
                } catch {
                    self.completionError(ErrorCode.DbError)
                }
                accountService.updateLastSync()
                self.loadData(isSynched: true)
            }
        } catch {
            self.completionError(ErrorCode.DbError)
        }
    }    
}