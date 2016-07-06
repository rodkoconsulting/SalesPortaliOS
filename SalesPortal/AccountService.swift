//
//  AccountService.swift
//  SalesPortal
//
//  Created by administrator on 5/23/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

class AccountService: SyncService, SyncServiceType {
    lazy var queryDb: (gridData:NSMutableArray?, searchData: [[String : AnyObject]]?)  = {
        [unowned self] in
        let dB = FMDatabase(path: Constants.databasePath)
        let accountList = NSMutableArray()
        var accountSearch = [[String : AnyObject]]()
        if dB.open() {
            let sqlQuery = "SELECT DIVISION_NO, CUSTOMER_NO, CUSTOMER_NAME, SHIP_DAYS, PRICE_LEVEL, COOP_LIST FROM ACCOUNTS_LIST ORDER BY CUSTOMER_NAME"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsInArray: nil)
            while results?.next() == true {
                let account = Account(queryResult: results!)
                let accountDict = ["DisplayText":account.customerName, "DisplaySubText": account.customerNo]
                accountList.addObject(account)
                accountSearch.append(accountDict)
            }
            dB.close()
        }
        return accountList.count > 0 ? (accountList, accountSearch) : (nil, nil)
    }()
    
    func getApi(timeSyncDict: [String : String], completion: (data: AccountSync?, error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiAccount(timeSyncDict, credentialDict: self.apiCredentials){
            (let apiDict, errorCode) in
            guard let accountDict = apiDict,
                let listDict = accountDict["List"] as? [String : AnyObject],
                let invoiceHeaderDict = accountDict["HistH"] as? [String : AnyObject],
                let invoiceDetailDict = accountDict["HistD"] as? [String : AnyObject],
                let itemsInactiveDict = accountDict["Inact"] as? [String : AnyObject]
                else {
                    completion(data: nil, error: errorCode)
                    return
            }
            completion(data: AccountSync(listDict: listDict, invoiceHeaderDict: invoiceHeaderDict, invoiceDetailDict: invoiceDetailDict, itemsInactiveDict: itemsInactiveDict), error: nil)
        }
    }
    
    func updateDb(accountSync: AccountSync) throws {
        let accountListService = DatabaseService(tableName: DatabaseTable.AccountList)
        let accountInvoiceHeaderService = DatabaseService(tableName: DatabaseTable.AccountInvoiceHeader)
        let accountInvoiceDetailService = DatabaseService(tableName: DatabaseTable.AccountInvoiceDetail)
        let accountItemsInactiveService = DatabaseService(tableName: DatabaseTable.AccountItemsInactive)
        do {
            try accountListService.updateDb(accountSync.listSync)
            try accountInvoiceHeaderService.updateDb(accountSync.invoiceHeaderSync)
            try accountInvoiceDetailService.updateDb(accountSync.invoiceDetailSync)
            try accountItemsInactiveService.updateDb(accountSync.itemsInactiveSync)
        } catch ErrorCode.ServerError {
            throw ErrorCode.ServerError
        } catch {
            throw ErrorCode.DbError
        }
    }
}


