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
    func flexAutoSizeColumns() {
        for col: UInt in 0 ..< self.columns.count {
            let gridCol = self.columns.objectAtIndex(col) as! GridColumn
            if gridCol.autosize {
                self.autoSizeColumn(Int32(col))
            }
        }
    }
    
    func gridLayout(moduleType: Module) {
        self.alternatingRowBackgroundColor = GridSettings.alternatingRowBackgroundColor
        self.gridLinesVisibility = GridSettings.gridLinesVisibility
        self.selectionMode = GridSettings.defaultSelectionMode
        self.autoGenerateColumns = false
        self.isEnabled = true
        self.selectionBackgroundColor = GridSettings.colorSelected
        self.selectionTextColor = GridSettings.selectionTextColor
        self.font = GridSettings.defaultFont
        self.columnHeaderFont = GridSettings.columnHeaderFont
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultColumnSettings = ColumnSettings.generateColumnSettings(defaults.objectForKey(moduleType.columnSettings) as? [[String : AnyObject]])
        let columns = GridColumn.generateColumns(defaultColumnSettings, module: moduleType)
        for column in columns {
            self.columns.addObject(column)
        }
    }
    
    func sortColumns() {
        for col: UInt in 0 ..< self.columns.count {
            if let gridCol = self.columns.objectAtIndex(col) as? GridColumn {
                self.sortColumn(gridCol)
            }
        }
    }
    
    func sortColumn(column: GridColumn) {
        guard let isSortAscending = column.isSortAscending else {
            return
        }
        let sd = XuniSortDescription(property: column.binding, ascending: isSortAscending)
        self.collectionView.sortDescriptions.addObject(sd)
    }
    
    func isRestrictedItem(row: Int32) -> Bool {
        guard let flexRow = self.rows.objectAtIndex(UInt(row)) as? FlexRow,
            let inventory = flexRow.dataItem as? Inventory else {
                return false
        }
        return inventory.isRestricted
    }
    
    func isFocusItem(row: Int32) -> Bool {
        guard let flexRow = self.rows.objectAtIndex(UInt(row)) as? FlexRow,
            let inventory = flexRow.dataItem as? Inventory else {
                return false
        }
        return inventory.focus
    }
    
    func filterIndex<T: NSObject>(searchText: String?, row: T, moduleType: Module) -> Bool {
        guard let value = row.valueForKey(moduleType.index) as? String else {
            return false
        }
        return value.lowercaseString.rangeOfString(searchText!.lowercaseString) != nil
    }
    
    func filterColumns<T: NSObject>(searchText: String?, row: T) -> Bool {
        let hasSearchText = searchText != nil && searchText != ""
        var searchMatched = !hasSearchText
        var columnFilterMatched = true
        var allFiltersMatched = true
        for index in 0...self.columns.count - 1 {
            guard let column = self.columns.objectAtIndex(index) as? GridColumn,
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
    }

    func saveColumnSettings() -> [[String : AnyObject]] {
        var myColumnSettings = [[String : AnyObject]]()
        for col: UInt in 0 ..< self.columns.count {
            var myDict = [String : AnyObject]()
            let column = self.columns.objectAtIndex(UInt(col)) as! FlexColumn
            myDict["name"] = column.name
            myDict["visible"] = column.visible
            if column.visible {
                myDict["width"] = column.width
            }
            myColumnSettings.append(myDict)
        }
        return myColumnSettings
    }
    
    func saveUserDefaults(moduleType: Module) {
        let columnSettings = self.saveColumnSettings()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(columnSettings, forKey: moduleType.columnSettings)
    }
    
}

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func rounded()-> Double
    {
        return (round(self*10000)/10000).truncate(0)
    }
}

extension String {
    func getGridDate() -> NSDate? {
        if self.containsString("+") {
            return NSDateFormatter.dateConvertedFormatter.dateFromString(self)
        }
        return NSDateFormatter.dateGridFormatter.dateFromString(self)
    }

    
    func getGridDateString() -> String {
        return self.getDate()?.getDateGridString() ?? ""
    }
    
    func getShipDatePrint() -> String {
        return self.getDate()?.getDateShipPrint() ?? ""
    }
    
    func getDate() -> NSDate? {
        return NSDateFormatter.dateFormatter.dateFromString(self)
    }
    
    func getShipDate() -> NSDate? {
        return NSDateFormatter.dateShipFormatter.dateFromString(self)
    }
    
    func getShipMonth() -> String? {
        return self.getDate()?.getMonthString()
    }
}

extension NSDateFormatter {
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    private static let dateConvertedFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss ZZZZ"
        return formatter
    }()

    
    private static let dateShipFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    private static let dateShipPrintFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE M/d/yy"
        return formatter
    }()
    
    private static let dateTimeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yy h:mm a"
        return formatter
    }()
    
    private static let monthFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private static let dateGridFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yy"
        return formatter
    }()

}

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
    }
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
    }
    
    func isAfterHours() -> Bool
    {
        var hour: Int = 0
        var minute: Int = 0
        NSCalendar.currentCalendar().getHour(&hour, minute: &minute, second: nil, nanosecond: nil, fromDate:self)
        return hour > Constants.hourCutoff || (hour > (Constants.hourCutoff - 1) && minute > Constants.minuteCutoff)
    }
    
    func addDay() -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func addWeek() -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 7, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func isHoliday() -> Bool {
        guard let path = NSBundle.mainBundle().pathForResource("Holidays", ofType: "plist"),
            let holidayDict = NSDictionary(contentsOfFile: path),
            let holidays = holidayDict["Holidays"] as? [NSDate] else {
                return false
        }
        for holiday in holidays {
            if NSCalendar.currentCalendar().isDate(self, inSameDayAsDate: holiday) {
                return true
            }
        }
        return false
    }

    func isWeekendOrHoliday() -> Bool {
        return NSCalendar.currentCalendar().isDateInWeekend(self) || isHoliday()
    }
    
    func isShipDay(shipDays:[ShipDays]?) -> Bool {
        guard !isWeekendOrHoliday() else {
            return false
        }
        guard let shipDays = shipDays else {
            return true
        }
        let dayInt = NSCalendar.currentCalendar().components(.Weekday, fromDate: self).weekday
        guard let dayEnum = ShipDays(rawValue: dayInt) else {
            return false
        }
        return shipDays.contains(dayEnum)
    }
    
    
    func getDateString() -> String {
        return NSDateFormatter.dateFormatter.stringFromDate(self)
    }
    
    func getDateShipString() -> String {
        return NSDateFormatter.dateShipFormatter.stringFromDate(self)
    }
    
    func getDateShipPrint() -> String {
        return NSDateFormatter.dateShipPrintFormatter.stringFromDate(self)
    }
    
    func getDateGridString() -> String {
        return NSDateFormatter.dateGridFormatter.stringFromDate(self)
    }
    
    func getDateTimeString() -> String {
        return NSDateFormatter.dateTimeFormatter.stringFromDate(self)
    }
    
    func getMonthString() -> String {
        return NSDateFormatter.monthFormatter.stringFromDate(self)
    }
    
    func getYearInt() -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self).year
    }
    
    func getNextWeekMonth() -> String {
        return self.addWeek().getMonthString()
    }
    
    func getNextShip(shipDays:[ShipDays]?=nil) -> (shipDate: String, shipMonth: String) {
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
    
    func getMaxShipDate(shipDays:[ShipDays]) -> NSDate {
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
   

    class func defaultPoDate() -> NSDate {
        return NSDateFormatter.dateFormatter.dateFromString(DateStrings.PoDate.rawValue)!
    }
    
    class func defaultPoEtaDate() -> NSDate {
        return NSDateFormatter.dateFormatter.dateFromString(DateStrings.PoEtaDate.rawValue)!
    }
}
