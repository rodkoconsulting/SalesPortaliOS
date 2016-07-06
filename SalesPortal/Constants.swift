//
//  Constants.swift
//  InventoryPortal
//
//  Created by administrator on 4/18/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation
import XuniFlexGridKit

enum Module {
    case Inventory
    case Accounts
    case OrderInventory
    case OrderHeader
    case OrderHistory
}

extension Module {
    var mailSubject: String {
        switch self {
        case Inventory:
            return "iOS Inventory Excel file"
        case OrderInventory:
            return "iOS Order Inventory Excel file"
        case OrderHeader:
            return "iOS Order Excel file"
        case OrderHistory:
            return "iOS Order History Excel file"
        case Accounts:
            return "iOS Accounts Excel file"
        }
    }
    
    var mailBody: String {
        switch self {
        case Inventory:
            return "Attached is the Excel Inventory data from the iOS Sales Portal."
        case OrderInventory:
            return "Attached is the Excel Order Inventory data from the iOS Sales Portal."
        case .OrderHeader:
            return "Attached is the Excel Order data from the iOS Sales Portal."
        case OrderHistory:
            return "Attached is the Excel Order History from the iOS Sales Portal."
        case Accounts:
            return "Attached is the Excel Account data from the iOS Sales Portal."
        }
    }
    
    var mailAttachment: String {
        switch self {
        case Inventory:
            return "InventoryPortalExport.csv"
        case OrderInventory:
            return "OrderInventoryPortalExport.csv"
        case OrderHeader:
            return "OrderDataPortalExport.csv"
        case .OrderHistory:
            return "OrderHistoryPortalExport.csv"
        case Accounts:
            return "AccountPortalExport.csv"
        }
    }
    
    var columnData: [[String:AnyObject]] {
        let columnData = ColumnData()
        switch self {
        case Inventory:
            return columnData.inventoryColumns
        case OrderInventory:
            return columnData.orderInventoryColumns
        case .OrderHeader:
            return columnData.orderHeaderColumns
        case .OrderHistory:
            return columnData.orderHistoryColumns
        case Accounts:
            return columnData.accountColumns
        }
    }
    
    var columnSettings: String {
        switch self {
        case Inventory:
            return "columnSettingsInventory"
        case OrderInventory:
            return "columnSettingsOrderInventory"
        case .OrderHeader:
            return "columnSettingsOrderHeader"
        case .OrderHistory:
            return "columnSettingsOrderHistory"
        case Accounts:
            return "columnSettingsAccounts"
        }
    }
    
    var apiInit: String {
        switch self {
        case Inventory:
            return "inventory/"
        case OrderInventory:
            return "inventory/"
        case .OrderHeader:
            return "inventory/"
        case .OrderHistory:
            return "inventory/"
        case Accounts:
            return "account/"
        }
    }
    
    var moduleTable: String {
        switch self {
        case Inventory:
            return "INV"
        case OrderInventory:
            return "INV"
        case OrderHeader:
            return "INV"
        case OrderHistory:
            return "INV"
        case Accounts:
            return "ACCOUNTS"
        }
    }
    
    var index: String {
        switch self {
        case Inventory, .OrderInventory, .OrderHistory, .OrderHeader:
            return "itemCode"
        case Accounts:
            return "customerNo"
        }
    }
    
    var syncTable: [String : String] {
        switch self {
            case Inventory:
                return ["qty":"INV_QTY","price":"INV_PRICE","desc":"INV_DESC","po":"INV_PO"]
            case OrderInventory:
                return ["qty":"INV_QTY","price":"INV_PRICE","desc":"INV_DESC","po":"INV_PO"]
            case OrderHistory:
                return ["qty":"INV_QTY","price":"INV_PRICE","desc":"INV_DESC","po":"INV_PO"]
            case .OrderHeader:
                return ["qty":"INV_QTY","price":"INV_PRICE","desc":"INV_DESC","po":"INV_PO"]
            case Accounts:
                return ["list":"ACCOUNTS_LIST", "HistH":"ACCOUNTS_INV_HEAD", "HistD":"ACCOUNTS_INV_DET", "Inact": "ACCOUNTS_ITEMS_INACTIVE"  ]
        }
    }
}


struct Constants {
    static let databasePath = NSURL(fileURLWithPath:NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]).URLByAppendingPathComponent("polPortal15.db").absoluteString
    static let hourCutoff = 16
    static let minuteCutoff = 10
    static let defaultSelectionMode = FlexSelectionMode.CellRange
    static let timeSyncDefault = "2000-01-01 00:00:00.000"
    static let stateValues = ["NY", "NJ"]
    static let boolList = ["True", "False"]
    static let shipDays = 14
    static let coopCaseList = [5,10]
    static let noCoopText = "None"
}