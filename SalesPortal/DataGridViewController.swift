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


class DataGridViewController: UIViewController, FiltersDelegate,MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, MPGTextFieldDelegate, FlexGridDelegate {
   
    @IBOutlet weak var searchBar: MPGTextField_Swift! = nil
    @IBOutlet weak var flexGrid: FlexGrid! = nil
    @IBOutlet weak var descriptionLabel: UILabel! = nil
    @IBOutlet weak var restrictionLabel: UILabel! = nil
    @IBOutlet weak var clearFilterButton: UIButton! = nil
    @IBOutlet weak var selectModeSegment: UISegmentedControl! = nil
    @IBOutlet weak var titleLabel: UILabel! = nil
    
    @IBAction func clearFilter() {
        SwiftSpinner.show("Loading...", animated: false) {
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
    
    @IBAction func shareData(sender: UIBarButtonItem) {
        showShareActionSheet(flexGrid: flexGrid, moduleType: moduleType, sender: sender)
    }
    
    var moduleType = Module.Inventory
    var classType: NSObject.Type = Inventory.self
    var searchData: [[String : AnyObject]] = [[String : AnyObject]]()
    var gridData: NSMutableArray?
    var activeField: CGRect?
    var topCell: CGRect?
    var changedY = false
    var keyboardHeight: CGFloat = 300
    var lastSortedColumn : Int32 = -1
    var lastFormattedRow : Int32 = 0
    var isSortAscending = true
    var isFilterChanged = false
    var currentSelectionMode = Constants.defaultSelectionMode
    var isLoaded: Bool = false
    var isSettingsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar?.mDelegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DataGridViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DataGridViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func dataForPopoverInTextField(textfield: MPGTextField_Swift) -> [[String : AnyObject]]
    {
        return searchData
    }
    
    func textFieldShouldSelect(textField: MPGTextField_Swift) -> Bool{
        return true
    }
    
    func textFieldDidEndEditing(textField: MPGTextField_Swift, isIndex: Bool = false){
        if isIndex {
            filterIndex()
        } else {
            filterData()
        }
    }
    
    func initGrid() {
        flexGrid.isReadOnly = false
        flexGrid.delegate = self
        flexGrid.gridLayout(moduleType)
        flexGrid.itemsSource = gridData
    }
    
    func filterData() {
        SwiftSpinner.show("Searching...", animated: false) {
            _ in
            //self.searchBar.resignFirstResponder()
            self.filterGrid(self.searchBar.text ?? "")
            dispatch_async(dispatch_get_main_queue()) {
                SwiftSpinner.hide()
            }
        }
    }
    
    func filterIndex(){
        filterGrid(self.searchBar.text ?? "", isIndex: true)
    }
    
    func filterGrid(filterText: String?, isIndex: Bool = false) {
        flexGrid.selectionMode = FlexSelectionMode.Row
        self.filterGridColumns(filterText, classType: classType, isIndex: isIndex)
        self.isFilterChanged = false
    }
    
    
    
    func filterGridColumns<T: NSObject>(searchText: String?, classType: T.Type, isIndex: Bool = false) {
        flexGrid.collectionView.filter = {(item : NSObject?) -> Bool in
            guard let row = item as? T else {
                return false
            }
            if isIndex {
                return self.flexGrid.filterIndex(searchText, row: row, moduleType: self.moduleType)
            } else {
                return self.flexGrid.filterColumns(searchText, row: row)
            }
            } as IXuniPredicate
        resetGrid()
    }

    func resetGrid() {
        if self.flexGrid.rows.count > 0 {
            self.flexGrid.scrollRowIntoView(0, forColumn: 0)
            self.flexGrid.selectionMode = self.currentSelectionMode
        }
        clearSelectedCells()
    }
    
    func searchTextChanged() {
        flexGrid.finishEditing(false)
        if clearFilterButton.enabled == false {
            clearFilterButton.enabled = true
        }
    }
    
    func clearGridSource() {
        if flexGrid.collectionView != nil {
            flexGrid.collectionView.removeAllObjects()
        }
        if flexGrid.itemsSource != nil {
            flexGrid.itemsSource.removeAllObjects()
        }
    }
    
    func setGridSource() {
        flexGrid.itemsSource = gridData
        isFilterChanged = false
        filterGridColumns(self.searchBar.text!, classType: classType)
        resetGrid()
        setTitleLabel()
    }
    
    func setTitleLabel() {
    
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
        if descriptionLabel != nil {
            descriptionLabel.text = inventory.itemDescription
            restrictionLabel.text = inventory.restrictedList
        }
    }

    func keyboardWillShow(sender: NSNotification) {
        guard let kbFrame = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        let keyboard = self.view.convertRect(kbFrame, fromView: self.view.window)
        let height = self.view.frame.size.height
        guard ((keyboard.origin.y + keyboard.size.height) <= height) else {
            return
        }
        let kbSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        keyboardHeight = kbSize!.height
        var aRect = self.view.frame;
        aRect.size.height = aRect.size.height - kbSize!.height - CGFloat(20);
        guard let activeField = activeField,
            let topCell = topCell else {
            return
        }
        let activeFieldOffSet = activeField.origin.y - keyboardHeight + CGFloat(50)
        let topCellOrigin = topCell.origin.y
        if activeFieldOffSet > topCellOrigin {
        //if !CGRectContainsPoint(aRect, activeField.origin) {
            if (!changedY) {
                self.view.frame.origin.y -= keyboardHeight
            }
            changedY = true
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if changedY {
            self.view.frame.origin.y += keyboardHeight
        }
        changedY = false
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    func sendAlert(error: ErrorCode) {
        let alertController = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertController.addAction(ok)
        let viewController = self.parentViewController ?? self
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func longPressInitialize(flexGrid: FlexGrid) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPress.numberOfTouchesRequired = 1
        longPress.minimumPressDuration = 1.0
        longPress.allowableMovement = 10
        longPress.delegate = self
        flexGrid.addGestureRecognizer(longPress)
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer) {

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
    
    func clearData() {
        DbOperation.databaseDelete()
    }
    
    func showFilterActionSheet(column column: GridColumn, rowIndex: Int32, panel: FlexGridPanel, flexGrid: FlexGrid) {
        let actionSheet = UIAlertController(title: column.header, message: nil, preferredStyle: .ActionSheet)
        let filterButton = UIAlertAction(title: "Filter", style: .Default) {
            (alert) -> Void in
            self.performSegueWithIdentifier("showFiltersViewController", sender: column)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRectForRow(rowIndex, inColumn: column.index)
        actionSheet.addAction(filterButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func copyData(flexGrid: FlexGrid) {
        if let stringSelection = DataExport.copyGrid(copySelection: true, flexGrid: flexGrid) {
            UIPasteboard.generalPasteboard().string = stringSelection
        }
    }
    
    func emailData(flexGrid: FlexGrid, moduleType: Module) {
        SwiftSpinner.show("Exporting...", animated: false) {
            _ in
            dispatch_async(dispatch_get_main_queue()) {
                guard let mailComposer = DataExport.excelExport(flexGrid: flexGrid, mailSubject: moduleType.mailSubject, mailBody: moduleType.mailBody, attachmentName: moduleType.mailAttachment) else {
                    SwiftSpinner.hide()
                    return
                }
                mailComposer.mailComposeDelegate = self
                self.presentViewController(mailComposer, animated: true, completion: nil)
                SwiftSpinner.hide()
            }
        }
    }

    
    func showShareActionSheet(flexGrid flexGrid: FlexGrid, moduleType: Module, sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Copy / Email Data", message: nil, preferredStyle: .ActionSheet)
        let copyButton = UIAlertAction(title: "Copy", style: .Default) {
            (alert) -> Void in
                self.copyData(flexGrid)
        }
        let emailButton = UIAlertAction(title: "Email", style: .Default) {
            (alert) -> Void in
                self.emailData(flexGrid, moduleType: moduleType)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
        }
        //let rect = panel.getCellRectForRow(rowIndex, inColumn: column.index)
        if flexGrid.selection != nil {
            actionSheet.addAction(copyButton)
        }
        actionSheet.addAction(emailButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    func segueFiltersViewController(segue segue: UIStoryboardSegue, sender:AnyObject?) {
        guard let column = sender as? GridColumn,
            let filtersViewController = segue.destinationViewController as? FiltersViewController else {
                return
        }
        filtersViewController.filterDelegate = self
        filtersViewController.columnFilters = column.columnFilters
        filtersViewController.columnIndex = Int(column.index)
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changedFilters(columnIndex columnIndex: Int) {
        isFilterChanged = true
    }
    
    func changedColumnFilters() {
        isFilterChanged = true
    }
    
    func resetLastFormattedRow() {
        lastFormattedRow = 0
    }
    
    func filterRefresh(){
        guard self.isFilterChanged else {
            return
        }
        SwiftSpinner.show("Loading...", animated: false) {
            _ in
            dispatch_async(dispatch_get_main_queue()) {
                self.filterGrid(self.searchBar.text!)
                SwiftSpinner.hide()
            }
        }
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
    
    func longPressInitialize() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DataGridViewController.handleLongPress(_:)))
        longPress.numberOfTouchesRequired = 1
        longPress.minimumPressDuration = 1.0
        longPress.allowableMovement = 10
        longPress.delegate = self
        flexGrid.addGestureRecognizer(longPress)
    }
    
    func gridColumnLayout() {
        flexGrid.autoGenerateColumns = false
        flexGrid.isEnabled = true
        flexGrid.selectionBackgroundColor = GridSettings.colorSelected
        flexGrid.selectionTextColor = GridSettings.selectionTextColor
        flexGrid.font = GridSettings.defaultFont
        flexGrid.columnHeaderFont = GridSettings.columnHeaderFont
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultColumnSettings = ColumnSettings.generateColumnSettings(defaults.objectForKey(moduleType.columnSettings) as? [[String : AnyObject]])
        let columns = GridColumn.generateColumns(defaultColumnSettings, module: moduleType)
        for column in columns {
            flexGrid.columns.addObject(column)
        }
    }
    
    func getBackgroundColor(row: Int32) -> UIColor? {
        var backgroundColor: UIColor? = nil
        guard moduleType != Module.Accounts else {
            return backgroundColor
        }
        if flexGrid.isRestrictedItem(row) {
            backgroundColor = GridSettings.colorRestricted
        } else if flexGrid.isFocusItem(row) {
            backgroundColor = GridSettings.colorFocus
        }
        return backgroundColor
    }

    func formatItem(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!, inContext context: CGContext!)  -> Bool {
        guard panel.cellType == FlexCellType.Cell else {
            return false
        }
        let isSelected = panel.fillColor == flexGrid.selectionBackgroundColor ? true : false
        let backgroundColor = getBackgroundColor(range.row)
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
    
    func resizedColumn(sender: FlexGrid!, column: FlexColumn!) {
        resetLastFormattedRow()
    }
    
    func selectionChanged(sender: FlexGrid!, panel:FlexGridPanel!, forRange range: FlexCellRange!) {
        setItemLabels(selectedRow: range.row)
    }
    
    
    func sortingColumn(sender: FlexGrid!, panel:FlexGridPanel!, forRange range:FlexCellRange!) -> Bool {
        SwiftSpinner.show("Sorting...", animated: false) {
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
    
    
    func autoSizeColumns() {
        for col: UInt in 0 ..< self.flexGrid.columns.count {
            let gridCol = flexGrid.columns.objectAtIndex(col) as! GridColumn
            if gridCol.autosize {
                self.flexGrid.autoSizeColumn(Int32(col))
            }
        }
    }

    func cellDoubleTapped(sender: FlexGrid!, panel: FlexGridPanel!, forRange range: FlexCellRange!) -> Bool {
        guard panel != nil && panel.cellType == FlexCellType.ColumnHeader else {
            return false
        }
        guard let column = flexGrid.columns.objectAtIndex(UInt(range.col)) as? GridColumn else {
            return false
        }
        showFilterActionSheet(column: column, rowIndex: range.row, panel: panel)
        return false
    }
    
    func loadData(isSynched isSynched: Bool) {
        
    }

    func showFilterActionSheet(column column: GridColumn, rowIndex: Int32, panel: FlexGridPanel) {
        let actionSheet = UIAlertController(title: column.header, message: nil, preferredStyle: .ActionSheet)
        let filterButton = UIAlertAction(title: "Filter", style: .Default) {
            (alert) -> Void in
            self.performSegueWithIdentifier("showFiltersViewController", sender: column)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
        }
        let rect = panel.getCellRectForRow(rowIndex, inColumn: column.index)
        actionSheet.addAction(filterButton)
        actionSheet.addAction(cancelButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = flexGrid
            popoverController.sourceRect = rect
        }
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    func loadingData(isSynched: Bool) {
        SwiftSpinner.show("Loading...", animated: false) {
            _ in
            self.loadData(isSynched: isSynched)
        }
    }
    
    func displayLogIn() {
        performSegueWithIdentifier("showLogin", sender: self)
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        flexGrid.finishEditing(false)
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


}
