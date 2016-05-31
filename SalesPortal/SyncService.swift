
import Foundation

let inventoryTables = ["qty":"INV_QTY","price":"INV_PRICE","desc":"INV_DESC","po":"INV_PO"]
let accountTables = ["list":"ACCOUNT_LIST"]

enum ApiInit: String {
    case Inventory = "inventory/"
    case Account = "account/"
}

enum SyncTable: String {
    case Inventory = "INV"
    case Account = "ACCOUNT"
    
    var tables : [String : String] {
        get {
            switch self {
            case Inventory:
                return inventoryTables
            case Account:
                return accountTables
            }
        }
    }
}

protocol SyncServiceBaseType {
    var apiInit: ApiInit? { get }
    var tableNames: [String : String] { get }
    var syncTable: SyncTable? { get }
    var apiCredentials: [String : String] { get }
    var date: String { get }
}

protocol SyncServiceType {
    var queryDb: NSMutableArray? { get }
}

protocol SyncRows {
    init(dict: [String: AnyObject]?)
    
    var getDbDelete: String? { get }
    var getDbInsert: String? { get }
}

struct Sync<T: SyncRows> {
    let syncTime: String?
    let operation: ApiOperationEnum
    var addedRows: [T]?
    var deletedRows: [T]?
    
    init(dict: [String: AnyObject]?) {
        syncTime = dict?["Time"] as? String
        let dictOperation = dict?["Op"] as? String
        operation = ApiOperationEnum(rawValue: dictOperation ?? "Error") ?? .Error
        if let addedRowsDictArray = dict?["A"] as? [[String: AnyObject]] {
            addedRows = self.structArrayFromDictionaryArray(addedRowsDictArray)
        } else {
            addedRows = nil
        }
        if let deletedRowsDictArray = dict?["D"] as? [[String: AnyObject]] {
            deletedRows = self.structArrayFromDictionaryArray(deletedRowsDictArray)
        } else {
            deletedRows = nil
        }
    }
    
    private func structArrayFromDictionaryArray<T: SyncRows>(rowList: [[String: AnyObject]]) -> [T]? {
        var structArray : [T] = []
        for row in rowList {
            structArray.append(T(dict: row))
        }
        if !structArray.isEmpty {
            return structArray
        } else {
            return nil
        }
    }
}


class SyncService : SyncServiceBaseType {
    
    let apiInit: ApiInit?
    let syncTable: SyncTable?
    let tableNames: [String : String]
    let apiCredentials: [String : String]
    let date: String
    
    init(apiInit: ApiInit, syncTable: SyncTable, tableNames: [String : String], apiCredentials: [String : String], date: String) {
        self.apiInit = apiInit
        self.syncTable = syncTable
        self.tableNames = tableNames
        self.apiCredentials = apiCredentials
        self.date = date
    }
    
    func updateLastSync() {
        let dB = FMDatabase(path: Constants.databasePath)
        if dB.open() {
            let sqlInsert = "UPDATE LAST_SYNC SET last_sync='\(NSDate().getDateTimeString())' WHERE table_name='\(syncTable!.rawValue)'"
            dB.executeUpdate(sqlInsert, withArgumentsInArray: nil)
            dB.close()
        }
    }
    
    lazy var queryLastSync : String? = {
        let dB = FMDatabase(path: Constants.databasePath)
        var lastSyncResult: String?
        if dB.open() {
            let sqlQuery = "SELECT LAST_SYNC FROM LAST_SYNC WHERE table_name='\(self.syncTable!.rawValue)'"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsInArray: nil)
            if results?.next() == true {
                lastSyncResult = results?.stringForColumn("last_sync")
            } else {
                lastSyncResult = nil
            }
            dB.close()
        }
        return lastSyncResult
    }()

    func queryAllLastSync() throws -> [String : String]  {
        let dB = FMDatabase(path: Constants.databasePath)
        var lastSyncs: [String : String] = [:]
        if dB.open() {
            for (name, table) in tableNames {
                let qryLastSync = "SELECT last_sync FROM LAST_SYNC WHERE table_name = '\(table)'"
                let results:FMResultSet? = dB.executeQuery(qryLastSync, withArgumentsInArray: nil)
                if results?.next() == true {
                    if let lastSync = results?.stringForColumn("last_sync") {
                        lastSyncs[name] = lastSync
                    } else {
                        lastSyncs[name] = Constants.timeSyncDefault
                    }
                } else {
                    lastSyncs[name] = Constants.timeSyncDefault
                }
            }
            dB.close()
        }
        guard !lastSyncs.isEmpty else {
            throw ErrorCode.DbError
        }
        return lastSyncs
    }

}