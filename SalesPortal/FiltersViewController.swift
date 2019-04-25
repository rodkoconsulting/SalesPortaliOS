//
//  FiltersViewController.swift
//  InventoryPortal
//
//  Created by administrator on 11/19/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit
import XuniFlexGridKit
import XuniInputKit
import XuniCalendarKit

let kOPERATORTAG = 0
let kCONDITIONTAG = 1
let kBOOLTAG = 2

protocol FiltersDelegate: class {
    func changedFilters(columnIndex: Int)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, XuniDropDownDelegate, XuniComboBoxDelegate, FilterDateDelegate {

    
    @IBOutlet weak var filtersNavigationItem: UINavigationItem!
    @IBOutlet weak var filtersTableView: UITableView!
    
    
    weak var columnFilters: ColumnFilters?
    var columnIndex: Int?
    var rowBeingEdited : Int? = nil
    weak var filterDelegate: FiltersDelegate?
    
    @IBAction func addFilter(_ sender: AnyObject) {
        guard let columnFilters = columnFilters,
                let columnIndex = columnIndex else {
            return
        }
        let newFilter = ColumnFilter(condition: columnFilters.conditionList.first!)
        columnFilters.filterList.append(newFilter)
        if let index = columnFilters.filterList.index(of: newFilter) {
            let indexPath = IndexPath(row: index, section: 0)
            filtersTableView.insertRows(at: [indexPath], with: .automatic)
        }
        filtersTableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
        filterDelegate?.changedFilters(columnIndex: columnIndex)
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filtersTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let columnFilters = columnFilters {
            filtersNavigationItem.title = "Filters - " + columnFilters.header
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showFilterDateViewController" {
            guard let filterDateViewController = segue.destination as?
                FilterDateViewController, let senderButton = sender as? UIButton else {
                return
            }
            filterDateViewController.senderTag = senderButton.tag
            filterDateViewController.delegate = self
            filterDateViewController.date = senderButton.currentTitle?.getFilterDate() ?? Date()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitVc()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let columnFilters = columnFilters else {
            return 0
        }
        return columnFilters.filterList.count
    }
    
    func initComboBox(_ comboBox: ComboBox) {
        comboBox.delegate = self
        comboBox.displayMemberPath = "name"
        comboBox.isEditable = false
        comboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
    }
    
    func toggleFilterCellUi(indexPath: IndexPath, enable: Bool) {
        guard let cell = filtersTableView.cellForRow(at: indexPath),
            let myColumnFilters = columnFilters else {
                return
        }
        let conditionItemsSource = ComboData.filterConditionData(myColumnFilters.conditionList)
        let operatorItemsSource = ComboData.filterOperatorData(myColumnFilters.operatorList)
        let operatorHeight = Double(operatorItemsSource.count * Constants.ComboCellHeight)
        let conditionHeight = Double(conditionItemsSource.count * Constants.ComboCellHeight)
        switch myColumnFilters.filterType {
        case .String, .Number:
            guard let textCell = cell as? FiltersTableViewCell else {
                return
            }
            textCell.valueText.isUserInteractionEnabled = enable;
            textCell.conditionComboBox.dropDownHeight = enable ? conditionHeight : 0
            textCell.operatorComboBox.dropDownHeight = enable ? operatorHeight : 0
        case .Date:
            guard let dateCell = cell as? DateFiltersTableViewCell else {
                return
            }
            dateCell.dateButton.isUserInteractionEnabled = enable;
            dateCell.conditionComboBox.dropDownHeight = enable ? conditionHeight : 0
            dateCell.operatorComboBox.dropDownHeight = enable ? operatorHeight : 0
        case .Bool:
            guard let boolCell = cell as? BoolFiltersTableViewCell else {
                return
            }
            boolCell.boolComboBox.isUserInteractionEnabled = enable;
            boolCell.conditionComboBox.dropDownHeight = enable ? conditionHeight : 0
            boolCell.operatorComboBox.dropDownHeight = enable ? operatorHeight : 0
        }
    }
    
    
    
        func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
            toggleFilterCellUi(indexPath: indexPath, enable: false)
        }
        
        func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)  {
            guard let indexPath = indexPath else {
                return
            }
            toggleFilterCellUi(indexPath: indexPath, enable: true)
        }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        guard let myColumnFilters = columnFilters else {
            cell = filtersTableView.dequeueReusableCell(withIdentifier: "FiltersTableCell", for: indexPath)
            return cell
        }
        let row = indexPath.row
        let filter = myColumnFilters.filterList[row]
        switch myColumnFilters.filterType {
            case .String, .Number:
                cell = filtersTableView.dequeueReusableCell(withIdentifier: "FiltersTableCell", for: indexPath)
            case .Date:
                cell = filtersTableView.dequeueReusableCell(withIdentifier: "DateFiltersTableCell", for: indexPath)
            case .Bool:
                cell = filtersTableView.dequeueReusableCell(withIdentifier: "BoolFiltersTableCell", for: indexPath)
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.selectionStyle = .none
        cell.textLabel?.backgroundColor = UIColor.clear
        let defaultConditionIndex = myColumnFilters.conditionList.index{$0 == filter.condition} ?? 0
        let conditionItemsSource = ComboData.filterConditionData(myColumnFilters.conditionList)
        let conditionIndex = UInt(myColumnFilters.conditionList.startIndex.distance(to: defaultConditionIndex))
        let conditionTag = row + myColumnFilters.filterList.count * kCONDITIONTAG
        let conditionHeight = Double(conditionItemsSource.count * Constants.ComboCellHeight)
        let defaultOperatorIndex = myColumnFilters.operatorList.index{$0 == filter.filterOperator} ?? 0
        let operatorItemsSource = ComboData.filterOperatorData(myColumnFilters.operatorList)
        let operatorIndex = UInt(myColumnFilters.conditionList.startIndex.distance(to: defaultOperatorIndex))
        let operatorTag = row + myColumnFilters.filterList.count * kOPERATORTAG
        let operatorHeight = Double(operatorItemsSource.count * Constants.ComboCellHeight)
        let defaultBoolIndex = Constants.boolList.index{$0 == filter.value} ?? 0
        let boolItemsSource = ComboData.filterBoolData()
        let boolIndex = UInt(Constants.boolList.startIndex.distance(to: defaultBoolIndex))
        let boolTag = row + myColumnFilters.filterList.count * kBOOLTAG
        let boolHeight = Double(boolItemsSource.count * Constants.ComboCellHeight)

        switch myColumnFilters.filterType {
            case .String, .Number:
                let filterCell = cell as! FiltersTableViewCell
                filterCell.valueText.delegate = self
                filterCell.valueText.text = filter.value
                filterCell.isUserInteractionEnabled = true;
                filterCell.valueText.tag = row
                filterCell.valueText.layer.borderWidth = 2
                filterCell.valueText.layer.borderColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1.0).cgColor
                filterCell.valueText.layer.cornerRadius = 8.0
                filterCell.valueText.layer.masksToBounds = true
                if myColumnFilters.filterType == .Number {
                    filterCell.valueText.keyboardType = UIKeyboardType.decimalPad
                }
                initComboBox(filterCell.conditionComboBox)
                filterCell.conditionComboBox.tag =  conditionTag
                filterCell.conditionComboBox.itemsSource = conditionItemsSource
                filterCell.conditionComboBox.selectedIndex = conditionIndex
                filterCell.conditionComboBox.dropDownHeight = conditionHeight
                initComboBox(filterCell.operatorComboBox)
                filterCell.operatorComboBox.tag =  operatorTag
                filterCell.operatorComboBox.itemsSource = operatorItemsSource
                filterCell.operatorComboBox.selectedIndex = operatorIndex
                filterCell.operatorComboBox.dropDownHeight = row == 0 ? 0 : operatorHeight
                filterCell.operatorComboBox.isHidden = row == 0
                return filterCell
            case .Date:
                let dateCell = cell as! DateFiltersTableViewCell
                initComboBox(dateCell.conditionComboBox)
                dateCell.conditionComboBox.tag =  conditionTag
                dateCell.conditionComboBox.itemsSource = conditionItemsSource
                dateCell.conditionComboBox.selectedIndex = conditionIndex
                dateCell.conditionComboBox.dropDownHeight = conditionHeight
                initComboBox(dateCell.operatorComboBox)
                dateCell.operatorComboBox.tag =  operatorTag
                dateCell.operatorComboBox.itemsSource = operatorItemsSource
                dateCell.operatorComboBox.selectedIndex = operatorIndex
                dateCell.operatorComboBox.dropDownHeight = row == 0 ? 0 : operatorHeight
                dateCell.operatorComboBox.isHidden = row == 0
                dateCell.dateButton.isUserInteractionEnabled = true;
                dateCell.dateButton.tag = row
                let filterDate = filter.value.getGridDate() ?? Date()
                dateCell.dateButton.setTitle(filterDate.getDateShipPrint(), for: UIControl.State())
                myColumnFilters.filterList[row].value = filterDate.getDateGridString()
                return dateCell
            case .Bool:
                let boolCell = cell as! BoolFiltersTableViewCell
                initComboBox(boolCell.conditionComboBox)
                boolCell.conditionComboBox.tag =  conditionTag
                boolCell.conditionComboBox.itemsSource = conditionItemsSource
                boolCell.conditionComboBox.selectedIndex = conditionIndex
                boolCell.conditionComboBox.dropDownHeight = conditionHeight
                initComboBox(boolCell.operatorComboBox)
                boolCell.operatorComboBox.tag =  operatorTag
                boolCell.operatorComboBox.itemsSource = operatorItemsSource
                boolCell.operatorComboBox.selectedIndex = operatorIndex
                boolCell.operatorComboBox.dropDownHeight = row == 0 ? 0 : operatorHeight
                boolCell.operatorComboBox.isHidden = row == 0
                initComboBox(boolCell.boolComboBox)
                boolCell.boolComboBox.tag =  boolTag
                boolCell.boolComboBox.itemsSource = boolItemsSource
                boolCell.boolComboBox.selectedIndex = boolIndex
                boolCell.boolComboBox.dropDownHeight = boolHeight
                myColumnFilters.filterList[row].value = Constants.boolList[defaultBoolIndex]
                return boolCell
        }
    }
    
    
    func tableView(_ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            resignTextField()
            if editingStyle == .delete {
                if let filter = columnFilters?.filterList[indexPath.row] {
                    removeFilter(filter)
                }
                filtersTableView.deleteRows(at: [indexPath], with: .automatic)
                filtersTableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
                guard let columnIndex = columnIndex else {
                        return
                }
                filterDelegate?.changedFilters(columnIndex: columnIndex)
            }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let myColumnFilters = columnFilters,
            let columnIndex = columnIndex else {
            return
        }
        let row = textField.tag
        myColumnFilters.filterList[row].value = textField.text ?? ""
        rowBeingEdited = nil
        filterDelegate?.changedFilters(columnIndex: columnIndex)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        rowBeingEdited = textField.tag
    }
    
    func resignTextField() {
        if let row = rowBeingEdited,
            let cell = filtersTableView.cellForRow(at: IndexPath(row:row, section:0)) as? FiltersTableViewCell {
                cell.valueText.resignFirstResponder()
            }
        }
    
    func isComboBox(_ comboTag: Int, constantTag: Int, rowCount: Int) -> Bool {
        return comboTag >=  rowCount * constantTag && comboTag < rowCount * constantTag + rowCount
    }
    
    func selectedIndexChanged(_ sender: XuniComboBox!) {
        guard let columnFilters = columnFilters,
            let columnIndex = columnIndex else {
                return
        }
        let rowCount = columnFilters.filterList.count
        if isComboBox(sender.tag, constantTag: kCONDITIONTAG, rowCount: rowCount) {
            let selectedIndex = sender.tag - rowCount * kCONDITIONTAG
            columnFilters.filterList[selectedIndex].condition = columnFilters.conditionList[Int(sender.selectedIndex)]
        }
        if isComboBox(sender.tag, constantTag: kOPERATORTAG, rowCount: rowCount) {
            let selectedIndex = sender.tag - rowCount * kOPERATORTAG
            columnFilters.filterList[selectedIndex].filterOperator = columnFilters.operatorList[Int(sender.selectedIndex)]
        }
        if isComboBox(sender.tag, constantTag: kBOOLTAG, rowCount: rowCount) {
            let selectedIndex = sender.tag - rowCount * kBOOLTAG
            columnFilters.filterList[selectedIndex].value = Constants.boolList[Int(sender.selectedIndex)]
        }
        filterDelegate?.changedFilters(columnIndex: columnIndex)
    }
    
    func didChangeFilterDate(_ date: String, tag: Int) {
        guard let myColumnFilters = columnFilters,
            let columnIndex = columnIndex else {
                return
        }
        let row = tag
        myColumnFilters.filterList[row].value = date
        filtersTableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
        filterDelegate?.changedFilters(columnIndex: columnIndex)
    }
    
    func removeFilter(_ filter: ColumnFilter) {
        if let index = columnFilters?.filterList.index(of: filter) {
            columnFilters!.filterList.remove(at: index)
        }
    }
    
    func deinitComboBox(_ comboBox: ComboBox) {
        comboBox.selectedItem = nil
        comboBox.itemsSource.removeAllObjects()
        comboBox.collectionView.removeAllObjects()
        comboBox.delegate = nil
    }
    
    func exitVc() {
        for row in 0 ..< filtersTableView.numberOfRows(inSection: 0) {
            let filterCell = filtersTableView.cellForRow(at: IndexPath(row: row, section: 0))
            guard let cell = filterCell else {
                continue
            }
            if cell.isKind(of: FiltersTableViewCell.self) {
                if let cell = cell as? FiltersTableViewCell {
                    deinitComboBox(cell.conditionComboBox)
                    deinitComboBox(cell.operatorComboBox)
                }
            } else if cell.isKind(of: DateFiltersTableViewCell.self) {
                if let cell = cell as? DateFiltersTableViewCell {
                    deinitComboBox(cell.conditionComboBox)
                    deinitComboBox(cell.operatorComboBox)
                }
            } else if cell.isKind(of: BoolFiltersTableViewCell.self) {
                if let cell = cell as? BoolFiltersTableViewCell {
                    deinitComboBox(cell.conditionComboBox)
                    deinitComboBox(cell.operatorComboBox)
                    deinitComboBox(cell.boolComboBox)
                }
            }
            
        }
    }
}
