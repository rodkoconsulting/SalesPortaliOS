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
    case OrderListHeader = "ORDER_LIST_HEADER"
    case OrderListDetail = "ORDER_LIST_DETAIL"
    case SampleListHeader = "SAMPLE_LIST_HEADER"
    case SampleListDetail = "SAMPLE_LIST_DETAIL"
    case SampleAddress = "SAMPLE_ADDRESSES"
    case SampleItemsInactive = "SAMPLE_ITEMS_INACTIVE"
}


protocol DatabaseServiceType {
    var tableName: DatabaseTable { get }
    
    func updateDb<T>(_ syncObject: Sync<T>) throws
    
    init(tableName: DatabaseTable)
    
}

struct DatabaseService: DatabaseServiceType {
    let tableName: DatabaseTable
    
    init(tableName: DatabaseTable) {
        self.tableName = tableName
    }
    
    func syncReset(_ dB: FMDatabase) {
        dB.executeUpdate("UPDATE LAST_SYNC SET last_sync=NULL WHERE table_name='" + tableName.rawValue + "'", withArgumentsIn: nil)
        dB.close()
    }
    
    func updateDb<T>(_ syncObject: Sync<T>) throws {
        let operation = syncObject.operation
        
        guard operation != ApiOperationEnum.Error else {
            throw ErrorCode.serverError
        }
        guard operation != ApiOperationEnum.Empty else {
            return
        }
        if operation == ApiOperationEnum.Clear {
            do {
                try DbOperation.databaseClear(tableName.rawValue)
            } catch {
                throw ErrorCode.dbError
            }
        }
        guard let syncTime = syncObject.syncTime else {
            throw ErrorCode.dbError
        }
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return
        }
        guard dB.open() else {
            throw ErrorCode.dbError
        }
        var isSyncUpdated: Bool = false
        
        if let deletedRows =  syncObject.deletedRows {
            for row in deletedRows {
                guard let dbDelete = row.getDbDelete else {
                    syncReset(dB)
                    throw ErrorCode.dbError
                }
                let sqlDelete = "DELETE FROM " + tableName.rawValue + " WHERE " + dbDelete
                let isDeleted = dB.executeUpdate(sqlDelete, withArgumentsIn: nil)
                guard isDeleted else {
                    syncReset(dB)
                    throw ErrorCode.dbError
                }
            }
        }
        
        if let addedRows = syncObject.addedRows {
            var sqlInsert = "INSERT INTO " + tableName.rawValue + " VALUES"
            for row in addedRows {
                guard let dbInsert = row.getDbInsert else {
                    syncReset(dB)
                    throw ErrorCode.dbError
                }
                sqlInsert = sqlInsert + dbInsert + ","
            }
            sqlInsert = sqlInsert[sqlInsert.startIndex..<sqlInsert.characters.index(sqlInsert.startIndex, offsetBy: sqlInsert.characters.count - 1)]
            let isInserted = dB.executeUpdate(sqlInsert, withArgumentsIn: nil)
            guard isInserted else {
                syncReset(dB)
                throw ErrorCode.dbError
            }
        }
        let sqlUpdateSync = "UPDATE LAST_SYNC SET last_sync='" + syncTime + "' WHERE table_name='" + tableName.rawValue + "'"
        isSyncUpdated = dB.executeUpdate(sqlUpdateSync, withArgumentsIn: nil)
        if !isSyncUpdated {
            syncReset(dB)
            throw ErrorCode.dbError
        }
        dB.close()
    }
}
