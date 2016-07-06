//
//  DatabaseOperation.swift
//  StormyNew
//
//  Created by administrator on 7/9/15.
//  Copyright (c) 2015 Polaner Selections. All rights reserved.
//

import Foundation

struct DbOperation {
    
        
    static func databaseClear(tableName: String, databasePath: String) throws {
        let dB = FMDatabase(path: databasePath)
        guard dB.open() else {
            throw ErrorCode.DbError
        }
        let sqlDelete = "DELETE FROM \(tableName)"
        let isDeleted = dB.executeUpdate(sqlDelete, withArgumentsInArray: nil)
        guard isDeleted else {
            throw ErrorCode.DbError
        }
        dB.close()
    }
    
    static func databaseDelete() -> Void {
      let fileMgr = NSFileManager.defaultManager()
      do {
          try fileMgr.removeItemAtPath(Constants.databasePath as String)
      } catch _ {
        
      }
    }
    
    static func databaseInit() throws -> String? {
        let dB = FMDatabase(path: Constants.databasePath as String)
        guard dB.open() else {
            throw ErrorCode.DbError
        }
        
        let sqlLastSync = "CREATE TABLE IF NOT EXISTS LAST_SYNC (TABLE_NAME STRING PRIMARY KEY, LAST_SYNC TEXT)"
        let sqlInvQty = "CREATE TABLE IF NOT EXISTS INV_QTY (ITEM_CODE STRING PRIMARY KEY, QTY_AVAIL REAL, QTY_OH REAL, ON_SO REAL, ON_MO REAL, ON_BO REAL)"
        let insLastSyncInvQty = "INSERT INTO LAST_SYNC (table_name) SELECT 'INV_QTY' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='INV_QTY')"
        let sqlInvDesc = "CREATE TABLE IF NOT EXISTS INV_DESC (ITEM_CODE STRING PRIMARY KEY, DESC STRING, BRAND STRING, MASTER_VENDOR STRING, VINTAGE STRING, UOM STRING, SIZE STRING, DAMAGED_NOTES STRING, CLOSURE STRING, TYPE STRING, VARIETAL STRING, ORGANIC STRING, BIODYNAMIC STRING, FOCUS STRING, COUNTRY STRING, REGION STRING, APPELLATION STRING, RESTRICT_OFFSALE STRING, RESTRICT_OFFSALE_NOTES STRING, RESTRICT_PREMISE STRING, RESTRICT_ALLOCATED STRING, RESTRICT_APPROVAL STRING, RESTRICT_MAX STRING, RESTRICT_STATE STRING, RESTRICT_SAMPLE STRING, RESTRICT_BO STRING, RESTRICT_MO STRING, UPC STRING, SCORE_WA STRING, SCORE_WS STRING, SCORE_IWC STRING, SCORE_BH STRING, SCORE_VM STRING, SCORE_OTHER STRING)"
        let insLastSyncInvDesc = "INSERT INTO LAST_SYNC (table_name) SELECT 'INV_DESC' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='INV_DESC')"
        let sqlInvPrice = "CREATE TABLE IF NOT EXISTS INV_PRICE (ITEM_CODE STRING, PRICE_LEVEL STRING, DATE STRING, PRICE_DESC STRING, PRIMARY KEY (ITEM_CODE, PRICE_LEVEL, DATE))"
        let insLastSyncInvPrice = "INSERT INTO LAST_SYNC (table_name) SELECT 'INV_PRICE' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='INV_PRICE')"
        let insLastSyncInv = "INSERT INTO LAST_SYNC (table_name) SELECT 'INV' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='INV')"
        let sqlInvPo = "CREATE TABLE IF NOT EXISTS INV_PO (ITEM_CODE STRING, PO_NO STRING, ON_PO REAL, PO_ETA STRING, PO_DATE STRING, PRIMARY KEY (ITEM_CODE, PO_NO))"
        let insLastSyncInvPo = "INSERT INTO LAST_SYNC (table_name) SELECT 'INV_PO' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='INV_PO')"
        let sqlAccountList = "CREATE TABLE IF NOT EXISTS ACCOUNTS_LIST(DIVISION_NO CHARACTER(2), CUSTOMER_NO STRING, CUSTOMER_NAME STRING, SHIP_DAYS STRING, PRICE_LEVEL STRING, COOP_LIST STRING, PRIMARY KEY(DIVISION_NO, CUSTOMER_NO))"
        let sqlAccountInvHeader = "CREATE TABLE IF NOT EXISTS ACCOUNTS_INV_HEAD(INVOICE_NO STRING, HEADER_SEQ_NO STRING, DIVISION_NO CHARACTER(2), CUSTOMER_NO STRING, INVOICE_TYPE STRING, INVOICE_DATE STRING, PRIMARY KEY(INVOICE_NO, HEADER_SEQ_NO))"
        let sqlAccountInvDetail = "CREATE TABLE IF NOT EXISTS ACCOUNTS_INV_DET(INVOICE_NO STRING, HEADER_SEQ_NO STRING, DETAIL_SEQ_NO STRING, ITEM_CODE STRING, QUANTITY REAL, PRICE REAL, PRIMARY KEY(INVOICE_NO, HEADER_SEQ_NO, DETAIL_SEQ_NO))"
        let sqlAccountItemsInactive = "CREATE TABLE IF NOT EXISTS ACCOUNTS_ITEMS_INACTIVE (ITEM_CODE STRING PRIMARY KEY, DESC STRING, BRAND STRING, MASTER_VENDOR STRING, VINTAGE STRING, UOM STRING, SIZE STRING, DAMAGED_NOTES STRING, CLOSURE STRING, TYPE STRING, VARIETAL STRING, ORGANIC STRING, BIODYNAMIC STRING, FOCUS STRING, COUNTRY STRING, REGION STRING, APPELLATION STRING, RESTRICT_OFFSALE STRING, RESTRICT_OFFSALE_NOTES STRING, RESTRICT_PREMISE STRING, RESTRICT_ALLOCATED STRING, RESTRICT_APPROVAL STRING, RESTRICT_MAX STRING, RESTRICT_STATE STRING, RESTRICT_SAMPLE STRING, RESTRICT_BO STRING, RESTRICT_MO STRING, UPC STRING, SCORE_WA STRING, SCORE_WS STRING, SCORE_IWC STRING, SCORE_BH STRING, SCORE_VM STRING, SCORE_OTHER STRING)"
        let insLastSyncAccountList = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_LIST' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_LIST')"
        let insLastSyncAccountInvHeader = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_INV_HEAD' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_INV_HEAD')"
        let insLastSyncAccountInvDetail = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_INV_DET' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_INV_DET')"
        let insLastSyncAccountItemsInactive = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_ITEMS_INACTIVE' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_ITEMS_INACTIVE')"
        let insLastSyncAccount = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS')"
        guard dB.executeStatements(sqlLastSync) &&
            dB.executeStatements(sqlInvQty) &&
            dB.executeStatements(insLastSyncInvQty) &&
            dB.executeStatements(sqlInvDesc) &&
            dB.executeStatements(insLastSyncInvDesc) &&
            dB.executeStatements(sqlInvPrice)  &&
            dB.executeStatements(insLastSyncInvPrice) &&
            dB.executeStatements(sqlInvPo) &&
            dB.executeStatements(insLastSyncInvPo) &&
            dB.executeStatements(insLastSyncInv) &&
            dB.executeStatements(sqlAccountList) &&
            dB.executeStatements(sqlAccountInvHeader) &&
            dB.executeStatements(sqlAccountInvDetail) &&
            dB.executeStatements(sqlAccountItemsInactive) &&
            dB.executeStatements(insLastSyncAccountList) &&
            dB.executeStatements(insLastSyncAccountInvHeader) &&
            dB.executeStatements(insLastSyncAccountInvDetail) &&
            dB.executeStatements(insLastSyncAccountItemsInactive) &&
            dB.executeStatements(insLastSyncAccount) else {
                dB.close()
                throw ErrorCode.DbError
        }
        return nil
    }
    
}