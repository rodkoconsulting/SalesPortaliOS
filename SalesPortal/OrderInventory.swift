//
//  OrderInventory.swift
//  SalesPortal
//
//  Created by administrator on 6/7/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

protocol OrderInventoryDelegate: class {
    func updateOrderPricing(mixDesc mixDesc: String, quantityDelta: Double)
}

protocol OrderInventoryErrorDelegate: class {
    func sendAlert(error: ErrorCode)
}

class OrderInventory: Inventory {
    
    let lastQuantity: Double
    let lastPrice: Double
    let lastDate: NSDate
    
    var isOverride: Bool
    var orderType: OrderType?
    var cases: Int {
        didSet {
            if isOverSold  {
                cases = oldValue
                errorDelegate?.sendAlert(.NoQuantity(itemCode: itemCode))
                return
            }
            let quantityDelta = Double(cases - oldValue)
            updateLinePricing(quantityDelta)
        }
    }
    
    
    var bottles: Int {
        didSet {
            if bottlesExceedCase   {
                bottles = oldValue
                return
            }
            if isOverSold  {
                bottles = oldValue
                errorDelegate?.sendAlert(.NoQuantity(itemCode: itemCode))
                return
            }
            let quantityDelta = Double(bottles - oldValue) / Double(uomInt)
            updateLinePricing(quantityDelta)
        }
    }
    
    var unitPrice: Double
    
    var isOverSold : Bool {
        guard let orderType = orderType else {
            return false
        }
        switch orderType {
            case .Standard, .Master:
                return bottleQtyFromOpen > bottleQuantityAvailable
            case .Back:
                return bottleTotal > backOrderQuantityAvailable
            default:
                return false
        }
    }
    
    func checkOrderTypeChangeOverSell() -> String? {
        guard isOverSold else {
            return nil
        }
        //errorDelegate?.sendAlert(.NoQuantity(itemCode: itemCode))
        cases = 0
        bottles = 0
        return itemCode
    }
    
    var bottleQtyFromOpen : Int {
        return bottleTotal
    }
    
    var bottleTotal: Int {
        return cases * uomInt + bottles
    }
    
    var priceTotal: Double {
        return unitPrice * Double(bottleTotal) / Double(uomInt)
    }
    
    var bottlesExceedCase: Bool {
        return (bottles > uomInt - 1)
    }
    
    weak var delegate: OrderInventoryDelegate?
    weak var errorDelegate: OrderInventoryErrorDelegate?
    
    override init(queryResult: FMResultSet?, poDict: [String : poDictType]?) {
        self.cases = 0
        self.bottles = 0
        self.unitPrice = 0
        self.isOverride = false
        self.lastQuantity = queryResult?.doubleForColumn("last_qty") ?? 0
        self.lastPrice = queryResult?.doubleForColumn("last_price") ?? 0
        let lastDateString = queryResult?.stringForColumn("last_date")
        self.lastDate = lastDateString?.getShipDate() ??  NSDate.defaultPoDate()
        super.init(queryResult: queryResult, poDict: poDict)
        self.unitPrice = self.priceCase
    }
    
    private func updateLinePricing(quantityDelta: Double) {
        //if bottleTotal == 0 {
        //    unitPrice = priceCase
        //} else {
            unitPrice = isBottlePricing ? getPricing(Double(bottleTotal)) : getPricing(Double(bottleTotal) / Double(uomInt))
        //}
        isOverride = false
        delegate?.updateOrderPricing(mixDesc: mixDescription, quantityDelta: quantityDelta)
    }
}