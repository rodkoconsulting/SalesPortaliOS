//
//  DatabaseService.swift
//  InventoryPortal
//
//  Created by administrator on 4/18/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation


enum DatabaseTable: String {
    case InventoryQuantity = "INV_QTY"
    case InventoryPo = "INV_PO"
    case InventoryDesc = "INV_DESC"
    case InventoryPrice = "INV_PRICE"
    case AccountList = "ACCOUNTS_LIST"
    case AccountInvoiceHeader = "ACCOUNTS_INV_HEAD"
    case AccountInvoiceDetail = "ACCOUNTS_INV_DET"
    case AccountItemsInactive = "ACCOUNTS_ITEMS_INACTIVE"
}


protocol DatabaseServiceType {
    var tableName: DatabaseTable { get }
    
    func updateDb<T>(syncObject: Sync<T>) throws
    
    init(tableName: DatabaseTable)
    
}

struct DatabaseService: DatabaseServiceType {
    let tableName: DatabaseTable
    
    init(tableName: DatabaseTable) {
        self.tableName = tableName
    }
    
    func updateDb<T>(syncObject: Sync<T>) throws {
        var isSyncUpdated: Bool = false
        let dB = FMDatabase(path: Constants.databasePath)
        guard dB.open() else {
            throw ErrorCode.DbError
        }
        defer {
            if !isSyncUpdated {
                let sqlReset = "UPDATE LAST_SYNC SET last_sync=NULL WHERE table_name='\(tableName.rawValue)'"
                dB.executeUpdate(sqlReset, withArgumentsInArray: nil)
            }
            dB.close()
        }
        let operation = syncObject.operation
        guard operation != ApiOperationEnum.Error else {
            throw ErrorCode.ServerError
        }
        guard operation != ApiOperationEnum.Empty else {
            isSyncUpdated = true
            return
        }
        if operation == ApiOperationEnum.Clear {
            do {
                try DbOperation.databaseClear(tableName.rawValue, databasePath: Constants.databasePath)
            } catch {
                throw ErrorCode.DbError
            }
        }
        if let deletedRows =  syncObject.deletedRows {
            var sqlDelete = "DELETE FROM \(tableName.rawValue) WHERE "
            for row in deletedRows {
                guard let dbDelete = row.getDbDelete else {
                    throw ErrorCode.DbError
                }
                sqlDelete += "\(dbDelete) OR "
            }
            sqlDelete = sqlDelete[sqlDelete .startIndex..<sqlDelete.startIndex.advancedBy(sqlDelete.characters.count - 4)]
            let isDeleted = dB.executeUpdate(sqlDelete, withArgumentsInArray: nil)
            guard isDeleted else {
                throw ErrorCode.DbError
            }

        }
        if let addedRows = syncObject.addedRows {
            var sqlInsert = "INSERT INTO \(tableName.rawValue) VALUES"
            for row in addedRows {
                guard let dbInsert = row.getDbInsert else {
                    throw ErrorCode.DbError
                }
                sqlInsert += "\(dbInsert),"
            }
            sqlInsert = sqlInsert[sqlInsert.startIndex..<sqlInsert.startIndex.advancedBy(sqlInsert.characters.count - 1)]
            let isInserted = dB.executeUpdate(sqlInsert, withArgumentsInArray: nil)
            guard isInserted else {
                throw ErrorCode.DbError
            }
        }
        guard let syncTime = syncObject.syncTime else {
            throw ErrorCode.DbError
        }
        let sqlUpdateSync = "UPDATE LAST_SYNC SET last_sync='\(syncTime)' WHERE table_name='\(tableName.rawValue)'"
        isSyncUpdated = dB.executeUpdate(sqlUpdateSync, withArgumentsInArray: nil)
        if !isSyncUpdated {
            throw ErrorCode.DbError
        }

        
    }
}