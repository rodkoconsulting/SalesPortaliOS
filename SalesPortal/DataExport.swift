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
    
    static func copyGrid(copySelection copySelection: Bool, flexGrid: FlexGrid) -> String? {
        guard flexGrid.rows.count > 0 else {
            return nil
        }
        var rowStart = copySelection ? flexGrid.selection.row : 0
        var rowEnd = copySelection ? flexGrid.selection.row2 : Int32(flexGrid.rows.count - 1)
        var columnStart = copySelection ? flexGrid.selection.col : 0
        var columnEnd = copySelection ? flexGrid.selection.col2 : Int32(flexGrid.columns.count - 1)
        
        func getColHeaderText(flexGrid: FlexGrid) -> String {
            var headerString = ""
            for index in 0...flexGrid.columns.count - 1 {
                let column = flexGrid.columns.objectAtIndex(UInt(index)) as! FlexColumn
                if column.visible {
                    headerString += "\(column.header)"
                }
                if index < flexGrid.columns.count - 1 {
                    headerString += "\t"
                }
            }
            headerString += "\n"
            return headerString
        }

        var text = copySelection ? "" : getColHeaderText(flexGrid)
        
        func getCellText(row row: Int32, column: Int32, flexGrid: FlexGrid) -> String {
            let cellData = flexGrid.getCellDataForRow(row, inColumn: column, formatted: false)
            var cellText = cellData.description
            if let _ = cellText.rangeOfString("."),
                let cellNumber = Double(cellText) {
                cellText = String(format:"%.2f", cellNumber)
            }
            cellText = cellText.stringByReplacingOccurrencesOfString("\n", withString: ",")
            return cellText
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
                let flexColumn = flexGrid.columns.objectAtIndex(UInt(column)) as! FlexColumn
                if flexColumn.visible {
                    text += getCellText(row: row, column: column, flexGrid: flexGrid)
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

    static func excelExport(flexGrid flexGrid: FlexGrid, mailSubject: String, mailBody: String, attachmentName: String) -> MFMailComposeViewController? {
        guard let stringSelection = copyGrid(copySelection: false, flexGrid: flexGrid) else {
            return nil
        }
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject(mailSubject)
        mailComposer.setMessageBody(mailBody, isHTML: true)
        let emailData = stringSelection.dataUsingEncoding(NSUTF16StringEncoding)
        guard let emailAttachment = emailData else {
            return nil
        }
        mailComposer.addAttachmentData(emailAttachment, mimeType: "application/vnd.ms-excel", fileName: attachmentName)
        return mailComposer
    }
}

