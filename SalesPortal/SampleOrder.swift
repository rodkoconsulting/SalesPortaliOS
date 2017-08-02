//
//  Order.swift
//  SalesPortal
//
//  Created by administrator on 6/3/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



//protocol OrderTypeErrorDelegate: class {
//    func sendAlert(error: ErrorCode)
//}

//protocol OrderDelegate: class {
//    func orderTypeChanged(orderType orderType: OrderType)
//}

typealias SampleOrderSavedResults = (headerResults: FMResultSet, detailResults: [FMResultSet])?

class SampleOrder: isOrderType {
    var orderNo: Int?
    let account: Account? = nil
    var isSaved: Bool = false
    let shipToList: [OrderAddress]?
    var shipTo: OrderAddress?
    var minShipDate: String?
    var shipDate: String?
    var orderInventory: NSMutableArray?
    var savedDetailDict: DetailDictType = [:]
    var notes: String?
    var searchData: [[String : String]] = [[String : String]]()
    var overSoldItems = ""
    var orderType = OrderType.Sample
    
    //weak var errorDelegate: OrderTypeErrorDelegate?
    //weak var orderDelegate: OrderDelegate?
    
    
    init() {
        self.shipToList = OrderAddressService.getAddressList()
        self.shipTo = shipToList?[0]
        self.shipDate = OrderType.Standard.shipDate(account: nil)
        self.minShipDate = self.shipDate
        self.orderInventory = NSMutableArray()
    }
    
    
    var orderId: String? {
        guard let orderNo = orderNo else {
            return nil
        }
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        return "S\(deviceId)\(Constants.dbVersion)\(orderNo)"
    }
    
    var casesBottlesTotal: (cases: Double, bottles: Int) {
        var cases = 0.0
        var bottles = 0
        guard let orderInventory = orderInventory else {
            return (cases: cases, bottles: bottles)
        }
        for line in orderInventory where (line as? SampleOrderInventory)?.bottles > 0 {
            guard let item = line as? SampleOrderInventory else {
                return (cases: cases, bottles: bottles)
            }
            cases += Double(item.bottles) / Double(item.uomInt)
            bottles += item.bottles
        }
        return (cases: cases, bottles: bottles)
    }
    
    func saveCurrentLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        savedDetailDict.removeAll()
        for line in orderInventory where (line as? SampleOrderInventory)?.bottleTotal > 0 {
            guard let item = line as? SampleOrderInventory else {
                return
            }
            savedDetailDict[item.itemCode] = (bottles:item.bottleTotal, comment: item.comment)
        }
    }

    
    func loadSavedLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        overSoldItems = ""
        for (item, detailTuple) in savedDetailDict {
            for line in orderInventory where (line as? OrderInventory)?.itemCode == item {
                guard let line = line as? OrderInventory else {
                    return
                }
                let bottles = detailTuple.bottles
                let comment = detailTuple.comment
                if isSaved && line.isOverSold(bottles){
                    line.bottles = line.bottleQuantityAvailable
                    overSoldItems = overSoldItems + item + ","
                } else {
                    line.bottles = bottles
                }
                line.comment = comment
            }
        }
    }
    
    func loadSavedOrder(queryHeaderResult: FMResultSet?, detailDict: DetailDictType, moboDict: MoboDictType) {
        isSaved = true
        if let orderNo = queryHeaderResult?.int(forColumn: "order_no") {
            self.orderNo = Int(orderNo)
        }
        if let shipDate = queryHeaderResult?.string(forColumn: "ship_date") {
            let nextShipDate = self.orderType.shipDate(account: account)
            self.shipDate = shipDate < nextShipDate ? nextShipDate : shipDate
        }
        let shipToCode = queryHeaderResult?.string(forColumn: "customer_no")
        let addressIndex = shipToList?.index{$0.code == shipToCode} ?? 0
        shipTo = shipToList?[addressIndex]
        notes = queryHeaderResult?.string(forColumn: "notes")
        self.savedDetailDict = detailDict
    }
    
    var getDbHeaderInsert: String {
        let saveTime = Date().getDateTimeString()
        let shipToCode = shipTo?.code ?? ""
        let shipDate = self.shipDate ?? ""
        let notes = (self.notes ?? "").replacingOccurrences(of: "'", with: "''")
        let columns = "(TYPE, DIVISION_NO, CUSTOMER_NO, SAVE_TIME, SHIP_DATE, NOTES, COOP_QTY, COOP_NO, TOTAL_QTY, TOTAL_PRICE, PO_NO) "
        let values =  "VALUES ('" + "\(OrderType.Sample.rawValue)" + "', '" + "" + "', '" + shipToCode + "', '" + saveTime + "', '" + shipDate + "', '" + notes + "', 0, '" + "" + "', \(casesBottlesTotal.cases), 0, '" + "" + "')"
        return columns + values
    }
    
    func getDbDetailInsert(orderNo: Int?) -> String? {
        var details : String = ""
        guard let orderInventory = orderInventory,
            let orderNo = orderNo else {
                return nil
        }
        for line in orderInventory where (line as? SampleOrderInventory)?.bottles > 0 {
            guard let inventory = line as? SampleOrderInventory else {
                return nil
            }
            details = details + inventory.getDbDetailInsert(orderNo) + ","
        }
        guard details.characters.count > 0 else {
            return nil
        }
        return details[details.startIndex..<details.characters.index(details.startIndex, offsetBy: details.characters.count - 1)]
    }
    
    func getDbHeaderUpdate() ->  String? {
        guard let orderNo = orderNo else {
            return nil
        }
        let saveTime = Date().getDateTimeString()
        let shipToCode = shipTo?.code ?? ""
        let shipDate = self.shipDate ?? ""
        let notes = (self.notes ?? "").replacingOccurrences(of: "'", with: "''")
        return "CUSTOMER_NO='" + shipToCode + "', TYPE='" + "\(OrderType.Sample.rawValue)" + "', SAVE_TIME='" + saveTime + "', SHIP_DATE='" + shipDate + "', NOTES='" + notes + "', COOP_QTY=0, COOP_NO='" + "" + "', TOTAL_QTY=\(casesBottlesTotal.cases), TOTAL_PRICE=0, PO_NO='" + "" + "' WHERE ORDER_NO=\(orderNo)"
    }
    
    func saveOrder() throws {
        do {
            var orderSavedService = OrderSavedService<SampleOrder>(order: self)
            try orderSavedService.saveOrder()
        } catch {
            throw ErrorCode.dbError
        }
    }

    
    func deleteOrder() throws {
        do {
            guard orderNo != nil else {
                return
            }
            let orderSavedService = OrderSavedService<SampleOrder>(order: self)
            try orderSavedService.deleteOrder()
        } catch {
            throw ErrorCode.dbError
        }
    }
    
    func getTransmitData() -> Data? {
        guard let orderInventory = orderInventory,
            let shipTo = self.shipTo?.code else {
            return nil
        }
        var orderDict = [String : AnyObject]()
        var detailArray = [[String : AnyObject]]()
        let notes = (self.notes ?? "").replacingOccurrences(of: "'", with: "")
        let id = orderId ?? ""
        orderDict["shipTo"] = shipTo as AnyObject
        orderDict["date"] = shipDate as AnyObject
        orderDict["note"] = notes as AnyObject
        orderDict["id"] = id as AnyObject
        for line in orderInventory where (line as? SampleOrderInventory)?.bottles > 0 {
            guard let line = line as? SampleOrderInventory else {
                continue
            }
            let comment = (line.comment ?? "").replacingOccurrences(of: "'", with: "")
            var detailDict = [String : AnyObject]()
            detailDict["item"] = line.itemCode as AnyObject
            detailDict["qty"] = line.bottles as AnyObject
            detailDict["comment"] = comment as AnyObject
            detailArray.append(detailDict)
        }
        orderDict["details"] = detailArray as AnyObject
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: orderDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
}
