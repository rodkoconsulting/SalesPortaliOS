//
//  MoboListService.swift
//  SalesPortal
//
//  Created by administrator on 7/11/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation
class OrderMoboService: SyncService, SyncServiceType {
    
    let account : Account
    
    init(module: Module, apiCredentials: [String : String], account: Account) {
        self.account = account
        super.init(module: module, apiCredentials: apiCredentials)
    }
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let moboListArray = NSMutableArray()
        var moboListSearch = [[String : String]]()
        if dB.open() {
            let sqlQuery =
                "SELECT h.ORDER_NO, h.ORDER_DATE, h.SHIP_DATE, h.STATUS, h.HOLD, h.COOP, h.COMMENT, " +
                    "d.ITEM_CODE, d.QTY, d.PRICE, d.TOTAL, " +
                    "i.DESC, i.BRAND, i.VINTAGE, i.UOM, i.SIZE, i.DAMAGED_NOTES, " +
                    "a.CUSTOMER_NAME, a.CUSTOMER_NO " +
                    "FROM ACCOUNTS_LIST a INNER JOIN ORDER_LIST_HEADER h ON a.DIVISION_NO = h.DIVISION_NO and a.CUSTOMER_NO = h.CUSTOMER_NO " +
                    "INNER JOIN ORDER_LIST_DETAIL d ON h.ORDER_NO = d.ORDER_NO " +
            "LEFT OUTER JOIN INV_DESC i ON d.ITEM_CODE = i.ITEM_CODE " +
            "WHERE ((a.DIVISION_NO = '" + self.account.divisionNo + "' and a.CUSTOMER_NO = '" + self.account.customerNoRaw + "') OR SUBSTR(h.CUSTOMER_NO,1,2)='ZZ') and (h.HOLD = 'MO' OR h.HOLD = 'IN' OR h.HOLD = 'BO' OR h.HOLD = 'BH') " +
            "ORDER BY a.CUSTOMER_NAME, h.ORDER_NO desc, i.DESC"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let  moboList = MoboList(queryResult: results!)
                let itemDescription = moboList.itemDescription ?? ""
                let moboListDict = ["DisplayText": itemDescription, "DisplaySubText": moboList.itemCode]
                moboListArray.add(moboList)
                moboListSearch.append(moboListDict)
            }
            dB.close()
        }
        return moboListArray.count > 0 ? (moboListArray, moboListSearch, false) : (nil, nil, false)
        }

    func getApi(_ timeSyncDict: [String : String], completion: @escaping (_ data: OrderListSync?, _ error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiOrders(timeSyncDict, credentialDict: self.apiCredentials){
            (apiDict, errorCode) in
            guard let orderListDict = apiDict,
                let orderHeaderDict = orderListDict["H"] as? [String : AnyObject],
                let orderDetailDict = orderListDict["D"] as? [String : AnyObject]
                else {
                    completion(nil, errorCode)
                    return
            }
            completion(OrderListSync(orderHeaderDict: orderHeaderDict, orderDetailDict: orderDetailDict), nil)
        }
    }
    
    func updateDb(_ orderListSync: OrderListSync) throws {
        let orderHeaderService = DatabaseService(tableName: DatabaseTable.OrderListHeader)
        let orderDetailService = DatabaseService(tableName: DatabaseTable.OrderListDetail)
        do {
            try orderHeaderService.updateDb(orderListSync.orderHeaderSync)
            try orderDetailService.updateDb(orderListSync.orderDetailSync)
        } catch ErrorCode.serverError {
            throw ErrorCode.serverError
        } catch {
            throw ErrorCode.dbError
        }
    }
    
    

}
