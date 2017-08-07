//
//  AccountService.swift
//  SalesPortal
//
//  Created by administrator on 5/23/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

class OrderListService: SyncService, SyncServiceType {
    
//    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : AnyObject]]?) {
//        let dB = FMDatabase(path: Constants.databasePath)
//        let orderListArray = NSMutableArray()
//        var orderListSearch = [[String : AnyObject]]()
//        if dB.open() {
//            let sqlQuery =
//                "SELECT H.ORDER_NO, h.ORDER_DATE, h.SHIP_DATE, h.TYPE, h.STATUS, h.HOLD, h.COOP, h.COMMENT, " +
//                    "d.ITEM_CODE, d.QTY, d.PRICE, d.TOTAL " +
//                    "i.DESC, i.BRAND, i.PRICE, i.VINTAGE, i.UOM, i.SIZE, i.DAMAGED_NOTES " +
//                    "a.CUSTOMER_NAME " +
//                    "FROM ACCOUNTS_LIST a INNER JOIN ORDER_LIST_HEADER h ON a.DIVISION_NO = h.DIVISION_NO and a.CUSTOMER_NO = h.CUSTOMER_NO " +
//                    "INNER JOIN ORDER_LIST_DETAIL d ON h.ORDER_NO = d.ORDER_NO " +
//            "LEFT OUTER JOIN INV_DESC i ON d.ITEM_CODE = i.ITEM_CODE "
//            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsInArray: nil)
//            while results?.next() == true {
//                guard let orderList = OrderList(queryResult: results!) else {
//                    continue
//                }
//                let orderListDict = ["DisplayText": orderList.customerName]
//                orderListArray.addObject(orderList)
//                orderListSearch.append(orderListDict)
//            }
//            dB.close()
//        }
//        return orderListArray.count > 0 ? (orderListArray, orderListSearch) : (nil, nil)
//    }
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let orderListArray = NSMutableArray()
        var orderListSearch = [[String : String]]()
        let date = Date().getDailySalesDateString()
        var isMultipleReps = false
        var previousRep : String = ""
        if dB.open() {
            let sqlQuery =
            "SELECT hoi.ORDER_NO, a.CUSTOMER_NAME, a.CUSTOMER_NO, hoi.ORDER_DATE, hoi.SHIP_DATE, hoi.PO_ETA, hoi.STATUS, hoi.HOLD, hoi.COOP, " +
            "hoi.COMMENT, hoi.ITEM_CODE, " +
            "i.DESC, i.BRAND, i.VINTAGE, i.UOM, i.SIZE, i.DAMAGED_NOTES, " +
            "hoi.QTY, hoi.PRICE, hoi.TOTAL, " +
            "a.REP, a.REGION " +
            "FROM (" +
            "SELECT DISTINCT h.DIVISION_NO, h.CUSTOMER_NO, h.ORDER_NO, h.ORDER_DATE, h.SHIP_DATE, p.PO_ETA, h.STATUS, h.HOLD, h.COOP, h.COMMENT, " +
            "d.ITEM_CODE, d.LINE_NO, d.QTY, d.PRICE, d.TOTAL, d.COMMENT AS LINE_COMMENT " +
            "FROM ORDER_LIST_HEADER h " +
            "INNER JOIN ORDER_LIST_DETAIL d ON h.ORDER_NO = d.ORDER_NO " +
            "LEFT OUTER JOIN INV_PO p ON d.ITEM_CODE = p.ITEM_CODE " +
            "WHERE (p.PO_ETA ISNULL or p.PO_ETA = (SELECT PO_ETA FROM INV_PO AS p2 WHERE p2.ITEM_CODE = p.ITEM_CODE ORDER BY PO_ETA LIMIT 1)) " +
            "UNION ALL " +
            "SELECT hi.DIVISION_NO, hi.CUSTOMER_NO, hi.INVOICE_NO, hi.INVOICE_DATE, hi.INVOICE_DATE, " +
            "null, 'I', null, '', hi.COMMENT, di.ITEM_CODE, di.DETAIL_SEQ_NO, di.QUANTITY, di.PRICE, di.TOTAL, '' AS LINE_COMMENT " +
            "FROM ACCOUNTS_INV_HEAD hi " +
            "INNER JOIN ACCOUNTS_INV_DET di " +
            "ON hi.INVOICE_NO = di.INVOICE_NO and hi.HEADER_SEQ_NO = di.HEADER_SEQ_NO " +
            "WHERE hi.INVOICE_DATE = '" + date + "'" +
            ") hoi " +
            "INNER JOIN " +
            "(" +
            "SELECT DIVISION_NO, CUSTOMER_NO, REGION, REP, CUSTOMER_NAME FROM ACCOUNTS_LIST " +
            "UNION ALL " +
            "SELECT '00', CODE, REGION, REP, NAME FROM SAMPLE_ADDRESSES " +
            ") a " +
            "ON hoi.DIVISION_NO = a.DIVISION_NO AND hoi.CUSTOMER_NO = a.CUSTOMER_NO " +
            "LEFT OUTER JOIN " +
            "(" +
            "SELECT ITEM_CODE, DESC, BRAND, VINTAGE, UOM, SIZE, DAMAGED_NOTES FROM INV_DESC " +
            "UNION " +
            "SELECT ITEM_CODE, DESC, BRAND, VINTAGE, UOM, SIZE, DAMAGED_NOTES FROM ACCOUNTS_ITEMS_INACTIVE " +
            ") i " +
            "ON hoi.ITEM_CODE = i.ITEM_CODE " +
            "ORDER BY a.REGION, a.REP, a.CUSTOMER_NAME, hoi.ORDER_DATE desc"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
//                guard let orderList = OrderList(queryResult: results!) else {
//                    continue
//                }
                let orderList = OrderList(queryResult: results!)
                if !isMultipleReps {
                    if previousRep.characters.count > 0 && previousRep != orderList.rep {
                        isMultipleReps = true
                    } else
                    {
                        previousRep = orderList.rep
                    }
                }
                //if !orderListSearch.contains({ $0.values.contains(orderList.customerNo) }) {
                let customerListDict = ["DisplayText": orderList.customerName, "DisplaySubText": orderList.customerNo]
                if !orderListSearch.contains(where: {$0 == customerListDict}) {
                    orderListSearch.append(customerListDict)
                }
                //if !orderListSearch.contains({ $0.values.contains(orderList.itemCode) }) {
                if let itemDescription = orderList.itemDescription {
                    let itemListDict = ["DisplayText": itemDescription, "DisplaySubText": orderList.itemCode]
                    if !orderListSearch.contains(where: {$0 == itemListDict}) {
                        orderListSearch.append(itemListDict)
                    }
                }
                //}
                orderListArray.add(orderList)
            }
            dB.close()
        }
        return orderListArray.count > 0 ? (orderListArray, orderListSearch, isMultipleReps) : (nil, nil, false)
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


