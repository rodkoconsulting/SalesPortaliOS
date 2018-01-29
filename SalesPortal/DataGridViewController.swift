//
//  DataGridViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/8/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit
import MessageUI


class DataGridViewController: UIViewController, FiltersDelegate, ColumnsDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, MPGTextFieldDelegate, FlexGridDelegate {
   
    @IBOutlet weak var searchBar: MPGTextField_Swift! = nil
    @IBOutlet weak var flexGrid: FlexGrid! = nil
    @IBOutlet weak var descriptionLabel: UILabel! = nil
    @IBOutlet weak var restrictionLabel: UILabel! = nil
    @IBOutlet weak var clearFilterButton: UIButton! = nil
    @IBOutlet weak var removeFilterButton: UIBarButtonItem! = nil
    @IBOutlet weak var selectModeSegment: UISegmentedControl! = nil
    @IBOutlet weak var titleLabel: UILabel! = nil
    
    
    @IBAction func clearFilter() {
            self.searchBar.text = ""
            self.clearFilterButton.isEnabled = false
            let _ = self.searchBar.resignFirstResponder()
    }
    
    @IBAction func unwindFromColumns(_ segue: UIStoryboardSegue) {
        filterRefresh()
    }
    
    @IBAction func selectModeSegmentChanged(_ sender: AnyObject) {
        let index = selectModeSegment.selectedSegmentIndex
        guard index < GridSettings.selectionModes.count else {
            return
        }
        currentSelectionMode = GridSettings.selectionModes[index]
        flexGrid.selectionMode = currentSelectionMode
    }
    
    @IBAction func shareData(_ sender: UIBarButtonItem) {
        showShareActionSheet(flexGrid: flexGrid, moduleType: moduleType, sender: sender)
    }
    
    @IBAction func removeFilters(_ sender: AnyObject) {
        var isFilterChanged = false
        for index in 0...flexGrid.columns.count - 1 {
            guard let column = flexGrid.columns.object(at: index) as? DataGridColumn else {
                continue
            }
            if column.columnFilters.filterList.count > 0 {
                isFilterChanged = true
            }
            column.columnFilters.filterList.removeAll()
        }
        guard isFilterChanged else {
            return
        }
        changedColumnFilters()
        filterRefresh()
    }

    
    var moduleType = Module.inventory
    var classType: NSObject.Type = Inventory.self
    var searchData: [[String : String]] = [[String : String]]()
    var gridData: NSMutableArray?
    var activeField: CGRect?
    var changedY = false
    var keyboardHeight: CGFloat = 300
    var lastSortedColumn : Int32 = -1
    var lastFormattedRow : Int32 = 0
    var isSortAscending = true
    var isFilterChanged = false
    var currentSelectionMode = GridSettings.defaultSelectionMode
    var isLoaded: Bool = false
    var isSettingsChanged = false
    var isFilterIndex = false
    var isManager = false
    
    var flexGridSelectionChangingHandler: ((_ eventContainer: XuniEventContainer<GridCellRangeEventArgs>?)-> Void)!  = {
        (eventContainer: XuniEventContainer<GridCellRangeEventArgs>?)-> Void  in
            let eventContainerEventArgs = eventContainer!.eventArgs!
            if (eventContainerEventArgs.row <  0) {
                eventContainerEventArgs.cancel = true
            }
            if (eventContainerEventArgs.col <  0) {
                eventContainerEventArgs.cancel = true
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        initGrid()
        searchBar?.mDelegate = self
        addNotifications()
        addHandlers()
        guard let searchBar = searchBar else {
            return
        }
        searchBar.autocorrectionType = .no
        let shortcut : UITextInputAssistantItem = searchBar.inputAssistantItem
        shortcut.leadingBarButtonGroups = []
        shortcut.trailingBarButtonGroups = []
        clearSelectedCells()
    }
    
    func addHandlers() {
        self.flexGrid.flexGridSelectionChanging.addHandler(flexGridSelectionChangingHandler, for: self)
    }

    func removeHandlers() {
        guard flexGrid != nil else {
            return
        }
        self.flexGrid.flexGridSelectionChanging.removeHandler(flexGridSelectionChangingHandler, for: self)
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(DataGridViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(DataGridViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    
    func dataForPopoverInTextField(_ textfield: MPGTextField_Swift) -> [[String : String]]
    {   
        return searchData
    }
    
    func textFieldShouldSelect(_ textField: MPGTextField_Swift) -> Bool{
        return true
    }
    
    func textFieldDidEndEditing(_ textField: MPGTextField_Swift, isIndex: Bool = false){
        SwiftSpinner.show("Loading...", animated: false) {
            [unowned self] () -> Void in
            self.isFilterIndex = isIndex && !self.flexGrid.hasFilters()
            if self.isFilterIndex {
                self.filterIndex()
            } else {
                self.filterGrid(self.searchBar.text ?? "")
            }
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
        }
    }
    
    func searchBarTextBeganEditing() {
        //self.view.endEditing(true)
        flexGrid.finishEditing(false)
    }
    
    func initGrid() {
        flexGrid.isReadOnly = true
        flexGrid.delegate = self
        flexGrid.gridLayout(moduleType)
        flexGrid.itemsSource = gridData
        let shortcut : UITextInputAssistantItem = flexGrid.inputAssistantItem
        shortcut.leadingBarButtonGroups = []
        shortcut.trailingBarButtonGroups = []
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    func filterIndex(){
        isFilterIndex = true
        filterGrid(searchBar.text ?? "")
    }
    
    func filterGrid(_ filterText: String?) {
        filterGridColumns(filterText, classType: classType, isIndex: isFilterIndex)
        isFilterChanged = false
        
    }
    
    func filterGridColumns<T: NSObject>(_ searchText: String?, classType: T.Type, isIndex: Bool = false) {
        guard let collectionView = self.flexGrid.collectionView else {
            return
        }
        collectionView.filter = {(item : NSObject?) -> Bool in
            guard let row = item as? T else {
                return false
            }
            guard !isIndex else {
                return self.flexGrid.filterIndex(searchText, row: row, moduleType: self.moduleType) && self.flexGrid.filterColumns(nil, row: row)
            }
            return self.flexGrid.filterColumns(searchText, row: row)
            
            } as IXuniPredicate
        resetGrid()
    }
    
    func resetGrid() {
        selectModeSegment.isEnabled = flexGrid.isSelectionVisible()
        clearSelectedCells()
        if flexGrid.rows.count > 0 {
           flexGrid.scroll(intoView: 0, c: 0)
        }
    }
    
    func searchTextChanged() {
        flexGrid.finishEditing(false)
        if clearFilterButton.isEnabled == false {
            clearFilterButton.isEnabled = true
        }
    }
    
    func clearGridSource() {
        guard flexGrid != nil else {
            return
        }
        if let collectionView = flexGrid.collectionView  {
            collectionView.removeAllObjects()
        }
        if let itemsSource = flexGrid.itemsSource {
            itemsSource.removeAllObjects()
        }
    }
    
    func setGridSource() {
        flexGrid.itemsSource = gridData
        isFilterChanged = false
        filterGridColumns(searchBar.text!, classType: classType)
        resetGrid()
        setTitleLabel()
    }
    
    func setTitleLabel() {
    
    }
    
    func loadSettings() {
    
    }
    
    func clearItemLabels() {
        
    }

    func clearSelectedCells() {
        clearItemLabels()
        guard flexGrid.rows.count > 0 && flexGrid.columns.count > 0 else {
            return
        }
        flexGrid.selection = GridCellRange(row: -1, col: -1)
    }
    
    
    func setItemLabels(selectedRow: Int32) {
        
    }


    @objc func keyboardWillShow(_ sender: Notification) {
        guard let kbFrame = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let keyboard = view.convert(kbFrame, from: view.window)
        let height = view.frame.size.height
        guard ((keyboard.origin.y + keyboard.size.height) <= height) else {
            return
        }
        let kbSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        keyboardHeight = kbSize!.height
        guard let activeField = activeField else {
            return
        }
        let activeFieldOrigin = activeField.origin.y
        let activeFieldHeight = activeField.height
        let flexGridOrigin = flexGrid.frame.origin.y
        let activeFieldOffSet = flexGridOrigin + activeFieldOrigin + activeFieldHeight
        if activeFieldOffSet > height - keyboardHeight {
            if (!changedY) {
                flexGrid.allowSorting = false
                view.frame.origin.y -= keyboardHeight
            }
            changedY = true
        }
    }
    
    
    func cellTapped(_ sender: FlexGrid, panel: GridPanel, for range: GridCellRange?) -> Bool {
        guard flexGrid.rows.count > 0 else {
            return true
        }
        if !flexGrid.allowSorting {
            flexGrid.allowSorting = true
            return true
        }
        return false
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if changedY {
            view.frame.origin.y += keyboardHeight
        }
        changedY = false
    }

    func sendAlert(_ error: ErrorCode) {
        let alertController = UIAlertController(title: "Error!", message: error.description, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alertController.addAction(ok)
        let viewController = parent ?? self
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func sendMessage(title: String, message: String) {
        let messageController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[unowned self] (action) -> Void in self.exitAllVc() })
        messageController.addAction(ok)
        let viewController = parent ?? self
        viewController.present(messageController, animated: true, completion: nil)
    }
    
    func exitVc() {
        removeHandlers()
        clearGridSource()
        searchData.removeAll()
        NotificationCenter.default.removeObserver(self)
        guard flexGrid != nil else {
            return
        }
        flexGrid.rows.removeAllObjects()
        flexGrid.columns.removeAllObjects()
        flexGrid.removeGestures()
        flexGrid.delegate = nil
        flexGrid.dropCaches()
        flexGrid.removeFromSuperview()
        flexGrid = nil
    }
    
    
    fileprivate func exitAllVc() {
        exitVc()
        guard let orderTabBarController = tabBarController as? OrderTabBarController,
            let myViewControllers = orderTabBarController.viewControllers else {
                dismiss(animated: true, completion: nil)
                return
            }
        for viewController in myViewControllers {
            if viewController.isKind(of: DataGridViewController.self) {
                if let dataGridViewController = viewController as? DataGridViewController {
                    if dataGridViewController != self {
                        dataGridViewController.exitVc()
                    }
                }
            }
        }
        dismiss(animated: false, completion: nil)
    }
    
    func completionError(_ error: ErrorCode) {
        DispatchQueue.main.async {
            [unowned self] in
            SwiftSpinner.hide()
            self.sendAlert(error)
            if error.isAuthError {
                Credentials.deleteCredentials()
                self.clearData()
            }
        }
    }
    
    func clearData() {
        DbOperation.databaseDelete()
    }
    
    func showFilterActionSheet(column: DataGridColumn, rowIndex: Int32, panel: GridPanel, flexGrid: FlexGrid) {
        let actionSheet = UIAlertController(title: column.header, message: nil, preferredStyle: .actionSheet)
        let filterButton = UIAlertAction(title: "Filter", style: .default) {
            [unowned self](alert) -> Void in
            self.performSegue(withIdentifier: "showFiltersViewController", sender: column)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRect(forRow: rowIndex, inColumn: column.index)
        actionSheet.addAction(filterButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func copyData(_ flexGrid: FlexGrid, moduleType: Module) {
        if let stringSelection = DataExport.copyGrid(copySelection: true, flexGrid: flexGrid, classType: classType, moduleType: moduleType, isManager: isManager) {
            UIPasteboard.general.string = stringSelection
        }
    }
    
    func emailData(_ flexGrid: FlexGrid, moduleType: Module) {
        SwiftSpinner.show("Exporting...", animated: false) {
            () -> Void in
            DispatchQueue.main.async {
                [unowned self] in
                guard let mailComposer = DataExport.excelExport(flexGrid: flexGrid, classType: self.classType, moduleType: moduleType, isManager: self.isManager) else {
                    DispatchQueue.main.async {
                        SwiftSpinner.hide()
                    }
                    return
                }
                mailComposer.mailComposeDelegate = self
                self.present(mailComposer, animated: true, completion: nil)
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                }

            }
        }
    }

    
    func showShareActionSheet(flexGrid: FlexGrid, moduleType: Module, sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Copy / Email Data", message: nil, preferredStyle: .actionSheet)
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

    func segueFiltersViewController(segue: UIStoryboardSegue, sender:AnyObject?) {
        guard let column = sender as? DataGridColumn,
            let filtersViewController = segue.destination as? FiltersViewController else {
                return
        }
        filtersViewController.filterDelegate = self
        filtersViewController.columnFilters = column.columnFilters
        filtersViewController.columnIndex = Int(column.index)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func changedFilters(columnIndex: Int) {
        isFilterChanged = true
    }
    
    func changedColumnFilters() {
        isFilterChanged = true
    }
    
    func resetLastFormattedRow() {
        lastFormattedRow = 0
    }
    
    func filterRefresh(){
        guard isFilterChanged else {
            return
        }
        let filterImage = flexGrid.hasFilters() ? UIImage(named: "Full Filters") : UIImage(named: "Clear Filters")
        SwiftSpinner.show("Loading...", animated: false) {
            [unowned self] () -> Void in
            DispatchQueue.main.async {
                [unowned self] in
                self.filterGrid(self.searchBar?.text ?? "")
                self.removeFilterButton.image = filterImage
                SwiftSpinner.hide()
            }
        }
    }
    
    func getBackgroundColor(_ row: Int32) -> UIColor? {
        var backgroundColor: UIColor? = nil
        guard moduleType != Module.accounts else {
            return flexGrid.getAccountColor(row)
        }
        guard moduleType != Module.orderList else {
            return flexGrid.getOrderListColor(row)
        }
        guard moduleType != Module.sampleList else {
            return flexGrid.getSampleListColor(row)
        }
        if flexGrid.isRestrictedItem(row) {
            backgroundColor = GridSettings.colorRestricted
        } else if flexGrid.isFocusItem(row) {
            backgroundColor = GridSettings.colorFocus
        }
        return backgroundColor
    }
    
    func getTextColor(_ row: Int32, col: Int32) -> UIColor? {
        guard moduleType != Module.orderList else {
            return flexGrid.getOrderListTextColor(row, col: col)
        }
        return UIColor.black
    }
    
    func formatItem(_ sender: FlexGrid, panel: GridPanel, for range: GridCellRange, in context: CGContext)  -> Bool {
        guard panel.cellType == GridCellType.cell else {
            return false
        }
        let isSelected = panel.fillColor == flexGrid.selectionBackgroundColor ? true : false
        let backgroundColor = getBackgroundColor(range.row)
        panel.textAttributes[NSAttributedStringKey.foregroundColor] = getTextColor(range.row, col: range.col) ?? panel.fillColor
        if !isSelected && backgroundColor != nil {
            context.setFillColor(backgroundColor!.cgColor)
            let r = panel.getCellRect(forRow: range.row, inColumn: range.col)
            context.fill(r)
        }
        if range.row == 0 || (range.col==range.rightCol && lastFormattedRow < range.bottomRow && flexGrid.rows.count > 0)
        {
            flexGrid.autoSizeRow(range.row)
            lastFormattedRow = range.row
        }
        return false
    }

    func loadedRows(_ sender: FlexGrid) {
        DispatchQueue.main.async {
            [weak self] in
            guard let flexGrid = self?.flexGrid else {
                return
            }
            guard flexGrid.rows.count > 0 else {
                return
            }
            flexGrid.autoSizeRows()
        }
        resetLastFormattedRow()
    }
    
    func resizedColumn(_ sender: FlexGrid, column: GridColumn) {
        resetLastFormattedRow()
    }
    
    func selectionChanged(_ sender: FlexGrid, panel:GridPanel, for range: GridCellRange?) {
        guard let range = range else {
            return
        }
        setItemLabels(selectedRow: range.row)
    }
    
    func sortingColumn(_ sender: FlexGrid, panel:GridPanel, for range:GridCellRange) -> Bool {
        guard let collectionView = flexGrid.collectionView else {
            return true
        }
        SwiftSpinner.show("Sorting...", animated: false) {
            [unowned self] in
            guard let col = self.flexGrid.columns.object(at: UInt(range.col)) as? DataGridColumn else {
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                }
                return
            }
            if range.col == self.lastSortedColumn {
                self.isSortAscending = !self.isSortAscending
            } else {
                self.isSortAscending = true
            }
            self.lastSortedColumn = range.col
            let binding = col.sortMemberPath ?? col.binding
            collectionView.sortDescriptions.removeAllObjects()
            guard let sd = XuniSortDescription(property: binding, ascending: self.isSortAscending) else {
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                }
                return
            }
            collectionView.sortDescriptions.add(sd)
            self.flexGrid.setNeedsDisplay()
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
        }
        return true
    }
    

    func cellDoubleTapped(_ sender: FlexGrid, panel: GridPanel, for range: GridCellRange?) -> Bool {
        guard let range = range else {
            return false
        }
        guard range.col >= 0 else {
            return false
        }
        guard panel.cellType == GridCellType.columnHeader else {
            return false
        }
        guard let column = flexGrid.columns.object(at: UInt(range.col)) as? DataGridColumn else {
            return false
        }
        showFilterActionSheet(column: column, rowIndex: range.row, panel: panel)
        return false
    }
    
    func loadData(isSynched: Bool) {
        
    }

    func showFilterActionSheet(column: DataGridColumn, rowIndex: Int32, panel: GridPanel) {
        let actionSheet = UIAlertController(title: column.header, message: nil, preferredStyle: .actionSheet)
        let filterButton = UIAlertAction(title: "Filter", style: .default) {
            [unowned self] (alert) -> Void in
            self.performSegue(withIdentifier: "showFiltersViewController", sender: column)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRect(forRow: rowIndex, inColumn: column.index)
        actionSheet.addAction(filterButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showGroupActionSheet(_ row: GridGroupRow, panel: GridPanel) {
        guard let colIndex = flexGrid.getColumnFromGroupLevel(row.level, isManager: isManager) else {
            return
        }
        guard let column = flexGrid.columns.object(at: UInt(colIndex)) as? DataGridColumn else {
            return
        }
        let actionSheet = UIAlertController(title: column.header, message: nil, preferredStyle: .actionSheet)
        let filterButton = UIAlertAction(title: "Filter", style: .default) {
            [unowned self] (alert) -> Void in
            self.performSegue(withIdentifier: "showFiltersViewController", sender: column)
        }
        let sortButton = UIAlertAction(title: "Sort", style: .default) {
            [unowned self] (alert) -> Void in
            self.sortGroup(column)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRect(forRow: row.index, inColumn: flexGrid.firstVisibleColumn())
        actionSheet.addAction(filterButton)
        actionSheet.addAction(sortButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.up
        }
        present(actionSheet, animated: true, completion: nil)
    }

    
    func groupRows() {
        var groupDict = [Int : String]()
        for col: UInt in 0 ..< flexGrid.columns.count {
            let gridCol = flexGrid.columns.object(at: col) as! DataGridColumn
            if let groupLevel = isManager ? gridCol.groupLevelManager : gridCol.groupLevel {
                groupDict[groupLevel] = gridCol.binding
            }
        }
        let groupArray = Array(groupDict.keys).sorted(by: <)
        guard groupArray.count > 0 else {
            return
        }
        flexGrid.groupHeaderFormat = "{value}"
        for group in groupArray {
            if let collectionView = flexGrid.collectionView {
                collectionView.groupDescriptions.add(XuniPropertyGroupDescription(property: groupDict[group]))
            }
        }
    }
    
    
    func sortGroup(_ column: DataGridColumn) {
        guard let collectionView = flexGrid.collectionView else {
            return
        }
        SwiftSpinner.show("Sorting...", animated: false) {
            [unowned self] in
            if column.index == self.lastSortedColumn {
                self.isSortAscending = !self.isSortAscending
            } else {
                self.isSortAscending = true
            }
            self.lastSortedColumn = column.index
            collectionView.sortDescriptions.removeAllObjects()
            let sd: XuniSortDescription = XuniSortDescription(property: column.binding, ascending: self.isSortAscending)
            collectionView.sortDescriptions.add(sd)
            self.flexGrid.setNeedsDisplay()
            SwiftSpinner.hide()
        }
    }

    func loadingData(_ isSynched: Bool) {
        SwiftSpinner.show("Loading...", animated: false) {
            self.loadData(isSynched: isSynched)
            DispatchQueue.main.async {
                SwiftSpinner.hide()
            }
        }
    }

    
    func displayLogIn() {
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        flexGrid.finishEditing(false)
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func cancelDeleteOrderWarning(title: String, message: String, handler: @escaping CancelDeleteOrderHandler) {
        let messageController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: handler )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in }
        messageController.addAction(ok)
        messageController.addAction(cancel)
        let viewController = parent ?? self
        viewController.present(messageController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    }
}
