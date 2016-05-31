
import UIKit
import XuniFlexGridKit
import MessageUI

class InventoryViewController: UIViewController, FlexGridDelegate, UISearchBarDelegate, InventoryDataSettingsDelegate, ColumnsDelegate, FiltersDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var restrictionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectModeSegment: UISegmentedControl!
    @IBOutlet weak var copyButton: UIBarButtonItem!
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var flexGrid: FlexGrid!
 
    var isLoaded: Bool = false
    var inventory: NSMutableArray?
    var dataSettings: InventoryDataSettings?
    var isSettingsChanged = false
    var isFilterChanged = false
    var currentSelectionMode = Constants.defaultSelectionMode
    
    var isSortAscending = true
    var lastSortedColumn : Int32 = -1
    var lastFormattedRow : Int32 = 0

    @IBAction func refreshGrid(sender: AnyObject) {
        if let dataSettings = dataSettings {
          dataSettings.refreshDates()  
        }
        syncInventory()
    }
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func excelExport(sender: AnyObject) {
        SwiftSpinner.show("Exporting...", animated: true) {
            _ in
            dispatch_async(dispatch_get_main_queue()) {
                guard let mailComposer = DataExport.excelExport(flexGrid: self.flexGrid, mailSubject: Constants.mailSubject, mailBody: Constants.mailBody, attachmentName: Constants.mailAttachmentFile) else {
                    SwiftSpinner.hide()
                    return
                }
                mailComposer.mailComposeDelegate = self
                self.presentViewController(mailComposer, animated: true, completion: nil)
                SwiftSpinner.hide()
            }
        }
    }
    
    
    @IBAction func copyButtonPressed(sender: AnyObject) {
        if let stringSelection = DataExport.copyGrid(copySelection: true, flexGrid: flexGrid) {
            UIPasteboard.generalPasteboard().string = stringSelection
        }
    }
    
    @IBAction func clearFilter() {
        SwiftSpinner.show("Loading...", animated: true) {
            _ in
            self.searchBar.text = ""
            self.clearFilterButton.enabled = false
            self.searchBar.resignFirstResponder()
            self.view.endEditing(true)
            self.filterGrid("")
            dispatch_async(dispatch_get_main_queue()) {
                SwiftSpinner.hide()
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterRefresh(){
        guard self.isFilterChanged else {
            return
        }
        SwiftSpinner.show("Loading...", animated: true) {
            _ in
            dispatch_async(dispatch_get_main_queue()) {
                self.filterGrid(self.searchBar.text!)
                SwiftSpinner.hide()
            }
        }
    }
    
    @IBAction func unwindFromColumns(segue: UIStoryboardSegue) {
        filterRefresh()
    }
    
    @IBAction func selectModeSegmentChanged(sender: AnyObject) {
        let index = selectModeSegment.selectedSegmentIndex
        guard index < GridSettings.selectionModes.count else {
            return
        }
        flexGrid.selectionMode = GridSettings.selectionModes[index]
        currentSelectionMode = flexGrid.selectionMode
    }
    
    func saveColumnSettings() -> [[String : AnyObject]] {
        var myColumnSettings = [[String : AnyObject]]()
        for col: UInt in 0 ..< flexGrid.columns.count {
            var myDict = [String : AnyObject]()
            let column = flexGrid.columns.objectAtIndex(UInt(col)) as! FlexColumn
            myDict["name"] = column.name
            myDict["visible"] = column.visible
            if column.visible {
                myDict["width"] = column.width
            }
            myColumnSettings.append(myDict)
        }
        return myColumnSettings
    }
    
    func resetGrid() {
        if self.flexGrid.rows.count > 0 {
            self.flexGrid.scrollRowIntoView(0, forColumn: 0)
            self.flexGrid.selectionMode = self.currentSelectionMode
        }
        clearSelectedCells()
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
    
    func setTitleLabel() {
        if let dataSettings = dataSettings {
           titleLabel.text = "\(dataSettings.repState) \(dataSettings.month) pricing"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettingsViewController" {
            let settingsViewController = segue.destinationViewController as! InventorySettingsViewController
            settingsViewController.dataSettings = dataSettings
            isSettingsChanged = false
        }
        if segue.identifier == "showColumnsViewController" {
            let columnsViewController = segue.destinationViewController as! ColumnsViewController
            columnsViewController.columnsDelegate = self
            columnsViewController.columnSettings = flexGrid.columns
        }
        if segue.identifier == "showFiltersViewController" {
            guard let column = sender as? GridColumn else {
                return
            }
            guard let filtersViewController = segue.destinationViewController as? FiltersViewController else {
                return
            }
            filtersViewController.filterDelegate = self
            filtersViewController.columnFilters = column.columnFilters
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = self.tabBarController as? MainTabBarController
        dataSettings = mainViewController?.inventoryDataSettings
        inventory = mainViewController?.inventory
        if let dataSettings = dataSettings {
            dataSettings.delegate = self
        }
        flexGrid.isReadOnly = true
        flexGrid.alternatingRowBackgroundColor = GridSettings.alternatingRowBackgroundColor
        flexGrid.gridLinesVisibility = GridSettings.gridLinesVisibility
        flexGrid.selectionMode = GridSettings.defaultSelectionMode
        flexGrid.delegate = self
        searchBar.delegate = self
        setTitleLabel()
        gridColumnLayout()
        flexGrid.itemsSource = inventory
        self.displayView()
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
        saveUserDefaults()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveUserDefaults() {
        let columnSettings = saveColumnSettings()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(columnSettings, forKey: "columnSettings")
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SwiftSpinner.show("Searching...", animated: true) {
            _ in
            searchBar.resignFirstResponder()
            self.filterGrid(searchBar.text ?? "")
            dispatch_async(dispatch_get_main_queue()) {
                SwiftSpinner.hide()
            }
        }
    }
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if clearFilterButton.enabled == false {
            clearFilterButton.enabled = true
        }
   }
    
    func filterGrid(filterText: String?) {
        flexGrid.selectionMode = FlexSelectionMode.Row
        self.filterGridColumns(filterText)
        self.isFilterChanged = false
    }
    
    func filterGridColumns(searchText: String?) {
        flexGrid.collectionView.filter = {(item : NSObject?) -> Bool in
            let row = item as! Inventory
            let hasSearchText = searchText != nil && searchText != ""
            var searchMatched = !hasSearchText
            var columnFilterMatched = true
            var allFiltersMatched = true
            for index in 0...self.flexGrid.columns.count - 1 {
                guard let column = self.flexGrid.columns.objectAtIndex(index) as? GridColumn,
                        let columnValue = row.valueForKey(column.binding) else {
                    continue
                }
                let filters = column.columnFilters.filterList
                var valueArray = "\(columnValue)".characters.split{$0 == "\n"}.map { String($0) }
                if valueArray.count == 0 {
                    valueArray.append("")
                }
                for value in valueArray {
                    if hasSearchText && value.lowercaseString.rangeOfString(searchText!.lowercaseString) != nil {
                        searchMatched = true
                    }
                    if filters.count > 0 {
                        columnFilterMatched = false
                        var columnResults = [(filterBool: Bool, filterOperator: FilterOperator)]()
                        for columnFilter in column.columnFilters.filterList {
                            columnResults.append((columnFilter.getResult(value: value, filterType: column.columnFilters.filterType), columnFilter.filterOperatior))
                        }
                        let filterMatched = column.columnFilters.getFilterResults(columnResults)
                        if filterMatched {
                            columnFilterMatched = true
                        }
                    }
                }
                if !columnFilterMatched {
                    allFiltersMatched = false
                }
            }
            return searchMatched && allFiltersMatched
        } as IXuniPredicate
        resetGrid()
    }

    func clearSelectedCells() {
        clearItemLabels()
        guard flexGrid.rows.count > 0 && flexGrid.columns.count > 0 else {
            return
        }
        flexGrid.selection = FlexCellRange(row: 0, col: 1)
        flexGrid.selection = FlexCellRange(row: 0, col: 0)
        setItemLabels(selectedRow: flexGrid.selection.row)
    }
    
    func clearItemLabels() {
        descriptionLabel.text = ""
        restrictionLabel.text = ""
    }
    
    func setItemLabels(selectedRow selectedRow: Int32) {
        let flexRow = flexGrid.rows.objectAtIndex(UInt(selectedRow)) as! FlexRow
        let inventory = flexRow.dataItem as! Inventory
        descriptionLabel.text = inventory.itemDescription
        restrictionLabel.text = inventory.restrictedList
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func gridColumnLayout() {
        flexGrid.autoGenerateColumns = false
        flexGrid.isEnabled = true
        flexGrid.selectionBackgroundColor = GridSettings.colorSelected
        flexGrid.selectionTextColor = GridSettings.selectionTextColor
        flexGrid.font = GridSettings.defaultFont
        flexGrid.columnHeaderFont = GridSettings.columnHeaderFont
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultColumnSettings = ColumnSettings.generateColumnSettings(defaults.objectForKey("columnSettings") as? [[String : AnyObject]])
        let columns = GridColumn.generateColumns(defaultColumnSettings, columnType: ColumnType.Inventory)
        for column in columns {
            flexGrid.columns.addObject(column)
        }
    }

    
    func formatItem(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!, inContext context: CGContext!)  -> Bool {
        guard panel.cellType == FlexCellType.Cell else {
            return false
        }
        let isSelected = panel.fillColor == flexGrid.selectionBackgroundColor ? true : false
        var backgroundColor: UIColor? = nil
        if isRestrictedItem(range.row) {
            backgroundColor = GridSettings.colorRestricted
        } else if isFocusItem(range.row) {
            backgroundColor = GridSettings.colorFocus
        }
        if !isSelected && backgroundColor != nil {
            CGContextSetFillColorWithColor(context, backgroundColor!.CGColor)
            let r = panel.getCellRectForRow(range.row, inColumn: range.col)
            CGContextFillRect(context, r)
        }
        if range.col==range.rightCol && lastFormattedRow < range.bottomRow && flexGrid.rows.count > 0
        {
            flexGrid.autoSizeRow(range.row)
            lastFormattedRow = range.row
        }
        return false
     }
    
    
    func loadedRows(sender: FlexGrid!) {
        dispatch_async(dispatch_get_main_queue()) {
            guard self.flexGrid.rows.count > 0 else {
                return
            }
            self.flexGrid.autoSizeRows()
        }
        resetLastFormattedRow()
    }
    
    func resetLastFormattedRow() {
        lastFormattedRow = 0
    }
    
    func resizedColumn(sender: FlexGrid!, column: FlexColumn!) {
            resetLastFormattedRow()
    }
    
    
    func isRestrictedItem(row: Int32) -> Bool {
        let flexRow = flexGrid.rows.objectAtIndex(UInt(row)) as! FlexRow
        let inventory = flexRow.dataItem as! Inventory
        return inventory.isRestricted
    }
    
    func isFocusItem(row: Int32) -> Bool {
        let flexRow = flexGrid.rows.objectAtIndex(UInt(row)) as! FlexRow
        let inventory = flexRow.dataItem as! Inventory
        return inventory.focus
    }
    

    func selectionChanged(sender: FlexGrid!, panel:FlexGridPanel!, forRange range: FlexCellRange!) {
        setItemLabels(selectedRow: range.row)
    }
    
    func sortingColumn(sender: FlexGrid!, panel:FlexGridPanel!, forRange range:FlexCellRange!) -> Bool {
        SwiftSpinner.show("Sorting...", animated: true) {
            _ in
            dispatch_async(dispatch_get_main_queue()) {
                guard let col = self.flexGrid.columns.objectAtIndex(UInt(range.col)) as? GridColumn else {
                    return
                }
                if range.col == self.lastSortedColumn {
                    self.isSortAscending = !self.isSortAscending
                } else {
                    self.isSortAscending = true
                }
                self.lastSortedColumn = range.col
                let sd = XuniSortDescription(property: col.binding, ascending: self.isSortAscending)
                self.flexGrid.collectionView.sortDescriptions.removeAllObjects()
                self.flexGrid.collectionView.sortDescriptions.addObject(sd)
                self.flexGrid.setNeedsDisplay()
                self.autoSizeColumns()
                SwiftSpinner.hide()
            }
        }
        return true
    }
   
    func displayView() {
        do {
            try DbOperation.databaseInit()
            loadData(isSynched: false)
        } catch {
            sendAlert(ErrorCode.DbError)
        }
    }
    
    func autoSizeColumns() {
        for col: UInt in 0 ..< self.flexGrid.columns.count {
            let gridCol = flexGrid.columns.objectAtIndex(col) as! GridColumn
            if gridCol.autosize {
                self.flexGrid.autoSizeColumn(Int32(col))
            }
        }
    }
    
    func cellDoubleTapped(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!) -> Bool {
        guard panel.cellType == FlexCellType.ColumnHeader else {
            return false
        }
        guard let column = flexGrid.columns.objectAtIndex(UInt(range.col)) as? GridColumn else {
            return false
        }
        let actionSheet = UIAlertController(title: column.header, message: nil, preferredStyle: .ActionSheet)
        let filterButton = UIAlertAction(title: "Filter", style: .Default) {
            (alert) -> Void in
            self.performSegueWithIdentifier("showFiltersViewController", sender: column)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRectForRow(range.row, inColumn: range.col)
        actionSheet.addAction(filterButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        self.presentViewController(actionSheet, animated: true, completion: nil)
        return false
    }
    
    func loadData(isSynched isSynched: Bool) {
        guard let credentials = Credentials.getCredentials() else {
            displayLogIn()
            return
        }
        guard let dataSettings = dataSettings else {
            self.completionError(ErrorCode.DbError)
            return
        }
        //self.flexGrid.itemsSource = nil
        inventory?.removeAllObjects()
        let inventoryService = InventoryService(apiInit: ApiInit.Inventory, syncTable: SyncTable.Inventory, tableNames: SyncTable.Inventory.tables, apiCredentials: credentials, date: dataSettings.date)
        //inventory = nil
        inventory = inventoryService.queryDb
        let invLastSync = inventoryService.queryLastSync
        guard invLastSync != nil && self.inventory != nil else {
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
        self.flexGrid.itemsSource = inventory
        //flexGrid.collectionView.removeAllObjects()
        //flexGrid.collectionView = nil
        //self.flexGrid.itemsSource.removeAllObjects()
        //self.flexGrid.itemsSource = nil
        
        
        //inventory?.removeAllObjects()
        //inventory = nil
        self.isFilterChanged = false
        self.filterGridColumns(self.searchBar.text!)
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.hide()
        }
        
    }
    
    
    func loadingData(isSynched: Bool) {
        SwiftSpinner.show("Loading...", animated: true) {
            _ in
                self.loadData(isSynched: isSynched)
        }
    }

    func syncInventory() {
        guard let credentials = Credentials.getCredentials(), let credentialState = credentials["state"] else {
            self.displayLogIn()
            return
        }
        self.dataSettings.repState = "N\(credentialState)"
        SwiftSpinner.show("Syncing...", animated: true)
        let inventoryService = InventoryService(apiInit: .Inventory, syncTable: .Inventory, tableNames: SyncTable.Inventory.tables, apiCredentials: credentials, date: dataSettings.date)
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
    }

    func displayLogIn() {
        performSegueWithIdentifier("unwindToLogin", sender: self)
    }
    
    func completionError(error: ErrorCode) {
        dispatch_async(dispatch_get_main_queue()) {
            SwiftSpinner.hide()
            self.sendAlert(error)
            if error.isAuthError() {
                Credentials.deleteCredentials()
                self.clearData()
            }
        }
    }
    
    func sendAlert(error: ErrorCode) {
        let alertController = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func clearData() {
        DbOperation.databaseDelete()
    }
    
    func changedFilters() {
        isFilterChanged = true
    }
    
    
   
}