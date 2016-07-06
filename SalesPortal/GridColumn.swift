 //
//  GridColumn.swift
//  InventoryPortal
//
//  Created by administrator on 9/25/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation
import XuniFlexGridKit

class GridColumn: FlexColumn {
    
    var alignment: NSTextAlignment?
    var autosize: Bool
    var isSortAscending: Bool?
    var columnFilters: ColumnFilters
    
    init(myName: String, myHeader: String, myFilterType: FilterType?){
        autosize = true
        columnFilters  = ColumnFilters(header: myHeader)
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
    
    
    class func getGridColumn(columnDict : [String : AnyObject], columnSettings: ColumnSettings?) -> GridColumn {
        let filterType = FilterType(rawValue: (columnDict[kType] as? String ?? "String"))
        let gridColumn = GridColumn(myName: columnDict[kName] as! String , myHeader: columnDict[kHeader] as! String, myFilterType: filterType)
        if let width = columnDict[kWidth] as? Int {
            gridColumn.width = Double(width)
            gridColumn.autosize = false
        }
        if let minwidth = columnDict[kMinWidth] as? Int {
            gridColumn.minWidth = Int32(minwidth)
        }
        if let alignment = columnDict[kAlignment] as? String where alignment == "right" {
                gridColumn.dataType = XuniDataType.Number
        }
        //if let sortMemberPath = columnDict[kSort] as? String {
        //    gridColumn.sortMemberPath = sortMemberPath
        //}
        if let sortAscend = columnDict[kSortAcsend] as? Bool {
            gridColumn.isSortAscending = sortAscend
        }
        if let isReadOnly = columnDict[kReadOnly] as? Bool {
            gridColumn.isReadOnly = isReadOnly
        } else {
            gridColumn.isReadOnly = true
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
    
    class func generateColumns(columnSettings: [ColumnSettings]?, module: Module) -> [GridColumn] {
        let columnData = module.columnData
        var gridColumns = [GridColumn]()
        
        guard columnSettings != nil && columnSettings!.count == columnData.count else {
            for (_, myColumnData) in columnData.enumerate() {
                gridColumns.append(getGridColumn(myColumnData, columnSettings: nil))
            }
            return gridColumns
        }
        for columnSetting in columnSettings! {
            guard let myColumnData = (columnData.filter({$0[kName] as? String == columnSetting.name})).first else {
                continue
            }
            gridColumns.append(getGridColumn(myColumnData, columnSettings: columnSetting))
        }
        return gridColumns
    }
}
