//
//  OrderInventory.swift
//  SalesPortal
//
//  Created by administrator on 6/7/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

protocol OrderInventoryDelegate: class {
    func updateOrderPricing(mixDesc: String, quantityDelta: Double)
}


class AccountOrderInventory: OrderInventory {
    
    var lastPrice: Double
    var moboListArray: [MoboList] = [MoboList]()

    var orderType: OrderType?
    override var cases: Int {
        didSet {
            guard !isReversal else {
                return
            }
            if cases < 0 {
                isReversal = true
                cases = oldValue
                isReversal = false
                return
            }
            if isGridUpdate && isOverSold(bottleTotal)  {
                isReversal = true
                cases = oldValue
                isReversal = false
                errorDelegate?.sendAlert(.noQuantity(itemCode: itemCode))
                return
            }
            let quantityDelta = Double(cases - oldValue)
            updateLinePricing(quantityDelta)
            if isGridUpdate {
                updateMoboList((cases - oldValue)*uomInt)
            }
            errorDelegate?.saveOrderDelegate()
        }
    }
    
    
    override var bottles: Int {
        didSet {
            guard !isReversal else {
                return
            }
            if bottlesExceedCase() || bottles < 0  {
                isReversal = true
                bottles = oldValue
                isReversal = false
                return
            }
            if isGridUpdate && isOverSold(bottleTotal)  {
                isReversal = true
                bottles = oldValue
                isReversal = false
                errorDelegate?.sendAlert(.noQuantity(itemCode: itemCode))
                return
            }
            let quantityDelta = Double(bottles - oldValue) / Double(uomInt)
            updateLinePricing(quantityDelta)
            if isGridUpdate {
                updateMoboList(bottles - oldValue)
            }
            errorDelegate?.saveOrderDelegate()
        }
    }
    
    var unitPrice: Double = 0.0
    
    var isPriceOverride: Bool {
        return isBottlePricing ? unitPrice != priceBottle : unitPrice != linePricing
    }
    
    override func isOverSold(_ bottleTotal: Int) -> Bool  {
        guard let orderType = orderType else {
            return false
        }
        switch orderType {
            case .Standard, .BillHoldInvoice, .Master:
                return bottleTotal > bottleQuantityAvailable + moboTotal.available
            case .Back:
                return bottleTotal > backOrderQuantityAvailable + moboTotal.available
            case .BillHoldShip:
                return bottleTotal > moboTotal.available
            default:
                return false
        }
    }
    
    func CasesBottlesFromTotal(_ totalBottles: Int) -> (cases: Int, bottles: Int) {
        let cases = totalBottles / uomInt
        let bottles = totalBottles - cases * uomInt
        return (cases, bottles)
    }
    
    var shipAvailable: (cases: Int, bottles: Int) {
        guard let orderType = orderType else {
            return (0, 0)
        }
        switch orderType {
        case .Standard, .BillHoldInvoice:
            return CasesBottlesFromTotal(bottleQuantityAvailable + moboTotal.available)
        case .Master:
            return CasesBottlesFromTotal(bottleQuantityAvailable)
        case .Back:
            return CasesBottlesFromTotal(backOrderQuantityAvailable)
        case .BillHoldShip:
            return CasesBottlesFromTotal(moboTotal.available)
        default:
            return (0, 0)
        }
    }
    
    func checkOrderTypeChangeOverSell() -> String? {
        guard isOverSold(bottleTotal) else {
            return nil
        }
        cases = 0
        bottles = 0
        return itemCode
    }
    
    var priceTotal: Double {
        return (unitPrice * Double(bottleTotal) / Double(uomInt)).roundToPlaces(2)
    }
    
    lazy var bottlesExceedCase: () -> Bool = {
        [unowned self] in
        return (self.bottles > self.uomInt - 1)
    }
    
    var moboString: String {
        var mobos = ""
        for moboList in moboListArray {
            mobos = mobos + moboList.orderNo + ","
        }
        if mobos.count > 0 {
            mobos = String(mobos[mobos.startIndex..<mobos.index(mobos.startIndex, offsetBy: mobos.count - 1)])
        }
        return mobos
    }
    
    weak var delegate: OrderInventoryDelegate?
    
    override init(queryResult: FMResultSet?, poDict: [String : poDictType]?) {
        self.lastPrice = queryResult?.double(forColumn: "last_price") ?? 0
        super.init(queryResult: queryResult, poDict: poDict)
        self.unitPrice = priceCase
        self.cases = 0
    }
    
    fileprivate func updateLinePricing(_ quantityDelta: Double) {
        guard let orderType = orderType else {
            return
        }
        unitPrice = orderType != .BillHoldShip ? linePricing : 0
        delegate?.updateOrderPricing(mixDesc: mixDescription, quantityDelta: quantityDelta)
    }
    
    var linePricing: Double {
        return isBottlePricing ? getPricing(Double(bottleTotal)) * Double(uomInt): getPricing(Double(bottleTotal) / Double(uomInt))
    }
    
    
    var moboTotal : (cases: Int, bottles: Int, quantity: Int, available: Int) {
        
        var cases: Int = 0
        var bottles: Int = 0
        var quantity: Int = 0
        var available: Int = 0
        for moboList in moboListArray {
            cases += moboList.cases
            bottles += moboList.bottles
            quantity += moboList.orderBottleTotal
            available += moboList.moboBottleTotal
       }
        return (cases, bottles, quantity, available)
    }
    
    fileprivate func syncMobo() {
        isGridUpdate = false
        cases = moboTotal.cases
        bottles = moboTotal.bottles
        setUnitPrice()
        isGridUpdate = true
    }
    
    fileprivate func setUnitPrice() {
        if let orderType = orderType {
            if orderType == OrderType.BillHoldShip {
                unitPrice = 0
            }
        }
    }
    
    fileprivate func clearMoboList(_ moboList: MoboList) {
        if moboList.orderBottleTotal == 0 {
            if let moboIndex = moboListArray.firstIndex(of: moboList) {
                moboListArray.remove(at: moboIndex)
            }
        }
    }
    
    fileprivate func updateMoboList(_ quantityBottles: Int) {
        var quantityDepleted : Int = 0
        for moboList in moboListArray {
            moboList.isGridUpdate = false
            if quantityBottles < 0 {
                if moboList.orderBottleTotal >= abs(quantityBottles - quantityDepleted) {
                    moboList.depleteBottles(quantityBottles)
                    moboList.isGridUpdate = true
                    clearMoboList(moboList)
                    break
                } else {
                    quantityDepleted -= moboList.orderBottleTotal
                    moboList.depleteBottles(-moboList.orderBottleTotal)
                    clearMoboList(moboList)
                }
            } else {
                if moboList.moboBottleAvailable >= quantityBottles - quantityDepleted {
                    moboList.depleteBottles(quantityBottles - quantityDepleted)
                    moboList.isGridUpdate = true
                    break
                } else {
                    quantityDepleted += moboList.moboBottleAvailable
                    moboList.depleteBottles(moboList.moboBottleAvailable)
                }
            }
            moboList.isGridUpdate = true
        }
    }
    
    func loadMoboArray(moboList: MoboList) {
        if !moboListArray.contains(moboList) {
            moboListArray.append(moboList)
        } else if moboList.orderBottleTotal == 0 {
            clearMoboList(moboList)
        }
    }
    
    func updateMoboArray(moboList: MoboList) {
        loadMoboArray(moboList: moboList)
        syncMobo()
    }
    
    override func getDbDetailInsert(_ orderNo: Int) -> String {
        let isPriceOverrideInt = isPriceOverride ? 1 : 0
        return "(\(orderNo), '" + itemCode + "', \(bottleTotal), \(unitPrice), '" + moboString + "', \(moboTotal.quantity), \(isPriceOverrideInt), '')"
    }
}
