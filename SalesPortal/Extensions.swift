//
//  Dates.swift
//  InventoryPortal
//
//  Created by administrator on 10/12/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation
import UIKit
import XuniFlexGridKit

enum DateStrings : String {
    case PoDate = "10001231"
    case PoEtaDate = "19991231"
}

extension FlexGrid {
    
    func firstVisibleColumn() -> Int32 {
        for col: UInt in 0 ..< self.columns.count {
            let gridCol = self.columns.object(at: col) as! DataGridColumn
            if gridCol.visible {
                return Int32(col)
            }
        }
        return 0
    }
    
    func gridLayout(_ moduleType: Module) {
        self.alternatingRowBackgroundColor = GridSettings.alternatingRowBackgroundColor
        self.gridLinesVisibility = GridSettings.gridLinesVisibility
        self.selectionMode = GridSettings.defaultSelectionMode
        self.autoGenerateColumns = false
        self.isEnabled = true
        self.selectionBackgroundColor = GridSettings.colorSelected
        self.selectionTextColor = GridSettings.selectionTextColor
        self.font = GridSettings.defaultFont!
        self.columnHeaderFont = GridSettings.columnHeaderFont!
        let defaults = UserDefaults.standard
        let defaultColumnSettings = ColumnSettings.generateColumnSettings(defaults.object(forKey: moduleType.columnSettings) as? [[String : AnyObject]])
        let (columns, tag) = DataGridColumn.generateColumns(defaultColumnSettings, module: moduleType)
        self.tag = tag
        for column in columns {
            self.columns.add(column)
        }
    }
    
    func sortColumns() {
        for col: UInt in 0 ..< self.columns.count {
            if let gridCol = self.columns.object(at: col) as? DataGridColumn {
                self.sortColumn(gridCol)
            }
        }
    }
    
    
    func getColumnFromGroupLevel(_ groupLevel: UInt, isManager: Bool) -> Int32? {
        for col: UInt in 0 ..< self.columns.count {
            if let gridCol = self.columns.object(at: col) as? DataGridColumn {
                guard let colGroupLevel = isManager ? gridCol.groupLevelManager : gridCol.groupLevel else {
                    continue
                }
                if colGroupLevel == Int(groupLevel) {
                    return Int32(col)
                }
            }
        }
        return nil
    }

    func isSelectionVisible() -> Bool {
        return self.selection.row >= 0 &&
                self.selection.col >= 0 &&
            UInt(self.selection.row) < self.rows.count &&
            UInt(self.selection.row2) < self.rows.count &&
            UInt(self.selection.col) < self.columns.count &&
            UInt(self.selection.col2) < self.columns.count
    }
    
    func sortColumn(_ column: DataGridColumn) {
        guard let collectionView = self.collectionView else {
            return
        }
        guard let isSortAscending = column.isSortAscending else {
            return
        }
        guard let sd = XuniSortDescription(property: column.binding, ascending: isSortAscending) else {
            return
        }
        collectionView.sortDescriptions.add(sd)
    }
    
    func isRestrictedItem(_ row: Int32) -> Bool {
        let flexRow = self.rows.object(at: UInt(row))
        guard let inventory = flexRow.dataItem as? Inventory else {
                return false
        }
        return inventory.isRestricted
    }
    
    func isFocusItem(_ row: Int32) -> Bool {
        let flexRow = self.rows.object(at: UInt(row))
        guard let inventory = flexRow.dataItem as? Inventory else {
                return false
        }
        return inventory.focus
    }
    
    func getAccountColor(_ row: Int32) -> UIColor? {
        let flexRow = self.rows.object(at: UInt(row))
        guard let account = flexRow.dataItem as? Account else {
                return nil
        }
        return account.status.gridColor
    }
    
    func getOrderListColor(_ row: Int32) -> UIColor? {
        let flexRow = self.rows.object(at: UInt(row))
        guard let orderList = flexRow.dataItem as? OrderList else {
                return nil
        }
        return orderList.gridColor
    }
    
    func getSampleListColor(_ row: Int32) -> UIColor? {
        let flexRow = self.rows.object(at: UInt(row))
        guard let sampleList = flexRow.dataItem as? SampleList else {
                return nil
        }
        return sampleList.gridColor
    }
    
    func getOrderListTextColor(_ row: Int32, col: Int32) -> UIColor? {
        let defaultColor = UIColor.black
        let flexRow = self.rows.object(at: UInt(row))
        let flexCol = self.columns.object(at: UInt(col))
        guard let orderList = flexRow.dataItem as? OrderList else {
                return defaultColor
        }
        guard orderList.holdCode == "BO" && flexCol.binding == "shipExpireDate"  else {
            return defaultColor
        }
        return nil
    }
    
    func filterIndex<T: NSObject>(_ searchText: String?, row: T, moduleType: Module) -> Bool {
        for index in moduleType.index {
            if let value = row.value(forKey: index) as? String {
                if value.lowercased().range(of: searchText!.lowercased()) != nil {
                    return true
                }
            }
        }
        return false
    }
    
    func removeGestures() {
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers {
                self.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    func hasFilters() -> Bool {
        for index in 0...self.columns.count - 1 {
            guard let column = self.columns.object(at: index) as? DataGridColumn else {
                    continue
            }
            if column.columnFilters.filterList.count > 0 {
                return true
            }
        }
        return false
    }
    
    func filterColumns<T: NSObject>(_ searchText: String?, row: T) -> Bool {
        let hasSearchText = searchText != nil && searchText != ""
        var searchMatched = !hasSearchText
        var columnFilterMatched = true
        var allFiltersMatched = true
        for index in 0...self.columns.count - 1 {
            guard let column = self.columns.object(at: index) as? DataGridColumn,
                let binding = column.binding,
                let columnValue = row.value(forKey: binding) else {
                    continue
            }
            let filters = column.columnFilters.filterList
            var valueArray = "\(columnValue)".characters.split{$0 == "\n"}.map { String($0) }
            if valueArray.count == 0 {
                valueArray.append("")
            }
            for value in valueArray {
                if hasSearchText && value.lowercased().range(of: searchText!.lowercased()) != nil {
                    searchMatched = true
                }
                if filters.count > 0 {
                    columnFilterMatched = false
                    var columnResults = [(filterBool: Bool, filterOperator: FilterOperator)]()
                    for columnFilter in column.columnFilters.filterList {
                        columnResults.append((columnFilter.getResult(value: value, filterType: column.columnFilters.filterType), columnFilter.filterOperator))
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
    }

    func saveColumnSettings() -> [[String : AnyObject]] {
        var myColumnSettings = [[String : AnyObject]]()
        myColumnSettings.append(["version":self.tag as AnyObject])
        for col: UInt in 0 ..< self.columns.count {
            var myDict = [String : AnyObject]()
            let column = self.columns.object(at: UInt(col)) 
            myDict["name"] = column.name as AnyObject
            myDict["visible"] = column.visible as AnyObject
            if column.visible {
                myDict["width"] = column.width as AnyObject
            }
            myColumnSettings.append(myDict)
        }
        return myColumnSettings
    }
    
    func saveUserDefaults(_ moduleType: Module) {
        let columnSettings = self.saveColumnSettings()
        let defaults = UserDefaults.standard
        defaults.set(columnSettings, forKey: moduleType.columnSettings)
    }
    
}

extension Double
{
    func truncate(_ places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func roundedCases()-> Double
    {
        return self.roundToPlaces(4).truncate(0)
    }
    
    func roundedBottles()-> Double
    {
        return self.roundToPlaces(1).truncate(0)
    }
    
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func getGridDate() -> Date? {
        if self.contains("+") {
            return DateFormatter.dateConvertedFormatter.date(from: self)
        }
        return DateFormatter.dateGridFormatter.date(from: self)
    }
    
    func getGridDateString() -> String {
        return self.getDate()?.getDateGridString() ?? ""
    }
    
    func getShipDatePrint() -> String {
        return self.getDate()?.getDateShipPrint() ?? ""
    }
    
    func getFilterDate() -> Date? {
        return DateFormatter.dateShipPrintFormatter.date(from: self)
    }
    
    func getDate() -> Date? {
        return DateFormatter.dateFormatter.date(from: self)
    }
    
    func getDateTime() -> Date? {
        return DateFormatter.dateTimeFormatter.date(from: self)
    }
    
    func getShipDate() -> Date? {
        return DateFormatter.dateShipFormatter.date(from: self)
    }
    
    func getShipMonth() -> String? {
        return self.getDate()?.getMonthString()
    }
}

extension DateFormatter {
    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    fileprivate static let dateConvertedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss ZZZZ"
        return formatter
    }()

    
    fileprivate static let dateShipFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    fileprivate static let dateShipPrintFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE M/d/yy"
        return formatter
    }()
    
    @nonobjc static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy h:mm a"
        return formatter
    }()
    
    fileprivate static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    fileprivate static let dateGridFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        return formatter
    }()

}

extension Date
{
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool
    {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    func isLessThanDate(_ dateToCompare : Date) -> Bool
    {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
    
    func isAfterHours() -> Bool
    {
        var hour: Int = 0
        var minute: Int = 0
        (Calendar.current as NSCalendar).getHour(&hour, minute: &minute, second: nil, nanosecond: nil, from:self)
        return hour > Constants.hourCutoff || (hour > (Constants.hourCutoff - 1) && minute > Constants.minuteCutoff)
    }
    
    func addDay() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func addTwoDays() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 2, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func addWeek() -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 7, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func isHoliday() -> Bool {
        guard let path = Bundle.main.path(forResource: "Holidays", ofType: "plist"),
            let holidayDict = NSDictionary(contentsOfFile: path),
            let holidays = holidayDict["Holidays"] as? [Date] else {
                return false
        }
        for holiday in holidays {
            if Calendar.current.isDate(self, inSameDayAs: holiday) {
                return true
            }
        }
        return false
    }

    func isWeekendOrHoliday() -> Bool {
        return Calendar.current.isDateInWeekend(self) || isHoliday()
    }
    
    func isShipDay(_ shipDays:[ShipDays]?) -> Bool {
        guard !isWeekendOrHoliday() else {
            return false
        }
        guard let shipDays = shipDays else {
            return true
        }
        guard shipDays.count > 0 else {
            return true
        }
        let dayInt = (Calendar.current as NSCalendar).components(.weekday, from: self).weekday
        guard let dayEnum = ShipDays(rawValue: dayInt!) else {
            return false
        }
        return shipDays.contains(dayEnum)
    }
    
    
    func getDateString() -> String {
        return DateFormatter.dateFormatter.string(from: self)
    }
    
    func getDateShipString() -> String {
        return DateFormatter.dateShipFormatter.string(from: self)
    }
    
    func getDateShipPrint() -> String {
        return DateFormatter.dateShipPrintFormatter.string(from: self)
    }
    
    func getDateGridString() -> String {
        return DateFormatter.dateGridFormatter.string(from: self)
    }
    
    func getDateTimeString() -> String {
        return DateFormatter.dateTimeFormatter.string(from: self)
    }
    
    func getMonthString() -> String {
        return DateFormatter.monthFormatter.string(from: self)
    }
    
    func getYearInt() -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: self).year!
    }
    
    func getMonthInt() -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: self).month!
    }
    
    func getNextWeekMonth() -> String {
        return self.addWeek().getMonthString()
    }
    
    func getNextShip(_ shipDays:[ShipDays]?=nil) -> (shipDate: String, shipMonth: String) {
        var shipDate = self
        if shipDate.isAfterHours() {
            shipDate = shipDate.addDay()
        }
        while shipDate.isWeekendOrHoliday() {
            shipDate = shipDate.addDay()
        }
        shipDate = shipDate.addDay()
        while !shipDate.isShipDay(shipDays) {
            shipDate = shipDate.addDay()
        }
        return (shipDate.getDateShipString(), shipDate.getMonthString())
    }
    
    func getDailySalesDate() -> Date {
        var shipDate = self.addDay()
        while shipDate.isWeekendOrHoliday() {
            shipDate = shipDate.addDay()
        }
        return (shipDate)
    }
    
    func getDailySalesDateString() -> String {
        return self.getDailySalesDate().getDateShipString()
    }


    
    func getMaxShipDate(_ shipDays:[ShipDays]) -> Date {
        var totalShipDays = 1
        var maxShipDate = self
        while totalShipDays < Constants.shipDays {
            maxShipDate = maxShipDate.addDay()
            if maxShipDate.isShipDay(shipDays) {
                totalShipDays += 1
            }
        }
        return maxShipDate
    }
   

    static func defaultPoDate() -> Date {
        return DateFormatter.dateFormatter.date(from: DateStrings.PoDate.rawValue)!
    }
    
    static func defaultPoEtaDate() -> Date {
        return DateFormatter.dateFormatter.date(from: DateStrings.PoEtaDate.rawValue)!
    }
}
