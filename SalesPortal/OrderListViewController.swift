import UIKit
import XuniFlexGridKit
import MessageUI
import XuniInputKit

class OrderListViewController: DataGridViewController, XuniDropDownDelegate, XuniComboBoxDelegate {
    
    @IBOutlet weak var orderFilterComboBox: XuniComboBox!
    var orderFilter = OrderListFilter.All
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.orderList
        classType = OrderList.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComboBox()
        beginBackgroundTask()
        SwiftSpinner.show("Loading...", animated: false) {
            [unowned self] () -> Void in
            self.displayView()
        }
    }
    
    fileprivate func initComboBox() {
        orderFilterComboBox.delegate = self
        orderFilterComboBox.displayMemberPath = "name"
        orderFilterComboBox.itemsSource = ComboData.orderListFilterData()
        orderFilterComboBox.isEditable = false
        orderFilterComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        orderFilterComboBox.dropDownHeight = Double(self.orderFilterComboBox.itemsSource.count * Constants.ComboCellHeight)
        
    }
    
    override func setItemLabels(selectedRow: Int32) {
        guard selectedRow >= 0 && UInt(selectedRow) < flexGrid.rows.count else {
            return
        }
        clearItemLabels()
        let flexRow = flexGrid.rows.object(at: UInt(selectedRow))
        guard let order = flexRow.dataItem as? OrderList else {
            return
        }
        if descriptionLabel != nil {
            descriptionLabel.text = order.itemDescription
        }
    }
    
    override func clearItemLabels() {
        descriptionLabel.text = ""
    }
    
    override func exitVc() {
        flexGrid.saveUserDefaults(moduleType)
        orderFilterComboBox.selectedItem = nil
        orderFilterComboBox.itemsSource.removeAllObjects()
        orderFilterComboBox.collectionView.removeAllObjects()
        orderFilterComboBox.delegate = nil
        orderFilterComboBox = nil
        super.exitVc()
    }
    
    
    override func filterGridColumns<T: NSObject>(_ searchText: String?, classType: T.Type, isIndex: Bool = false) {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        collectionView.filter = {[unowned self](item : NSObject?) -> Bool in
            guard let row = item as? OrderList else {
                return false
            }
            guard self.orderFilter.isFilterMatch(row) else {
                return false
            }
            guard !isIndex else {
                return self.flexGrid.filterIndex(searchText, row: row, moduleType: self.moduleType) && self.flexGrid.filterColumns(nil, row: row)
            }
            return self.flexGrid.filterColumns(searchText, row: row)
            } as IXuniPredicate
        resetGrid()
    }
    
    func selectedIndexChanged(_ sender: XuniComboBox!) {
        let index = Int(sender.selectedIndex)
        let rawValue = OrderListFilter.rawValues[index]
        if let orderFilter = OrderListFilter(rawValue: rawValue) {
            self.orderFilter = orderFilter
            self.filterGrid(self.searchBar.text ?? "")
        }
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
    
    override func groupRows() {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        let gd: XuniPropertyGroupDescription = XuniPropertyGroupDescription(property: "totalGroupLabel")
        collectionView.groupDescriptions.add(gd)
        super.groupRows()
    }
    
    
    @IBAction func refreshGrid(_ sender: AnyObject) {
        syncOrderList()
    }
    
    override func loadData(isSynched: Bool) {
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        gridData?.removeAllObjects()
        let orderListService = OrderListService(module: moduleType, apiCredentials: credentials)
        let orderListQuery = orderListService.queryDb()
        gridData = orderListQuery.gridData
        isManager = orderListQuery.isManager
        if let orderListSearchData = orderListQuery.searchData {
            searchData = orderListSearchData
        }
        let orderListLastSync = orderListService.queryLastSync
        //guard orderListLastSync != nil && gridData != nil else {
        guard orderListLastSync != nil else {
            guard !isSynched else {
                completionError(ErrorCode.dbError)
                return
            }
            syncOrderList()
            return
        }
        if let collectionView = flexGrid.collectionView {
            collectionView.removeAllObjects()
        }
        if let itemsSource = flexGrid.itemsSource {
            itemsSource.removeAllObjects()
        }
        flexGrid.itemsSource = gridData
        groupRows()
        isFilterChanged = false
        if !isLoaded {
            if let orderFilterIndex = self.orderFilter.getIndex {
                self.orderFilterComboBox.selectedIndex = UInt(orderFilterIndex)
            }
        } else {
            filterGrid(self.searchBar.text ?? "")
        }
        isLoaded = true
        DispatchQueue.main.async {
            SwiftSpinner.hide() {
                [unowned self] in
                self.endBackgroundTask()
            }
        }
    }

    func displayView() {
        loadData(isSynched: false)
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
            guard let row = flexGrid.rows.object(at: UInt(range.row)) as? GridGroupRow else {
                return false
            }
            showGroupActionSheet(row, panel: panel)
        default:
            return false
        }
        return false
    }
    
    
    
    func syncOrderList() {
        guard let credentials = Credentials.getCredentials(), let _ = credentials["state"] else {
            displayLogIn()
            return
        }
        if (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            beginBackgroundTask()
        }
        SwiftSpinner.show("Syncing...", animated: false)
        //let accountService = AccountService(module: Module.accounts, apiCredentials: credentials)
        let orderListService = OrderListService(module: Module.orderList, apiCredentials: credentials)
        do {
            //let lastAccountSync = try accountService.queryAllLastSync()
            let lastOrderListSync = try orderListService.queryAllLastSync()
            //accountService.getApi(lastAccountSync) {
                //[unowned self](accountSyncCompletion, error) in
                //guard let accountSync = accountSyncCompletion else  {
                    //self.completionError(error ?? ErrorCode.unknownError)
                    //return
                //}
                //do {
                //    try accountService.updateDb(accountSync)
                //} catch {
                //    self.completionError(ErrorCode.dbError)
                //}
                //accountService.updateLastSync()
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
                //}
            }
        } catch {
            completionError(ErrorCode.dbError)
        }
    }
}
