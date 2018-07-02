//
//  AccountService.swift
//  SalesPortal
//
//  Created by administrator on 5/23/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

class AccountService: SyncService, SyncServiceType {
    
    override init(module: Module, apiCredentials: [String : String]) {
        super.init(module: module, apiCredentials: apiCredentials)
    }
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let accountList = NSMutableArray()
        var accountSearch = [[String : String]]()
        if dB.open() {
            let sqlQuery = "SELECT DIVISION_NO, CUSTOMER_NO, CUSTOMER_NAME, SHIP_DAYS, PRICE_LEVEL, COOP_LIST, STATUS, BUYER1, BUYER2, BUYER3, BUYER1EMAIL, BUYER2EMAIL, BUYER3EMAIL, BUYER1PHONE, BUYER2PHONE, BUYER3PHONE, AFFIL, ADDR1, ADDR2, CITY, STATE, ZIP, REP, REGION, SHIP_TO FROM ACCOUNTS_LIST ORDER BY CUSTOMER_NAME"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let account = Account(queryResult: results)
                let accountDict = ["DisplayText":account.customerName, "DisplaySubText": account.customerNo]
                accountList.add(account)
                accountSearch.append(accountDict)
            }
            dB.close()
        }
        return accountList.count > 0 ? (accountList, accountSearch, false) : (nil, nil, false)
    }
    
    func getApi(_ timeSyncDict: [String : String], completion: @escaping (_ data: AccountSync?, _ error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiAccount(timeSyncDict, credentialDict: self.apiCredentials){
            (apiDict, errorCode) in
            guard let accountDict = apiDict,
                let listDict = accountDict["List"] as? [String : AnyObject],
                let invoiceHeaderDict = accountDict["HistH"] as? [String : AnyObject],
                let invoiceDetailDict = accountDict["HistD"] as? [String : AnyObject],
                let itemsInactiveDict = accountDict["Inact"] as? [String : AnyObject],
                let addressDict = accountDict["A"] as? [String : AnyObject]
                else {
                    completion(nil, errorCode)
                    return
            }
            completion(AccountSync(listDict: listDict, invoiceHeaderDict: invoiceHeaderDict, invoiceDetailDict: invoiceDetailDict, itemsInactiveDict: itemsInactiveDict, addressDict: addressDict), nil)
        }
    }
    
    func updateDb(_ accountSync: AccountSync) throws {
        let accountListService = DatabaseService(tableName: DatabaseTable.AccountList)
        let accountInvoiceHeaderService = DatabaseService(tableName: DatabaseTable.AccountInvoiceHeader)
        let accountInvoiceDetailService = DatabaseService(tableName: DatabaseTable.AccountInvoiceDetail)
        let accountItemsInactiveService = DatabaseService(tableName: DatabaseTable.AccountItemsInactive)
        let accountAddressService = DatabaseService(tableName: DatabaseTable.AccountAddress)
        do {
            try accountListService.updateDb(accountSync.listSync)
            try accountInvoiceHeaderService.updateDb(accountSync.invoiceHeaderSync)
            try accountInvoiceDetailService.updateDb(accountSync.invoiceDetailSync)
            try accountItemsInactiveService.updateDb(accountSync.itemsInactiveSync)
            try accountAddressService.updateDb(accountSync.addressSync)
        } catch ErrorCode.serverError {
            throw ErrorCode.serverError
        } catch {
            throw ErrorCode.dbError
        }
    }
    
}


