//
//  OrderInventory.swift
//  SalesPortal
//
//  Created by administrator on 2/6/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation
//
//  OrderInventory.swift
//  SalesPortal
//
//  Created by administrator on 6/7/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

protocol OrderInventoryErrorDelegate: class {
    func sendAlert(_ error: ErrorCode)
    func saveOrderDelegate()
}


protocol isOrderInventory {
    weak var errorDelegate: OrderInventoryErrorDelegate? { get set }
}


class OrderInventory: Inventory, isOrderInventory {
    
    let lastQuantity: Double
    let lastDate: Date
    var comment: String?
    let groupKey: String = ""
    var isReversal: Bool = false
    
    var isGridUpdate: Bool = true
    
    var cases: Int = 0
    
    var bottles: Int {
        didSet {
            guard !isReversal else {
                return
            }
            if bottles < 0  {
                isReversal = true
                bottles = oldValue
                isReversal = false
                return
            }
            if isOverSold(bottles)  {
                isReversal = true
                bottles = oldValue
                isReversal = false
                errorDelegate?.sendAlert(.noQuantity(itemCode: itemCode))
                return
            }
            errorDelegate?.saveOrderDelegate();
        }
    }
    
    var bottleTotal: Int {
        return cases * uomInt + bottles
    }
    
    func isOverSold(_ bottleTotal: Int) -> Bool  {
        return bottleTotal > bottleQuantityAvailable
    }
    
    weak var errorDelegate: OrderInventoryErrorDelegate?
    
    override init(queryResult: FMResultSet?, poDict: [String : poDictType]?) {
        self.bottles = 0
        self.lastQuantity = queryResult?.double(forColumn: "last_qty") ?? 0
        let lastDateString = queryResult?.string(forColumn: "last_date")
        self.lastDate = lastDateString?.getShipDate() ??  Date.defaultPoDate()
        super.init(queryResult: queryResult, poDict: poDict)
    }
    
    func getDbDetailInsert(_ orderNo: Int) -> String {
        return "(\(orderNo), '" + itemCode + "', \(bottles))"
    }

    
}
