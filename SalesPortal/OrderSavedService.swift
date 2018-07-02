//
//  MoboListService.swift
//  SalesPortal
//
//  Created by administrator on 7/11/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation





typealias DetailDictType = [String : (bottles: Int, comment: String?)]
typealias MoboDictType = [String : (list: String, bottles: Int)]

struct OrderSavedService<T: isOrderType> {
    
    var order: T
    
    init(order: T) {
        self.order = order
    }
    
    fileprivate func insertOrderDetail(_ dB: FMDatabase) throws {
        var sqlInsertDetail = "INSERT INTO ORDER_DETAIL VALUES"
        guard let sqlInsertValues = order.getDbDetailInsert(orderNo: order.orderNo) else {
            return
        }
        sqlInsertDetail += sqlInsertValues
        let isInsertedDetail = dB.executeUpdate(sqlInsertDetail, withArgumentsIn: nil)
        guard isInsertedDetail else {
            throw ErrorCode.dbError
        }
    }
    
    fileprivate func deleteOrderDetail(_ dB: FMDatabase) throws {
        guard let orderNo = order.orderNo else {
            throw ErrorCode.dbError
        }
        let sqlDeleteDetail = "DELETE FROM ORDER_DETAIL WHERE ORDER_NO=\(orderNo)"
        let isDeletedDetail = dB.executeUpdate(sqlDeleteDetail, withArgumentsIn: nil)
        guard isDeletedDetail else {
            throw ErrorCode.dbError
        }
    }
    
    fileprivate func insertOrderHeader(_ dB: FMDatabase) throws {
        var sqlInsertHeader = "INSERT INTO ORDER_HEADER "
        sqlInsertHeader += order.getDbHeaderInsert
        let isInsertedHeader = dB.executeUpdate(sqlInsertHeader, withArgumentsIn: nil)
        guard isInsertedHeader else {
            throw ErrorCode.dbError
        }
    }
    
    fileprivate func updateOrderDetail(_ dB: FMDatabase) throws {
        do {
            try deleteOrderDetail(dB)
            try insertOrderDetail(dB)
        } catch {
            throw ErrorCode.dbError
        }
    }
    
    fileprivate func updateOrderHeader(_ dB: FMDatabase) throws {
        var sqlUpdateHeader = "UPDATE ORDER_HEADER SET "
        guard let sqlUpdateValues = order.getDbHeaderUpdate() else {
            throw ErrorCode.dbError
        }
        sqlUpdateHeader += sqlUpdateValues
        let isUpdatedHeader = dB.executeUpdate(sqlUpdateHeader, withArgumentsIn: nil)
        guard isUpdatedHeader else {
            throw ErrorCode.dbError
        }
    }
    
    fileprivate func deleteOrderHeader(_ dB: FMDatabase) throws {
        guard let orderNo = order.orderNo else {
            throw ErrorCode.dbError
        }
        let sqlDeleteHeader = "DELETE FROM ORDER_HEADER WHERE ORDER_NO=\(orderNo)"
        let isDeletedHeader = dB.executeUpdate(sqlDeleteHeader, withArgumentsIn: nil)
        guard isDeletedHeader else {
            throw ErrorCode.dbError
        }
    }
    
    mutating func saveOrder() throws {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            throw ErrorCode.dbErrorSave
        }
        guard dB.open() else {
            throw ErrorCode.dbErrorSave
        }
        defer {
            dB.close()
        }
        if order.orderNo != nil {
            do {
                try updateOrderHeader(dB)
                try updateOrderDetail(dB)
            } catch {
                throw ErrorCode.dbErrorSave
            }
        } else {
            do {
                try insertOrderHeader(dB)
                order.orderNo = Int(dB.lastInsertRowId())
                try insertOrderDetail(dB)
            } catch {
                throw ErrorCode.dbErrorSave
            }
        }
    }
    
    
    func deleteOrder() throws {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            throw ErrorCode.dbErrorSave
        }
        guard dB.open() else {
            throw ErrorCode.dbError
        }
        defer {
            dB.close()
        }
        do {
            try deleteOrderHeader(dB)
            try deleteOrderDetail(dB)
        } catch {
            throw ErrorCode.dbError
        }
    }
    
    static func queryOrderSavedList() -> (gridData:NSMutableArray?, searchData: [[String : String]]?)  {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil)
        }
        let orderSavedArray = NSMutableArray()
        var orderSavedSearch = [[String : String]]()
        if dB.open() {
            let sqlQuery =
                "SELECT h.ORDER_NO, h.TYPE, h.SAVE_TIME, h.SHIP_DATE, h.TOTAL_QTY, h.TOTAL_PRICE, h.SHIP_TO, " +
                    "a.CUSTOMER_NAME " +
                    "FROM ORDER_HEADER h INNER JOIN ACCOUNTS_LIST a ON h.DIVISION_NO = a.DIVISION_NO and h.CUSTOMER_NO = a.CUSTOMER_NO " +
                    "UNION ALL " +
                    "SELECT h.ORDER_NO, '\(OrderType.Sample.rawValue)', h.SAVE_TIME, h.SHIP_DATE, h.TOTAL_QTY, h.TOTAL_PRICE, h.CUSTOMER_NO, " +
                    "sa.NAME " +
                    "FROM ORDER_HEADER h INNER JOIN SAMPLE_ADDRESSES sa on h.CUSTOMER_NO = sa.CODE WHERE h.TYPE='\(OrderType.Sample.rawValue)' " +
                    "ORDER BY h.ORDER_NO DESC"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                guard let orderSavedList = OrderSavedList(queryResult: results!) else {
                    continue
                }
                let orderSavedListDict = ["DisplayText": orderSavedList.customerName]
                orderSavedArray.add(orderSavedList)
                orderSavedSearch.append(orderSavedListDict)
            }
            dB.close()
        }
        return orderSavedArray.count > 0 ? (orderSavedArray, orderSavedSearch) : (nil, nil)
    }
    
    static func queryOrderSaved(orderNo: Int) -> isOrderType? {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return nil
        }
        var savedDetailDict: DetailDictType = [:]
        var savedMoboDict: MoboDictType = [:]
        var order: isOrderType?
        guard dB.open() else {
            return nil
        }
        let sqlAccountQuery = "SELECT a.DIVISION_NO, a.CUSTOMER_NO, a.CUSTOMER_NAME, a.SHIP_DAYS, a.PRICE_LEVEL, a.COOP_LIST " +
            "FROM ACCOUNTS_LIST a INNER JOIN ORDER_HEADER h ON a.DIVISION_NO = h.DIVISION_NO and a.CUSTOMER_NO = h.CUSTOMER_NO " +
            "WHERE h.ORDER_NO = \(orderNo)"
        let sqlHeaderQuery =
            "SELECT h.ORDER_NO, h.TYPE, h.DIVISION_NO, h.CUSTOMER_NO, h.SHIP_DATE, h.NOTES, h.COOP_QTY, h.COOP_NO, h.PO_NO, h.SHIP_TO " +
                "FROM ORDER_HEADER h " +
                "WHERE h.ORDER_NO = \(orderNo)"
        let sqlDetailQuery =
            "SELECT d.ITEM_CODE, d.BOTTLES, d.MOBO, d.MOBO_BOTTLES, d.COMMENT " +
                "FROM ORDER_DETAIL d " +
                "WHERE d.ORDER_NO = \(orderNo)"
        let accountResults: FMResultSet? = dB.executeQuery(sqlAccountQuery, withArgumentsIn: nil)

        if accountResults?.next() == true {
            let account = Account(queryResult: accountResults)
            order = AccountOrder(account: account)
        } else {
            order = SampleOrder()
        }
        let headerResults: FMResultSet? = dB.executeQuery(sqlHeaderQuery, withArgumentsIn: nil)
        guard headerResults?.next() == true  else {
            return nil
        }
        let detailResults: FMResultSet? = dB.executeQuery(sqlDetailQuery, withArgumentsIn: nil)
        while detailResults?.next() == true {
            if let itemCode = detailResults?.string(forColumn: "item_code"),
                let bottles = detailResults?.int(forColumn: "bottles") {
                let comment = detailResults?.string(forColumn: "comment")
                savedDetailDict[itemCode] = (bottles: Int(bottles), comment: comment)
                if let moboList = detailResults?.string(forColumn: "mobo"),
                    let moboBottles = detailResults?.int(forColumn: "mobo_bottles")
                    {
                        savedMoboDict[itemCode] = (list: moboList, bottles: Int(moboBottles))
                    }
            }
        }
        order?.loadSavedOrder(queryHeaderResult: headerResults!, detailDict: savedDetailDict, moboDict: savedMoboDict)
        dB.close()
        return order
    }
    
    
    static func deleteSavedOrder(orderNo: Int) throws {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            throw ErrorCode.dbError
        }
        guard dB.open() else {
            throw ErrorCode.dbError
        }
        defer {
            dB.close()
        }
        let sqlDeleteHeader = "DELETE FROM ORDER_HEADER WHERE ORDER_NO=\(orderNo)"
        let isDeletedHeader = dB.executeUpdate(sqlDeleteHeader, withArgumentsIn: nil)
        guard isDeletedHeader else {
            throw ErrorCode.dbError
        }
        let sqlDeleteDetail = "DELETE FROM ORDER_DETAIL WHERE ORDER_NO=\(orderNo)"
        let isDeletedDetail = dB.executeUpdate(sqlDeleteDetail, withArgumentsIn: nil)
        guard isDeletedDetail else {
            throw ErrorCode.dbError
        }
    }
    
    
    
   
    
    
    

    
}
