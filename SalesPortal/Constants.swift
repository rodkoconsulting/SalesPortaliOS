
import Foundation
import XuniFlexGridKit

enum Module {
    case inventory
    case accounts
    case accountOrderInventory
    case sampleOrderInventory
    case accountOrder
    case sampleOrder
    case accountOrderHistory
    case sampleOrderHistory
    case orderList
    case orderMobos
    case orderSaved
    case sampleList
}

extension Module {
    var mailSubject: String {
        switch self {
        case .inventory:
            return "iOS Inventory Excel file"
        case .accountOrderInventory:
            return "iOS Order Inventory Excel file"
        case .sampleOrderInventory:
            return "iOS Sample Order Inventory Excel file"
        case .accountOrder:
            return "iOS Order Excel file"
        case .sampleOrder:
            return "iOS Sample Order Excel file"
        case .accountOrderHistory:
            return "iOS Order History Excel file"
        case .sampleOrderHistory:
            return "iOS Sample Order History Excel file"
        case .accounts:
            return "iOS Accounts Excel file"
        case .orderList:
            return "iOS Order List Excel file"
        case .orderMobos:
            return "iOS MOBOs Excel file"
        case .orderSaved:
            return "iOS Saved Orders Excel file"
        case .sampleList:
            return "iOS Sample List Excel file"
        }
    }

    var mailBody: String {
        switch self {
        case .inventory:
            return "Attached is the Excel Inventory data from the iOS Sales Portal."
        case .accountOrderInventory:
            return "Attached is the Excel Order Inventory data from the iOS Sales Portal."
        case .sampleOrderInventory:
            return "Attached is the Excel Sample Order Inventory data from the iOS Sales Portal."
        case .accountOrder:
            return "Attached is the Excel Order data from the iOS Sales Portal."
        case .sampleOrder:
            return "Attached is the Excel Sample Order data from the iOS Sales Portal."
        case .accountOrderHistory:
            return "Attached is the Excel Order History from the iOS Sales Portal."
        case .sampleOrderHistory:
            return "Attached is the Excel Sample Order History from the iOS Sales Portal."
        case .accounts:
            return "Attached is the Excel Account data from the iOS Sales Portal."
        case .orderList:
            return "Attached is the Excel Order List data from the iOS Sales Portal."
        case .orderMobos:
            return "Attached is the Excel MOBO data from the iOS Sales Portal."
        case .orderSaved:
            return "Attached is the Excel Saved Orders data from the iOS Sales Portal."
        case .sampleList:
            return "Attached is the Excel Sample List data from the iOS Sales Portal."
        }
    }
    
    var mailAttachment: String {
        switch self {
        case .inventory:
            return "InventoryPortalExport.csv"
        case .accountOrderInventory:
            return "OrderInventoryPortalExport.csv"
        case .sampleOrderInventory:
            return "SampleOrderInventoryPortalExport.csv"
        case .accountOrder:
            return "OrderDataPortalExport.csv"
        case .sampleOrder:
            return "SampleOrderDataPortalExport.csv"
        case .accountOrderHistory:
            return "OrderHistoryPortalExport.csv"
        case .sampleOrderHistory:
            return "OrderHistoryPortalExport.csv"
        case .accounts:
            return "AccountPortalExport.csv"
        case .orderList:
            return "OrderListPortalExport.csv"
        case .orderMobos:
            return "OrderMoboPortalExport.csv"
        case .orderSaved:
            return "OrderSavedPortalExport.csv"
        case .sampleList:
            return "SampleListPortalExport.csv"
        }
    }
    
    var columnData: [[String:Any]] {
        switch self {
        case .inventory:
            return ColumnData.inventoryColumns
        case .accountOrderInventory:
            return ColumnData.accountOrderInventoryColumns
        case .sampleOrderInventory:
            return ColumnData.sampleOrderInventoryColumns
        case .accountOrder:
            return ColumnData.orderHeaderColumns
        case .sampleOrder:
            return ColumnData.sampleOrderHeaderColumns
        case .accountOrderHistory:
            return ColumnData.accountOrderHistoryColumns
        case .sampleOrderHistory:
            return ColumnData.sampleOrderHistoryColumns
        case .accounts:
            return ColumnData.accountColumns
        case .orderList:
            return ColumnData.orderListColumns
        case .orderMobos:
            return ColumnData.orderMoboColumns
        case .orderSaved:
            return ColumnData.orderSavedColumns
        case .sampleList:
            return ColumnData.sampleListColumns
        }
    }
    
    var columnSettings: String {
        switch self {
        case .inventory:
            return "columnSettingsInventory"
        case .accountOrderInventory:
            return "columnSettingsAccountOrderInventory"
        case .sampleOrderInventory:
            return "columnSettingsSampleOrderInventory"
        case .accountOrder:
            return "columnSettingsOrderHeader"
        case .sampleOrder:
            return "columnSettingsSampleOrderHeader"
        case .accountOrderHistory:
            return "columnSettingsAccountOrderHistory"
        case .sampleOrderHistory:
            return "columnSettingsSampleOrderHistory"
        case .accounts:
            return "columnSettingsAccounts"
        case .orderList:
            return "columnSettingsOrderList"
        case .orderMobos:
            return "columnSettingsOrderMobos"
        case .orderSaved:
            return "columnSettingsOrderSaved"
        case .sampleList:
            return "columnSettingsSampleList"
        }
    }
    
    var apiInit: String {
        switch self {
        case .inventory:
            return "inventory/"
        case .accountOrderInventory, .sampleOrderInventory:
            return "inventory/"
        case .accountOrder:
            return "transmit/"
        case .sampleOrder:
            return "transmit_sample/"
        case .accountOrderHistory, .sampleOrderHistory:
            return "inventory/"
        case .accounts:
            return "account/2/"
        case .orderList:
            return "orders/"
        case .orderMobos:
            return "orders/"
        case .orderSaved:
            return "orders/"
        case .sampleList:
            return "samples/"

        }
    }
    
    var moduleTable: String {
        switch self {
        case .inventory:
            return "INV"
        case .accountOrderInventory, .sampleOrderInventory:
            return "INV"
        case .accountOrder:
            return "INV"
        case .sampleOrder:
            return "INV"
        case .accountOrderHistory, .sampleOrderHistory:
            return "INV"
        case .accounts:
            return "ACCOUNTS"
        case .orderList:
            return "ORDERS"
        case .orderMobos:
            return "ORDERS"
        case .orderSaved:
            return "ORDERS"
        case .sampleList:
            return "SAMPLES"
        }
    }
    
    var index: [String] {
        switch self {
        case .inventory, .accountOrderInventory, .sampleOrderInventory, .accountOrderHistory, .sampleOrderHistory,.accountOrder, .sampleOrder, .orderMobos, .orderSaved, .sampleList:
            return ["itemCode"]
        case .orderList:
            return ["itemCode", "customerNo"]
        case .accounts:
            return ["customerNo"]
        }
    }
    
    var syncTable: [String : String] {
        switch self {
            case .inventory, .accountOrderInventory, .sampleOrderInventory, .accountOrderHistory, .sampleOrderHistory, .accountOrder,.sampleOrder:
                return ["qty":"INV_QTY","price":"INV_PRICE","desc":"INV_DESC","po":"INV_PO"]
            case .accounts:
                return ["list":"ACCOUNTS_LIST", "HistH":"ACCOUNTS_INV_HEAD", "HistD":"ACCOUNTS_INV_DET", "Inact": "ACCOUNTS_ITEMS_INACTIVE", "A": "ACCOUNT_ADDRESSES"  ]
            case .orderList:
                return ["H":"ORDER_LIST_HEADER", "D":"ORDER_LIST_DETAIL"]
            case .orderMobos:
                return ["H":"ORDER_LIST_HEADER", "D":"ORDER_LIST_DETAIL"]
            case .orderSaved:
                return ["H":"ORDER_HEADER", "D":"ORDER_DETAIL"]
            case .sampleList:
                return ["H":"SAMPLE_LIST_HEADER", "D":"SAMPLE_LIST_DETAIL", "A":"SAMPLE_ADDRESSES", "I":"SAMPLE_ITEMS_INACTIVE"]

        }
    }
}


struct Constants {
    static let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    static let url = URL(fileURLWithPath: path) 
    static let filePath = url.appendingPathComponent("polPortal\(dbVersion).db").path
    static let previousFilePath = url.appendingPathComponent("polPortal\(dbVersionPrevious).db").path
    static let databasePath = URL(fileURLWithPath:NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent("polPortal\(dbVersion).db").absoluteString
    static let hourCutoff = 16
    static let minuteCutoff = 10
    static let timeSyncDefault = "2000-01-01 00:00:00.000"
    static let boolList = ["True", "False"]
    static let shipDays = 10
    static let coopCaseList = [5,10]
    static let noCoopText = "None"
    static let njCaseThreshold = 5
    static let ComboCellHeight = 45
    static let dbVersionPrevious = 61
    static let dbVersion = 62
    static let sampleOrderSegue = "showSampleOrderTabBarController"
    static let accountOrderSegue = "showAccountOrderTabBarController"
    static let masterAccountPrefix = "ZZ"
    static let boolString = "X"
}
