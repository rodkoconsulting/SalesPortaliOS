//
//  AccountService.swift
//  SalesPortal
//
//  Created by administrator on 5/23/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

class AccountService: SyncService, SyncServiceType {
    lazy var queryDb: NSMutableArray? = {
        [unowned self] in
        let dB = FMDatabase(path: Constants.databasePath)
        let accountList = NSMutableArray()
        if dB.open() {
            let sqlQuery = "SELECT DIVISION_NO, CUSTOMER_NO, CUSTOMER_NAME, SHIP_DAYS, PRICE_LEVEL FROM ACCOUNT_LIST ORDER BY CUSTOMER_NAME"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsInArray: nil)
            while results?.next() == true {
                let account = Account(queryResult: results!)
                accountList.addObject(account)
            }
            dB.close()
        }
        return accountList.count > 0 ? accountList : nil
    }()
    
    func getApi(timeSyncDict: [String : String], completion: (data: AccountSync?, error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: apiInit!.rawValue)
        apiService.getApiAccount(timeSyncDict, credentialDict: self.apiCredentials){
            (let apiDict, errorCode) in
            guard let accountDict = apiDict,
                let listDict = accountDict["List"] as? [String : AnyObject]
                else {
                    completion(data: nil, error: errorCode)
                    return
            }
            completion(data: AccountSync(listDict: listDict), error: nil)
        }
    }
    
    func updateDb(accountSync: AccountSync) throws {
        let accountListService = DatabaseService(tableName: DatabaseTable.AccountList)
        do {
            try accountListService.updateDb(accountSync.listSync)
        } catch ErrorCode.ServerError {
            throw ErrorCode.ServerError
        } catch {
            throw ErrorCode.DbError
        }
    }
}


