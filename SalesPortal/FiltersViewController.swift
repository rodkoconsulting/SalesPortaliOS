//
//  FiltersViewController.swift
//  InventoryPortal
//
//  Created by administrator on 11/19/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit

let kOPERATORPICKERTAG = 0
let kCONDITIONPICKERTAG = 1
let kBOOLPICKERTAG = 2

protocol FiltersDelegate {
    func changedFilters()
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, DatePickerDelegate {

    
    @IBOutlet weak var filtersNavigationItem: UINavigationItem!
    @IBOutlet weak var filtersTableView: UITableView!
    
    
    var columnFilters: ColumnFilters?
    var rowBeingEdited : Int? = nil
    var filterDelegate: FiltersDelegate?
   
    
    @IBAction func addFilter(sender: AnyObject) {
        guard let columnFilters = columnFilters else {
            return
        }
        filterDelegate?.changedFilters()
        let newFilter = ColumnFilter(condition: columnFilters.conditionList.first!)
        columnFilters.filterList.append(newFilter)
        if let index = columnFilters.filterList.indexOf(newFilter) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            filtersTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        filtersTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }

    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        filtersTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //filtersTableView.rowHeight = UITableViewAutomaticDimension
        //filtersTableView.estimatedRowHeight = 65
        filtersTableView.rowHeight = 125
        if let columnFilters = columnFilters {
            filtersNavigationItem.title = "Filters - \(columnFilters.header)"
            if columnFilters.filterType == .Date {
               filtersTableView.rowHeight = 200
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let columnFilters = columnFilters else {
            return 0
        }
        return columnFilters.filterList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        guard let myColumnFilters = columnFilters else {
            cell = filtersTableView.dequeueReusableCellWithIdentifier("FiltersTableCell", forIndexPath: indexPath)
            return cell
        }
        let row = indexPath.row
        let filter = myColumnFilters.filterList[row]
        switch myColumnFilters.filterType {
            case .String, .Number:
                cell = filtersTableView.dequeueReusableCellWithIdentifier("FiltersTableCell", forIndexPath: indexPath)
            case .Date:
                cell = filtersTableView.dequeueReusableCellWithIdentifier("DateFiltersTableCell", forIndexPath: indexPath)
            case .Bool:
                cell = filtersTableView.dequeueReusableCellWithIdentifier("BoolFiltersTableCell", forIndexPath: indexPath)
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = backgroundView
        
        switch myColumnFilters.filterType {
            case .String, .Number:
                let filterCell = cell as! FiltersTableViewCell
                filterCell.valueText.delegate = self
                filterCell.valueText.text = filter.value
                filterCell.valueText.tag = row
                filterCell.valueText.layer.borderWidth = 2
                filterCell.valueText.layer.borderColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1.0).CGColor
                filterCell.valueText.layer.cornerRadius = 8.0
                filterCell.valueText.layer.masksToBounds = true
                if myColumnFilters.filterType == .Number {
                    filterCell.valueText.keyboardType = UIKeyboardType.DecimalPad
                }
                filterCell.conditionPicker.delegate = self
                filterCell.conditionPicker.dataSource = self
                filterCell.conditionPicker.tag =  row + myColumnFilters.filterList.count * kCONDITIONPICKERTAG
                let defaultConditionIndex = myColumnFilters.conditionList.indexOf{$0 == filter.condition} ?? 0
                filterCell.conditionPicker.selectRow(defaultConditionIndex, inComponent: 0, animated: false)
                
                filterCell.operatorPicker.delegate = self
                filterCell.operatorPicker.dataSource = self
                filterCell.operatorPicker.tag = row + myColumnFilters.filterList.count * kOPERATORPICKERTAG
                let defaultOperatorIndex = myColumnFilters.operatorList.indexOf{$0 == filter.filterOperatior} ?? 0
                filterCell.operatorPicker.selectRow(defaultOperatorIndex, inComponent: 0, animated: false)
                filterCell.operatorPicker.hidden = row == 0
                return filterCell
            case .Date:
                let dateCell = cell as! DateFiltersTableViewCell
                
                dateCell.conditionPicker.delegate = self
                dateCell.conditionPicker.dataSource = self
                dateCell.conditionPicker.tag =  row + myColumnFilters.filterList.count * kCONDITIONPICKERTAG
                let defaultConditionIndex = myColumnFilters.conditionList.indexOf{$0 == filter.condition} ?? 0
                dateCell.conditionPicker.selectRow(defaultConditionIndex, inComponent: 0, animated: false)
                
                dateCell.operatorPicker.delegate = self
                dateCell.operatorPicker.dataSource = self
                dateCell.operatorPicker.tag = row + myColumnFilters.filterList.count * kOPERATORPICKERTAG
                let defaultOperatorIndex = myColumnFilters.operatorList.indexOf{$0 == filter.filterOperatior} ?? 0
                dateCell.operatorPicker.selectRow(defaultOperatorIndex, inComponent: 0, animated: false)
                dateCell.operatorPicker.hidden = row == 0
                dateCell.delegate = self
                dateCell.datePicker.tag = row
                dateCell.datePicker.datePickerMode = UIDatePickerMode.Date
                //let currentDate = NSDate()
                //let dateFormatter = NSDateFormatter()
                //dateFormatter.dateFormat = "M/d/yy"
                //let filterDate = dateFormatter.dateFromString(filter.value) ?? currentDate
                let filterDate = filter.value.getGridDate() ?? NSDate()
                dateCell.datePicker.date = filterDate
                //myColumnFilters.filterList[row].value = dateFormatter.stringFromDate(filterDate)
                myColumnFilters.filterList[row].value = filterDate.getDateGridString()
                //dateCell.datePicker.minimumDate = currentDate
                return dateCell
        case .Bool:
                let boolCell = cell as! BoolFiltersTableViewCell
                
                boolCell.conditionPicker.delegate = self
                boolCell.conditionPicker.dataSource = self
                boolCell.conditionPicker.tag =  row + myColumnFilters.filterList.count * kCONDITIONPICKERTAG
                let defaultConditionIndex = myColumnFilters.conditionList.indexOf{$0 == filter.condition} ?? 0
                boolCell.conditionPicker.selectRow(defaultConditionIndex, inComponent: 0, animated: false)
                
                boolCell.operatorPicker.delegate = self
                boolCell.operatorPicker.dataSource = self
                boolCell.operatorPicker.tag = row + myColumnFilters.filterList.count * kOPERATORPICKERTAG
                let defaultOperatorIndex = myColumnFilters.operatorList.indexOf{$0 == filter.filterOperatior} ?? 0
                boolCell.operatorPicker.selectRow(defaultOperatorIndex, inComponent: 0, animated: false)
                boolCell.operatorPicker.hidden = row == 0
                
                boolCell.boolPicker.delegate = self
                boolCell.boolPicker.dataSource = self
                boolCell.boolPicker.tag =  row + myColumnFilters.filterList.count * kBOOLPICKERTAG
                let defaultBoolIndex = Constants.boolList.indexOf{$0 == filter.value} ?? 0
                boolCell.boolPicker.selectRow(defaultBoolIndex, inComponent: 0, animated: false)
                myColumnFilters.filterList[row].value = Constants.boolList[defaultBoolIndex]
                return boolCell
        }
    }
    
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            resignTextField()
            // If the table view is asking to commit a delete command...
            if editingStyle == .Delete {
                if let filter = columnFilters?.filterList[indexPath.row] {
                    removeFilter(filter)
                }
                filterDelegate?.changedFilters()
                filtersTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                filtersTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                //filtersTableView.reloadData()
            }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let myColumnFilters = columnFilters else {
            return
        }
        let row = textField.tag
        filterDelegate?.changedFilters()
        myColumnFilters.filterList[row].value = textField.text ?? ""
        rowBeingEdited = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        rowBeingEdited = textField.tag
    }
    
    func resignTextField() {
        if let row = rowBeingEdited,
            let cell = filtersTableView.cellForRowAtIndexPath(NSIndexPath(forRow:row, inSection:0)) as? FiltersTableViewCell {
                cell.valueText.resignFirstResponder()
            }
        }
    
    func isPicker(pickerTag: Int, constantTag: Int, rowCount: Int) -> Bool {
        return pickerTag >=  rowCount * constantTag && pickerTag < rowCount * constantTag + rowCount
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let columnFilters = columnFilters else {
            return 0
        }
        let rowCount = columnFilters.filterList.count
        if isPicker(pickerView.tag, constantTag: kCONDITIONPICKERTAG, rowCount: rowCount) {
            return columnFilters.conditionList.count
        }
        if isPicker(pickerView.tag, constantTag: kOPERATORPICKERTAG, rowCount: rowCount) {
            return columnFilters.operatorList.count
        }
        if isPicker(pickerView.tag, constantTag: kBOOLPICKERTAG, rowCount: rowCount) {
            return Constants.boolList.count
        }
        return 0
    }
    
    

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let columnFilters = columnFilters else {
            return nil
        }
        let rowCount = columnFilters.filterList.count
        if isPicker(pickerView.tag, constantTag: kCONDITIONPICKERTAG, rowCount: rowCount) {
            return columnFilters.conditionList[row]
        }
        if isPicker(pickerView.tag, constantTag: kOPERATORPICKERTAG, rowCount: rowCount) {
            return columnFilters.operatorList[row].rawValue
        }
        if isPicker(pickerView.tag, constantTag: kBOOLPICKERTAG, rowCount: rowCount) {
            return Constants.boolList[row]
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let columnFilters = columnFilters else {
            return
        }
        let rowCount = columnFilters.filterList.count
        if isPicker(pickerView.tag, constantTag: kCONDITIONPICKERTAG, rowCount: rowCount) {
            let selectedIndex = pickerView.tag - rowCount * kCONDITIONPICKERTAG
            columnFilters.filterList[selectedIndex].condition = columnFilters.conditionList[row]
        }
        if isPicker(pickerView.tag, constantTag: kOPERATORPICKERTAG, rowCount: rowCount) {
            let selectedIndex = pickerView.tag - rowCount * kOPERATORPICKERTAG
            columnFilters.filterList[selectedIndex].filterOperatior = columnFilters.operatorList[row]
        }
        if isPicker(pickerView.tag, constantTag: kBOOLPICKERTAG, rowCount: rowCount) {
            let selectedIndex = pickerView.tag - rowCount * kBOOLPICKERTAG
            columnFilters.filterList[selectedIndex].value = Constants.boolList[row]
        }
        filterDelegate?.changedFilters()
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        guard let columnFilters = columnFilters else {
            return pickerLabel!
        }
        let rowCount = columnFilters.filterList.count
        if isPicker(pickerView.tag, constantTag: kCONDITIONPICKERTAG, rowCount: rowCount) {
            pickerLabel?.text = columnFilters.conditionList[row]
        }
        if isPicker(pickerView.tag, constantTag: kOPERATORPICKERTAG, rowCount: rowCount) {
            pickerLabel?.text = columnFilters.operatorList[row].rawValue
        }
        if isPicker(pickerView.tag, constantTag: kBOOLPICKERTAG, rowCount: rowCount) {
            pickerLabel?.text = Constants.boolList[row]
        }
        return pickerLabel!
    }

    func didChangePickerDate(sender sender: UIDatePicker, date: String) {
        guard let myColumnFilters = columnFilters else {
            return
        }
        let row = sender.tag
        filterDelegate?.changedFilters()
        myColumnFilters.filterList[row].value = date ?? ""
    }
    
    func removeFilter(filter: ColumnFilter) {
        if let index = columnFilters?.filterList.indexOf(filter) {
            columnFilters!.filterList.removeAtIndex(index)
        }
    }
    
}
