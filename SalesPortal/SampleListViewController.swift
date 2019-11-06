import UIKit
import XuniFlexGridKit
import MessageUI
import XuniInputKit

class SampleListViewController: DataGridViewController, XuniDropDownDelegate, XuniComboBoxDelegate {
    

    @IBOutlet weak var sampleFilterComboBox: ComboBox!
    
    var sampleFilter = SampleListFilter.Mtd
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.sampleList
        classType = SampleList.self
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
        sampleFilterComboBox.delegate = self
        sampleFilterComboBox.displayMemberPath = "name"
        sampleFilterComboBox.itemsSource = ComboData.sampleListFilterData()
        sampleFilterComboBox.isEditable = false
        sampleFilterComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        sampleFilterComboBox.dropDownHeight = Double(self.sampleFilterComboBox.itemsSource.count * Constants.ComboCellHeight)
    }
    
    override func setItemLabels(selectedRow: Int32) {
        guard selectedRow >= 0 && UInt(selectedRow) < flexGrid.rows.count else {
            return
        }
        clearItemLabels()
        let flexRow = flexGrid.rows.object(at: UInt(selectedRow)) 
        guard let sample = flexRow.dataItem as? SampleList else {
            return
        }
        if descriptionLabel != nil {
            descriptionLabel.text = sample.itemDescription
        }
    }
    
    override func clearItemLabels() {
        descriptionLabel.text = ""
    }
    
    override func exitVc() {
        flexGrid.saveUserDefaults(moduleType)
        sampleFilterComboBox.selectedItem = nil
        sampleFilterComboBox.itemsSource.removeAllObjects()
        sampleFilterComboBox.collectionView.removeAllObjects()
        sampleFilterComboBox.delegate = nil
        sampleFilterComboBox = nil
        super.exitVc()
    }
    
    
    override func filterGridColumns<T: NSObject>(_ searchText: String?, classType: T.Type, isIndex: Bool = false) {
        guard let collectionView =  flexGrid.collectionView else {
            return
        }
        collectionView.filter = {[unowned self](item : NSObject?) -> Bool in
            guard let row = item as? SampleList else {
                return false
            }
            guard self.sampleFilter.isFilterMatch(row) else {
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
        let rawValue = SampleListFilter.rawValues[index]
        if let sampleFilter = SampleListFilter(rawValue: rawValue) {
            self.sampleFilter = sampleFilter
            beginBackgroundTask()
            SwiftSpinner.show("Loading...", animated: false) {
                self.filterGrid(self.searchBar.text ?? "")
                DispatchQueue.main.async {
                    SwiftSpinner.hide() {
                        [unowned self] in
                        self.endBackgroundTask()
                    }
                }
            }
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
    
    @IBAction func refreshGrid(_ sender: AnyObject) {
        syncSampleList()
    }
    
    override func loadData(isSynched: Bool) {
        super.loadData(isSynched: isSynched)
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        gridData?.removeAllObjects()
        let sampleListService = SampleListService(module: moduleType, apiCredentials: credentials)
        let sampleListQuery = sampleListService.queryDb()
        gridData = sampleListQuery.gridData
        isManager = sampleListQuery.isManager
        if let sampleListSearchData = sampleListQuery.searchData {
            searchData = sampleListSearchData
        }
        let sampleListLastSync = sampleListService.queryLastSync
        guard sampleListLastSync != nil else {
            guard !isSynched else {
                completionError(ErrorCode.dbError)
                return
            }
            syncSampleList()
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
            if let sampleFilterIndex = self.sampleFilter.getIndex {
                self.sampleFilterComboBox.selectedIndex = UInt(sampleFilterIndex)
            }
        }
        filterGrid(self.searchBar.text ?? "")
        isLoaded = true
        DispatchQueue.main.async {
            SwiftSpinner.hide(){
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
    
    func syncSampleList() {
        guard let credentials = Credentials.getCredentials(), let _ = credentials["state"] else {
            displayLogIn()
            return
        }
        if (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            beginBackgroundTask()
        }
        SwiftSpinner.show("Syncing...", animated: false)
        let sampleListService = SampleListService(module: Module.sampleList, apiCredentials: credentials)
        do {
            let lastSampleListSync = try sampleListService.queryAllLastSync()
            sampleListService.getApi(lastSampleListSync) {
                [unowned self](sampleListSyncCompletion, error) in
                guard let sampleListSync = sampleListSyncCompletion else  {
                    self.completionError(error ?? ErrorCode.unknownError)
                    return
                }
                do {
                    try sampleListService.updateDb(sampleListSync)
                } catch {
                    self.completionError(ErrorCode.dbError)
                }
                sampleListService.updateLastSync()
                self.loadData(isSynched: true)
            }
        } catch {
            completionError(ErrorCode.dbError)
        }
    }
    
    override func showShareActionSheet(flexGrid: FlexGrid, moduleType: Module, sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Order / Copy / Email", message: nil, preferredStyle: .actionSheet)
        let orderButton = UIAlertAction(title: "Order Samples", style: .default) {
            [unowned self] (alert) -> Void in
            self.performSegue(withIdentifier: "showSampleOrderTabBarController", sender: nil)
        }
        let copyButton = UIAlertAction(title: "Copy", style: .default) {
            [unowned self] (alert) -> Void in
            self.copyData(flexGrid, moduleType: moduleType)
        }
        let emailButton = UIAlertAction(title: "Email", style: .default) {
            [unowned self] (alert) -> Void in
            self.emailData(flexGrid, moduleType: moduleType)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        actionSheet.addAction(orderButton)
        if flexGrid.isSelectionVisible() {
            actionSheet.addAction(copyButton)
        }
        actionSheet.addAction(emailButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showSampleOrderTabBarController" {
                guard let orderTabBarController = segue.destination as? OrderTabBarController else {
                    return
            }
            orderTabBarController.order = SampleOrder()
            orderTabBarController.modalPresentationStyle = .fullScreen
        }

    }

    
    
}
