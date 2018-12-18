 //
//  GridColumn.swift
//  InventoryPortal
//
//  Created by administrator on 9/25/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation
import XuniFlexGridKit

class DataGridColumn: GridColumn {
    
    var alignment: NSTextAlignment?
    var isSortAscending: Bool
    var isDefaultSort: Bool
    var columnFilters: ColumnFilters
    var groupLevel: Int?
    var groupLevelManager: Int?
    
    init(myName: String, myHeader: String, myFilterType: FilterType?){
        columnFilters  = ColumnFilters(header: myHeader)
        isSortAscending = true
        isDefaultSort = false
        super.init()
        binding = myName
        name = myName
        header = myHeader
        wordWrap = true
        allowResizing = true
        if let filterType = myFilterType {
            columnFilters.filterType = filterType
        }
    }
    
    
    class func getGridColumn(_ columnDict : [String : Any], columnSettings: ColumnSettings?) -> DataGridColumn {
        let filterType = FilterType(rawValue: (columnDict[kType] as? String ?? "String"))
        let gridColumn = DataGridColumn(myName: columnDict[kName] as! String , myHeader: columnDict[kHeader] as! String, myFilterType: filterType)
        if let width = columnDict[kWidth] as? Int {
            gridColumn.width = Double(width)
        }
        if let minwidth = columnDict[kMinWidth] as? Int {
            gridColumn.minWidth = Int32(minwidth)
        }
        if let alignment = columnDict[kAlignment] as? String, alignment == "right" {
                gridColumn.dataType = XuniDataType.number
        }
        if let format = columnDict[kFormat] as? String {
            switch format {
                case "Time":
                    gridColumn.formatter = DateFormatter.dateTimeFormatter
                default:
                    gridColumn.format = format
            }
        }
        if let aggregate = columnDict[kAgg] as? String {
            switch aggregate {
                case "Count":
                    gridColumn.aggregate = XuniAggregate.cnt
                default:
                    gridColumn.aggregate = XuniAggregate.sum
            }
        }
        if let sortMemberPath = columnDict[kSort] as? String {
            gridColumn.sortMemberPath = sortMemberPath
        }
        gridColumn.isSortAscending = columnDict[kSortAcsend] as? Bool ?? true
        gridColumn.isDefaultSort = columnDict[kSortDefault] as? Bool ?? false
        if let isReadOnly = columnDict[kReadOnly] as? Bool {
            gridColumn.isReadOnly = isReadOnly
        } else {
            gridColumn.isReadOnly = true
        }
        if let groupLevel = columnDict[kGroup] as? Int {
            gridColumn.groupLevel = groupLevel
            gridColumn.visible = false
        }
        if let managerGroup = columnDict[kManagerGroup] as? Int {
            gridColumn.groupLevelManager = managerGroup
            gridColumn.visible = false
        }
        guard let myColumnSetting = columnSettings else {
            return gridColumn
        }
        if let isVisible = myColumnSetting.visible {
            gridColumn.visible = isVisible
        }
        if let savedWidth = myColumnSetting.width {
            gridColumn.width = savedWidth
        }
        return gridColumn
    }
    
    class func generateColumns(_ columnSettings: [ColumnSettings]?, module: Module) -> ([DataGridColumn], Int) {
        let columnData = module.columnData
        var gridColumns = [DataGridColumn]()
        let savedColumnsVersion = columnSettings?[0].version
        let defaultColumnsVersion = columnData[0][kValue] as? Int
        guard savedColumnsVersion != nil && (defaultColumnsVersion == nil || savedColumnsVersion == defaultColumnsVersion) else {
            for (_, myColumnData) in columnData.enumerated() {
                guard myColumnData[kValue] == nil else {
                    continue
                }
                gridColumns.append(getGridColumn(myColumnData, columnSettings: nil))
            }
            return (gridColumns, defaultColumnsVersion ?? 1)
        }
        for columnSetting in columnSettings! {
            guard let _ = columnSetting.visible, let myColumnData = (columnData.filter({$0[kName] as? String == columnSetting.name})).first else {
                continue
            }
            gridColumns.append(getGridColumn(myColumnData, columnSettings: columnSetting))
        }
        return (gridColumns, savedColumnsVersion ?? 1)
    }
}
