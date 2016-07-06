//
//  Order.swift
//  SalesPortal
//
//  Created by administrator on 6/3/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

enum OrderType: String {
    case Standard = "Standard Order"
    case Master = "Master Order"
    case Back = "Back Order"
    case PickUp = "Pick Up"
    case Unsaleable
    case BillHold = "Bill and Hold"
    
    static let allValues = [Standard.rawValue, Master.rawValue, Back.rawValue, PickUp.rawValue, Unsaleable.rawValue, BillHold.rawValue]
}

protocol OrderTypeErrorDelegate: class {
    func sendAlert(error: ErrorCode)
}

class Order: OrderInventoryDelegate {
    let account: Account
    let minShipDate: String
    var shipDate: String
    //var orderType: OrderType
    var orderInventory: NSMutableArray?
    var orderTotal: Double
    var mixPriceDict: [String : Double] = [:]
    var savedOrderDict: [String : (cases: Int, bottles:Int )] = [:]
    var notes: String?
    var poNo: String?
    var coopNo: String?
    var searchData: [[String : AnyObject]] = [[String : AnyObject]]()
    
    weak var errorDelegate: OrderTypeErrorDelegate?
    
    
    var coopCases: Int? {
        didSet {
            repriceCoop()
        }
    }
    
    var orderType: OrderType {
        didSet {
            checkOrderTypeLines()
        }
    }
    
    init(account: Account) {
        self.account = account
        self.shipDate = NSDate().getNextShip(account.shipDays).shipDate
        self.minShipDate = self.shipDate
        self.orderType = .Standard
        self.orderInventory = NSMutableArray()
        self.orderTotal = 0.0
    }
    
    func updateOrderPricing(mixDesc mixDesc: String, quantityDelta: Double) {
        orderTotal += quantityDelta
        switch account.priceLevel {
            case States.NJ:
                repriceAll(orderTotal.rounded())
            case States.NY:
                repriceMix(mixDesc: mixDesc, quantityDelta: quantityDelta)
        }
    }
    
    private func checkOrderTypeLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        var overSoldItems = ""
        for line in orderInventory where (line as? OrderInventory)?.bottleTotal > 0 {
            guard let item = line as? OrderInventory else {
                return
            }
            item.orderType = orderType
            if let itemCode = item.checkOrderTypeChangeOverSell() {
                overSoldItems += "\(itemCode),"
            }
        }
        if overSoldItems.characters.count > 0 {
            let overSoldList = overSoldItems[overSoldItems.startIndex..<overSoldItems.startIndex.advancedBy(overSoldItems.characters.count - 1)]
            errorDelegate?.sendAlert(ErrorCode.NoQuantity(itemCode: overSoldList))
        }
    }
    
    
    private func repriceCoop() {
        if let coopCases = coopCases {
            repriceAll(Double(coopCases))
        } else {
            repriceAll(orderTotal.rounded())
        }
    }
    
    private func setPrice(quantity quantity: Double, item: AnyObject) {
        guard let item = item as? OrderInventory else {
            return
        }
        //guard quantity != 0 else {
        //    item.delegate = self
        //    item.updateLinePricing(quantity)
        //    return
        //}
        let newPrice = item.isBottlePricing ? item.getPricing(Double(item.bottleTotal)) : item.getPricing(quantity)
        item.isOverride = newPrice != item.unitPrice
        item.unitPrice = newPrice
    }
    
    private func repriceAll(total: Double) {
        guard let orderInventory = orderInventory else {
            return
        }
        for line in orderInventory where (line as? OrderInventory)?.bottleTotal > 0 {
            setPrice(quantity: total, item: line)
        }
    }
    
    private func repriceMix(mixDesc mixDesc: String, quantityDelta: Double) {
        guard let orderInventory = orderInventory else {
            return
        }
        guard let mixItem = mixPriceDict[mixDesc] else {
            mixPriceDict[mixDesc] = quantityDelta
            return
        }
        let total = mixItem + quantityDelta
        mixPriceDict[mixDesc] = total
        let totalRounded = total.rounded()
        for line in orderInventory where (line as? OrderInventory)?.bottleTotal > 0 && (line as? OrderInventory)?.mixDescription == mixDesc {
            setPrice(quantity: totalRounded, item: line)
        }
    }
    
    func saveCurrentLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        for line in orderInventory where (line as? OrderInventory)?.bottleTotal > 0 {
            guard let item = line as? OrderInventory else {
                return
            }
            savedOrderDict[item.itemCode] = (cases: item.cases, bottles: item.bottles)
        }
    }
    
    func loadSavedLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        for (item, quantityTuple) in savedOrderDict {
            for line in orderInventory where (line as? OrderInventory)?.itemCode == item {
                guard let item = line as? OrderInventory else {
                    return
                }
                item.delegate = self
                item.orderType = self.orderType
                if quantityTuple.cases > 0 {
                    item.cases = quantityTuple.cases
                }
                if quantityTuple.bottles > 0 {
                    item.bottles = quantityTuple.bottles
                }
            }
        }
    }
    
}