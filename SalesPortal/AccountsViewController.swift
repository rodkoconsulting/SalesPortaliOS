import UIKit
import XuniFlexGridKit
import MessageUI

class AccountsViewController: DataGridViewController {

    @IBOutlet weak var accountNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading...", animated: false)
        displayView()
        
// SWIFTSPINNER COMPLETION
//        SwiftSpinner.show("Loading...", animated: false) {
//            [unowned self] _ in
//            self.displayView()
//        }
    }
    
    override func loadSettings() {
        let mainViewController = tabBarController as? MainTabBarController
        gridData = mainViewController?.accounts
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFilterChanged {
            filterRefresh()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flexGrid.saveUserDefaults(moduleType)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func setItemLabels(selectedRow: Int32) {
        guard selectedRow >= 0 && UInt(selectedRow) < flexGrid.rows.count else {
            return
        }
        let flexRow = flexGrid.rows.object(at: UInt(selectedRow))
        guard let account = flexRow.dataItem as? Account else {
            return
        }
        if accountNameLabel != nil {
            accountNameLabel.text = account.customerName
        }
    }
    
    override func clearItemLabels() {
        accountNameLabel.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showAccountOrderTabBarController" {
            guard let row = sender as? GridRow,
                let account = row.dataItem as? Account,
                let orderTabBarController = segue.destination as? OrderTabBarController else {
                    return
            }
            orderTabBarController.order = AccountOrder(account: account)
        }
        if segue.identifier == "showColumnsViewController" {
            guard let columnsViewController = segue.destination as? ColumnsViewController else {
                return
            }
            columnsViewController.columnsDelegate = self
            columnsViewController.columnSettings = flexGrid.columns
            columnsViewController.module = moduleType
        }
        if segue.identifier == "showFiltersViewController" {
            segueFiltersViewController(segue: segue, sender: sender as AnyObject)
        }
        if segue.identifier == "showAccountInfoViewController" {
            let row = flexGrid.rows.object(at: UInt(flexGrid.selection.row))
            guard let account = row.dataItem as? Account, let accountInfoViewController = segue.destination as? AccountInfoViewController else {
                return
            }
            accountInfoViewController.account = account
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "showAccountInfoViewController" else {
            return true
        }
        guard flexGrid.isSelectionVisible() else {
            return false
        }
        return true
    }


//    override func handleLongPress(sender: UILongPressGestureRecognizer) {
//        let pressedPoint = sender.locationInView(flexGrid)
//        let hit = GridHitTestInfo(grid: flexGrid, atPoint: pressedPoint)
//        guard hit.column >= 0 else {
//            return
//        }
//        if sender.state == UIGestureRecognizerState.Began && hit.cellType == GridCellType.ColumnHeader {
//            guard let column = flexGrid.columns.objectAtIndex(UInt(hit.column)) as? DataGridColumn else {
//                return
//            }
//            showFilterActionSheet(column: column, rowIndex: hit.row, panel: hit.gridPanel, flexGrid: flexGrid)
//        }
//    }
  
    @IBAction func refreshGrid(_ sender: AnyObject) {
        syncAccounts()
    }
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.accounts
        classType = Account.self
    }
    
    
    //func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    //    if clearFilterButton.enabled == false {
    //        clearFilterButton.enabled = true
    //    }
    // }
    
    //override func clearSelectedCells() {
    //    guard flexGrid.rows.count > 0 && flexGrid.columns.count > 0 else {
    //        return
    //    }
    //    flexGrid.selection = GridCellRange(row: 0, col: 1)
    //    flexGrid.selection = GridCellRange(row: 0, col: 0)
    //}
    
    
    func displayView() {
        //do {
            //try DbOperation.databaseInit()
            loadData(isSynched: false)
        //} catch {
           // sendAlert(ErrorCode.DbError)
        //}
    }
    
    override func cellDoubleTapped(_ sender: FlexGrid, panel: GridPanel, for range: GridCellRange!) -> Bool {
        guard let range = range else {
            return false
        }
        guard range.col >= 0 else {
            return false
        }
        switch panel.cellType {
            case GridCellType.columnHeader:
                guard let column = flexGrid.columns.object(at: UInt(range.col)) as? DataGridColumn else {
                    return false
                }
                showFilterActionSheet(column: column, rowIndex: range.row, panel: panel)
            case GridCellType.cell:
                let row = flexGrid.rows.object(at: UInt(range.row))
                performSegue(withIdentifier: "showAccountOrderTabBarController", sender: row)
            default:
                return false
            
            }
        return false
        }
    
    override func loadData(isSynched: Bool) {
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        gridData?.removeAllObjects()
        let accountService = AccountService(module: moduleType, apiCredentials: credentials)
        let accountQuery = accountService.queryDb()
        gridData = accountQuery.gridData
        isManager = accountQuery.isManager
        if let accountSearchData = accountQuery.searchData {
            searchData = accountSearchData
        }
        let accountLastSync = accountService.queryLastSync
        guard accountLastSync != nil && gridData != nil else {
            guard !isSynched else {
                completionError(ErrorCode.dbError)
                return
            }
            syncAccounts()
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
            SwiftSpinner.hide()
        }
        
    }
    
    func syncAccounts() {
        guard let credentials = Credentials.getCredentials(), let _ = credentials["state"] else {
            displayLogIn()
            return
        }
        SwiftSpinner.show("Syncing...", animated: false)
        let accountService = AccountService(module: moduleType, apiCredentials: credentials)
        let orderListService = OrderListService(module: Module.orderList, apiCredentials: credentials)
        do {
            let lastAccountSync = try accountService.queryAllLastSync()
            let lastOrderListSync = try orderListService.queryAllLastSync()
            accountService.getApi(lastAccountSync) {
                [unowned self](accountSyncCompletion, error) in
                guard let accountSync = accountSyncCompletion else  {
                    self.completionError(error ?? ErrorCode.unknownError)
                    return
                }
                do {
                    try accountService.updateDb(accountSync)
                } catch {
                    self.completionError(ErrorCode.dbError)
                }
                accountService.updateLastSync()
                orderListService.getApi(lastOrderListSync) {
                    (orderListSyncCompletion, error) in
                    guard let orderListSync = orderListSyncCompletion else  {
                        self.completionError(error ?? ErrorCode.unknownError)
                        return
                    }
                    do {
                        try orderListService.updateDb(orderListSync)
                    } catch {
                        self.completionError(ErrorCode.dbError)
                    }
                    orderListService.updateLastSync()
                    self.loadData(isSynched: true)
                }
            }
        } catch {
            completionError(ErrorCode.dbError)
        }
    }    
}
