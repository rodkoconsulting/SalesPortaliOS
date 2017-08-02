//
//  ExcelExport.swift
//  InventoryPortal
//
//  Created by administrator on 4/20/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation
import XuniFlexGridKit
import MessageUI

struct DataExport {
    
    static func copyGrid<T: NSObject>(copySelection: Bool, flexGrid: FlexGrid, classType: T.Type, moduleType: Module, isManager: Bool) -> String? {
        guard flexGrid.rows.count > 0 else {
            return nil
        }
        
        var rowStart = copySelection ? flexGrid.selection.row : 0
        var rowEnd = copySelection ? flexGrid.selection.row2 : Int32(flexGrid.rows.count - 1)
        var columnStart = copySelection ? flexGrid.selection.col : 0
        var columnEnd = copySelection ? flexGrid.selection.col2 : Int32(flexGrid.columns.count - 1)
        
        func getColHeaderText(_ flexGrid: FlexGrid) -> String {
            var headerString = ""
            for index in 0...flexGrid.columns.count - 1 {
                let column = flexGrid.columns.objectAtIndex(UInt(index)) as! GridColumn
                if column.visible {
                    headerString += column.header ?? ""
                }
                if index < flexGrid.columns.count - 1 {
                    headerString += "\t"
                }
            }
            headerString += "\n"
            return headerString
        }

        var text = copySelection ? "" : getColHeaderText(flexGrid)
        
        func getCellText<T: NSObject>(row: Int32, column: Int32, flexGrid: FlexGrid, classType: T.Type, isManager: Bool) -> String {
            let cellData = flexGrid.getCellDataForRow(row, inColumn: column, formatted: false) ?? getGroupRowData(row, col: column, flexGrid: flexGrid, isManager: isManager)
            var cellText = cellData?.description ?? ""
            if let _ = cellText.rangeOfString("."),
                let cellNumber = Double(cellText) {
                cellText = String(format:"%.2f", cellNumber)
            }
            cellText = cellText.stringByReplacingOccurrencesOfString("\n", withString: ",")
            return cellText
        }
        
        func getGroupRowData(_ row: Int32, col: Int32, flexGrid: FlexGrid, isManager: Bool) -> NSObject? {
            guard col == flexGrid.firstVisibleColumn() else {
                return ""
            }
            guard let groupRow = flexGrid.rows.objectAtIndex(UInt(row)) as? GridGroupRow else {
                return ""
            }
            let gridRowIndex = groupRow.cellRange.row2
            guard let gridColIndex = flexGrid.getColumnFromGroupLevel(groupRow.level, isManager: isManager) else {
                return ""
            }
            return flexGrid.getCellDataForRow(gridRowIndex, inColumn: gridColIndex, formatted: false)
        }
        
        
        
        guard rowStart>=0 && columnStart>=0 else {
            return nil
        }
        if rowEnd < rowStart {
            let rowTemp = rowStart
            rowStart = rowEnd
            rowEnd = rowTemp
        }
        if columnEnd < columnStart {
            let columnTemp = columnStart
            columnStart = columnEnd
            columnEnd = columnTemp
        }
        for row in rowStart...rowEnd {
            for column in columnStart...columnEnd {
                let flexColumn = flexGrid.columns.objectAtIndex(UInt(column)) as! GridColumn
                if flexColumn.visible {
                    text += getCellText(row: row, column: column, flexGrid: flexGrid, classType: classType, isManager: isManager)
                }
                if column != columnEnd {
                    text += "\t"
                } else if column == columnEnd && row != rowEnd {
                    text += "\n"
                }
            }
        }
        return text
    }

    static func excelExport<T: NSObject>(flexGrid: FlexGrid,classType: T.Type, moduleType: Module, isManager: Bool) -> MFMailComposeViewController? {
        guard let stringSelection = copyGrid(copySelection: false, flexGrid: flexGrid, classType: classType, moduleType: moduleType, isManager: isManager) else {
            return nil
        }
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject(moduleType.mailSubject)
        mailComposer.setMessageBody(moduleType.mailBody, isHTML: true)
        let emailData = stringSelection.dataUsingEncoding(String.Encoding.utf16)
        guard let emailAttachment = emailData else {
            return nil
        }
        mailComposer.addAttachmentData(emailAttachment, mimeType: "application/vnd.ms-excel", fileName: moduleType.mailAttachment)
        return mailComposer
    }
}

