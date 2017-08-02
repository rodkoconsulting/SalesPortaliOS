//
//  DatabaseOperation.swift
//  StormyNew
//
//  Created by administrator on 7/9/15.
//  Copyright (c) 2015 Polaner Selections. All rights reserved.
//

import Foundation

struct DbOperation {
    
        
    static func databaseClear(_ tableName: String) throws {
        let dB = FMDatabase(path: Constants.databasePath as String)
        guard dB.open() else {
            throw ErrorCode.dbError
        }
        let sqlDelete = "DELETE FROM " + tableName
        let isDeleted = dB.executeUpdate(sqlDelete, withArgumentsIn: nil)
        guard isDeleted else {
            throw ErrorCode.dbError
        }
        dB.close()
    }
    
    static func databaseDelete() -> Void {
      let fileMgr = FileManager.default
      do {
          try fileMgr.removeItem(atPath: Constants.filePath as String)
      } catch _ {
        
      }
    }
    
    static func databaseInit() throws -> String? {
        guard !FileManager.default.fileExists(atPath: Constants.filePath) else {
            return nil
        }
        let dB = FMDatabase(path: Constants.databasePath as String)
        guard dB.open() else {
            throw ErrorCode.dbError
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
        let sqlAccountList = "CREATE TABLE IF NOT EXISTS ACCOUNTS_LIST(DIVISION_NO CHARACTER(2), CUSTOMER_NO STRING, CUSTOMER_NAME STRING, SHIP_DAYS STRING, PRICE_LEVEL STRING, COOP_LIST STRING, STATUS STRING, BUYER1 STRING, BUYER2 STRING, BUYER3 STRING, BUYER1EMAIL STRING, BUYER2EMAIL STRING, BUYER3EMAIL STRING, BUYER1PHONE STRING, BUYER2PHONE STRING, BUYER3PHONE STRING, AFFIL STRING, ADDR1 STRING, ADDR2 STRING, CITY STRING, STATE STRING, ZIP STRING, REP STRING, REGION STRING, PRIMARY KEY(DIVISION_NO, CUSTOMER_NO))"
        let sqlAccountInvHeader = "CREATE TABLE IF NOT EXISTS ACCOUNTS_INV_HEAD(INVOICE_NO STRING, HEADER_SEQ_NO STRING, DIVISION_NO CHARACTER(2), CUSTOMER_NO STRING, INVOICE_TYPE STRING, INVOICE_DATE STRING, COMMENT STRING, PRIMARY KEY(INVOICE_NO, HEADER_SEQ_NO))"
        let sqlAccountInvDetail = "CREATE TABLE IF NOT EXISTS ACCOUNTS_INV_DET(INVOICE_NO STRING, HEADER_SEQ_NO STRING, DETAIL_SEQ_NO STRING, ITEM_CODE STRING, QUANTITY REAL, PRICE REAL, TOTAL REAL, PRIMARY KEY(INVOICE_NO, HEADER_SEQ_NO, DETAIL_SEQ_NO))"
        let sqlOrderListHeader = "CREATE TABLE IF NOT EXISTS ORDER_LIST_HEADER(ORDER_NO STRING, ORDER_DATE STRING, SHIP_DATE STRING, DIVISION_NO CHARACTER(2), CUSTOMER_NO STRING, STATUS STRING, HOLD STRING, COOP STRING, COMMENT STRING, PRIMARY KEY(ORDER_NO))"
        let sqlOrderListDetail = "CREATE TABLE IF NOT EXISTS ORDER_LIST_DETAIL(ORDER_NO STRING, LINE_NO STRING, ITEM_CODE STRING, QTY REAL, PRICE REAL, TOTAL REAL, COMMENT STRING, PRIMARY KEY(ORDER_NO, LINE_NO))"
        let sqlSampleListHeader = "CREATE TABLE IF NOT EXISTS SAMPLE_LIST_HEADER(ORDER_NO STRING, SHIP_DATE STRING, REP STRING, SHIP_TO STRING, PRIMARY KEY(ORDER_NO))"
        let sqlSampleListDetail = "CREATE TABLE IF NOT EXISTS SAMPLE_LIST_DETAIL(ORDER_NO STRING, LINE_NO STRING, ITEM_CODE STRING, QTY REAL, COMMENT STRING, PRIMARY KEY(ORDER_NO, LINE_NO))"
        let sqlOrderHeader = "CREATE TABLE IF NOT EXISTS ORDER_HEADER(ORDER_NO INTEGER PRIMARY KEY AUTOINCREMENT, TYPE STRING, DIVISION_NO CHARACTER(2), CUSTOMER_NO STRING, SAVE_TIME STRING, SHIP_DATE CHARACTER(6), NOTES STRING, COOP_QTY INT, COOP_NO STRING, TOTAL_QTY REAL, TOTAL_PRICE REAL, PO_NO STRING)"
        let sqlSampleAddresses = "CREATE TABLE IF NOT EXISTS SAMPLE_ADDRESSES(CODE STRING, REP STRING, NAME STRING, ADDRESS STRING, REGION STRING, IS_REP INT, IS_ACTIVE INT, PRIMARY KEY(CODE))"
        let sqlSampleItemsInactive = "CREATE TABLE IF NOT EXISTS SAMPLE_ITEMS_INACTIVE(ITEM_CODE STRING PRIMARY KEY, DESC STRING, BRAND STRING, MASTER_VENDOR STRING, VINTAGE STRING, UOM STRING, SIZE STRING, DAMAGED_NOTES STRING, FOCUS STRING, COUNTRY STRING, REGION STRING, APPELLATION STRING)"
        let sqlOrderDetail = "CREATE TABLE IF NOT EXISTS ORDER_DETAIL(ORDER_NO INT, ITEM_CODE STRING, BOTTLES INT, PRICE REAL, MOBO CHARACTER, MOBO_BOTTLES INT, OVERRIDE INT, COMMENT STRING)"
        let sqlAccountItemsInactive = "CREATE TABLE IF NOT EXISTS ACCOUNTS_ITEMS_INACTIVE (ITEM_CODE STRING PRIMARY KEY, DESC STRING, BRAND STRING, MASTER_VENDOR STRING, VINTAGE STRING, UOM STRING, SIZE STRING, DAMAGED_NOTES STRING, CLOSURE STRING, TYPE STRING, VARIETAL STRING, ORGANIC STRING, BIODYNAMIC STRING, FOCUS STRING, COUNTRY STRING, REGION STRING, APPELLATION STRING, RESTRICT_OFFSALE STRING, RESTRICT_OFFSALE_NOTES STRING, RESTRICT_PREMISE STRING, RESTRICT_ALLOCATED STRING, RESTRICT_APPROVAL STRING, RESTRICT_MAX STRING, RESTRICT_STATE STRING, RESTRICT_SAMPLE STRING, RESTRICT_BO STRING, RESTRICT_MO STRING, UPC STRING, SCORE_WA STRING, SCORE_WS STRING, SCORE_IWC STRING, SCORE_BH STRING, SCORE_VM STRING, SCORE_OTHER STRING)"
        let insLastSyncAccountList = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_LIST' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_LIST')"
        let insLastSyncAccountInvHeader = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_INV_HEAD' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_INV_HEAD')"
        let insLastSyncAccountInvDetail = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_INV_DET' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_INV_DET')"
        let insLastSyncAccountItemsInactive = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS_ITEMS_INACTIVE' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS_ITEMS_INACTIVE')"
        let insLastSyncAccount = "INSERT INTO LAST_SYNC (table_name) SELECT 'ACCOUNTS' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ACCOUNTS')"
        let insLastSyncOrderListHeader = "INSERT INTO LAST_SYNC (table_name) SELECT 'ORDER_LIST_HEADER' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ORDER_LIST_HEADER')"
        let insLastSyncOrderListDetail = "INSERT INTO LAST_SYNC (table_name) SELECT 'ORDER_LIST_DETAIL' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ORDER_LIST_DETAIL')"
        let insLastSyncSampleListHeader = "INSERT INTO LAST_SYNC (table_name) SELECT 'SAMPLE_LIST_HEADER' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='SAMPLE_LIST_HEADER')"
        let insLastSyncSampleListDetail = "INSERT INTO LAST_SYNC (table_name) SELECT 'SAMPLE_LIST_DETAIL' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='SAMPLE_LIST_DETAIL')"
        let insLastSyncSampleAddresses = "INSERT INTO LAST_SYNC (table_name) SELECT 'SAMPLE_ADDRESSES' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='SAMPLE_ADDRESSES')"
        let insLastSyncSampleItemsInactive = "INSERT INTO LAST_SYNC (table_name) SELECT 'SAMPLE_ITEMS_INACTIVE' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='SAMPLE_ITEMS_INACTIVE')"
        let insLastSyncOrders = "INSERT INTO LAST_SYNC (table_name) SELECT 'ORDERS' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='ORDERS')"
        let insLastSyncSamples = "INSERT INTO LAST_SYNC (table_name) SELECT 'SAMPLES' WHERE NOT EXISTS(SELECT 1 FROM LAST_SYNC WHERE table_name='SAMPLES')"
        
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
            dB.executeStatements(insLastSyncAccount) &&
            dB.executeStatements(sqlOrderListHeader) &&
            dB.executeStatements(sqlOrderListDetail) &&
            dB.executeStatements(sqlOrderHeader) &&
            dB.executeStatements(sqlOrderDetail) &&
            dB.executeStatements(insLastSyncOrderListHeader) &&
            dB.executeStatements(insLastSyncOrderListDetail) &&
            dB.executeStatements(sqlSampleListHeader) &&
            dB.executeStatements(sqlSampleListDetail) &&
            dB.executeStatements(insLastSyncSampleListHeader) &&
            dB.executeStatements(insLastSyncSampleListDetail) &&
            dB.executeStatements(sqlSampleAddresses) &&
            dB.executeStatements(sqlSampleItemsInactive) &&
            dB.executeStatements(insLastSyncSampleAddresses) &&
            dB.executeStatements(insLastSyncSampleItemsInactive) &&
            dB.executeStatements(insLastSyncOrders) &&
            dB.executeStatements(insLastSyncSamples) else {
                dB.close()
                throw ErrorCode.dbError
        }
        let attachPreviousDb = "ATTACH DATABASE '\(Constants.previousFilePath as String)' AS OriginalDatabase"
        let copyPreviousSavedOrderHeaders = "INSERT INTO Main.ORDER_HEADER SELECT * FROM OriginalDatabase.ORDER_HEADER"
        let copyPreviousSavedOrderDetails = "INSERT INTO Main.ORDER_DETAIL SELECT * FROM OriginalDatabase.ORDER_DETAIL"
        let detachPreviousDb = "DETACH DATABASE OriginalDatabase"
        do {
            try dB.executeUpdate(attachPreviousDb, values: nil)
            try dB.executeUpdate(copyPreviousSavedOrderHeaders, values: nil)
            try dB.executeUpdate(copyPreviousSavedOrderDetails, values: nil)
            try dB.executeUpdate(detachPreviousDb, values: nil)
        }
        catch {
            dB.close()
            return nil
        }
        dB.close()
        return nil
    }
    
}
