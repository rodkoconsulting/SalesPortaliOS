//
//  Order.swift
//  SalesPortal
//
//  Created by administrator on 6/3/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

enum OrderType: String {
    case Standard = "S"
    case Master = "M"
    case Back = "BO"
    case PickUp = "P"
    case Unsaleable = "U"
    case BillHoldShip = "BHS"
    case BillHoldInvoice = "BHI"
    case Sample = "SMP"
    
    static let allValues = [Standard.orderText, Master.orderText, Back.orderText, PickUp.orderText, Unsaleable.orderText, BillHoldShip.orderText, BillHoldInvoice.orderText]
    static let rawValues = [Standard.rawValue, Master.rawValue, Back.rawValue, PickUp.rawValue, Unsaleable.rawValue, BillHoldShip.rawValue, BillHoldInvoice.rawValue]
    
}

extension OrderType {
    var orderText: String {
        switch self {
        case .Standard:
            return "Standard Order"
        case .Master:
            return "Master Order"
        case .Back:
            return "Back Order"
        case .PickUp:
            return "Pick Up"
        case .Unsaleable:
            return "Unsaleable"
        case .BillHoldInvoice:
            return "BH Order"
        case .BillHoldShip:
            return "BH Ship"
        case .Sample:
            return "Sample"
        }
    }
    
    var apiString: String {
        switch self {
        case .Sample:
            return Module.sampleOrder.apiInit
        default:
            return Module.accountOrder.apiInit
        }
        
    }
    
    var getIndex: Int? {
        return OrderType.allValues.index(of: self.orderText)
    }
    
    func shipDate(account: Account?) -> String? {
        switch self {
        case .Standard, .PickUp, .BillHoldShip:
            return Date().getNextShip(account?.shipDays).shipDate
        case .Master, .Back, .Unsaleable, .BillHoldInvoice:
            return nil
        case .Sample:
            return Date().getNextShip().shipDate
        }
    }
    
    
    
}

protocol OrderTypeErrorDelegate: class {
    func sendAlert(_ error: ErrorCode)
}

protocol OrderDelegate: class {
    func orderTypeChanged(orderType: OrderType)
    func coopCasesChanged()
}

typealias OrderSavedResults = (headerResults: FMResultSet, detailResults: [FMResultSet])?

class AccountOrder: isOrderType, OrderInventoryDelegate, MoboListDelegate {
    var orderNo: Int? 
    var isSaved: Bool = false
    let account: Account?
    var minShipDate: String?
    var shipDate: String?
    var orderInventory: NSMutableArray?
    var orderMobos: NSMutableArray?
    var orderTotal: Double
    var shipToList: [isOrderAddress]? = nil
    var shipTo: isOrderAddress? = nil
    var mixPriceDict: [String : Double] = [:]
    var savedDetailDict: DetailDictType = [:]
    var savedMoboDict: MoboDictType = [:]
    var notes: String?
    var poNo: String?
    var coopNo: String?
    var searchData: [[String : String]] = [[String : String]]()
    var moboSearchData: [[String : String]] = [[String : String]]()
    var overSoldItems = ""
    
    weak var errorDelegate: OrderTypeErrorDelegate?
    weak var orderDelegate: OrderDelegate?
    
    
    var coopCases: Int? {
        didSet {
            repriceNJ()
            orderDelegate?.coopCasesChanged()
        }
    }
    
    var orderType: OrderType {
        didSet {
            checkOrderTypeLines()
            if oldValue == .Standard || oldValue == .BillHoldShip || oldValue == .BillHoldInvoice {
                deleteMobos()
            }
            if (orderType != .Standard) {
                clearCoop()
            }
            orderTypeChanged()
            orderDelegate?.orderTypeChanged(orderType: orderType)
        }
    }
    
    private func clearCoop()
    {
        coopCases = 0;
        coopNo = "";
    }
    
    init(account: Account) {
        self.account = account
        self.orderType = .Standard
        self.shipDate = OrderType.Standard.shipDate(account: account)
        self.minShipDate = self.shipDate
        self.orderInventory = NSMutableArray()
        self.orderTotal = 0.0
        let shipToTuple = AccountOrderAddressService.getAddressList(account: account)
        self.shipToList = shipToTuple.list
        self.shipTo = shipToTuple.primary
    }
    
    func updateOrderPricing(mixDesc: String, quantityDelta: Double) {
        orderTotal += quantityDelta
        guard orderType != OrderType.BillHoldShip else {
            return
        }
        guard let priceLevel = account?.priceLevel else {
            return
        }
        switch priceLevel {
            case States.NJ:
                repriceNJ()
            case States.NY:
                repriceMix(mixDesc: mixDesc, quantityDelta: quantityDelta)
            default:
                return
        }
    }
    
    fileprivate func orderTypeChanged() {
        guard let shipDate = orderType.shipDate(account: account) else {
            self.shipDate = nil
            return
        }
        if self.shipDate == nil {
            self.shipDate = shipDate
            minShipDate = shipDate
        }
    }
    
    fileprivate func deleteMobos() {
        guard let orderMobos = orderMobos else {
            return
        }
        for moboList in orderMobos {
            guard let moboList = moboList as? MoboList else {
                return
            }
            moboList.deleteAll()
        }
    }

    fileprivate func checkOrderTypeLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        var overSoldItems = ""
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0 ) > 0 {
            guard let item = line as? AccountOrderInventory else {
                return
            }
            item.orderType = orderType
            if let itemCode = item.checkOrderTypeChangeOverSell() {
                overSoldItems = overSoldItems + itemCode + ","
            }
        }
        if overSoldItems.count > 0 {
            let overSoldList = overSoldItems[overSoldItems.startIndex..<overSoldItems.index(overSoldItems.startIndex, offsetBy: overSoldItems.count - 1)]
            errorDelegate?.sendAlert(ErrorCode.noQuantity(itemCode: String(overSoldList)))
        }
    }

    fileprivate func repriceNJ() {
        guard let orderInventory = self.orderInventory else {   
            return
        }
        let orderTotal = Int(self.orderTotal.roundedCases())
        let coopTotal = orderType == .Standard ? (self.coopCases ?? 0) : 0;
        let caseThreshold = Constants.njCaseThreshold
        var totalPricing: Int;
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0 ) > 0 {
            guard let line = line as? AccountOrderInventory else {
                continue
            }
            if (orderTotal > caseThreshold)
            {
                totalPricing = line.cases > caseThreshold ? line.cases : caseThreshold
            } else {
                totalPricing = orderTotal > coopTotal ? orderTotal : coopTotal
            }
            setPrice(quantity: Double(totalPricing), item: line)
        }
    }
    
    fileprivate func setPrice(quantity: Double, item: AnyObject) {
        guard let item = item as? AccountOrderInventory else {
            return
        }
        let newPrice = item.isBottlePricing ? item.getPricing(Double(item.bottleTotal)) * Double(item.uomInt) : item.getPricing(quantity)
        item.unitPrice = newPrice
    }
    
    var priceTotal: Double {
        guard let orderInventory = orderInventory else {
            return 0
        }
        var total = 0.0
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0 ) > 0 {
            guard let line = line as? AccountOrderInventory else {
                return 0
            }
            total += line.priceTotal
        }
        return total
    }
    
    var orderId: String? {
        guard let orderNo = orderNo else {
            return nil
        }
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        return "\(deviceId)\(Constants.dbVersion)\(orderNo)"
    }
    
    fileprivate func repriceAll(_ total: Double) {
        guard let orderInventory = orderInventory else {
            return
        }
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0 ) > 0 {
            setPrice(quantity: total, item: line as AnyObject)
        }
    }
    
    fileprivate func repriceMix(mixDesc: String, quantityDelta: Double) {
        guard let orderInventory = orderInventory else {
            return
        }
        guard let mixItem = mixPriceDict[mixDesc] else {
            mixPriceDict[mixDesc] = quantityDelta
            return
        }
        let total = mixItem + quantityDelta
        mixPriceDict[mixDesc] = total
        let totalRounded = total.roundedCases()
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0 ) > 0 && ((line as? OrderInventory)?.mixDescription ?? "") == mixDesc {
            setPrice(quantity: totalRounded, item: line as AnyObject)
        }
    }
    
    func saveCurrentLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        savedDetailDict.removeAll()
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0 ) > 0 {
            guard let item = line as? AccountOrderInventory else {
                return
            }
            savedDetailDict[item.itemCode] = (bottles: item.bottleTotal, comment: nil)
        }
    }
    
    func loadSavedLines() {
        guard let orderInventory = orderInventory else {
            return
        }
        overSoldItems = ""
        deleteMobos()
        loadMoboList()
        loadMoboArray()
        for (item, detailTuple) in savedDetailDict {
            for line in orderInventory where (line as? AccountOrderInventory)?.itemCode == item {
                guard let line = line as? AccountOrderInventory else {
                    return
                }
                line.delegate = self
                line.orderType = self.orderType
                let bottles = detailTuple.bottles
                if isSaved && line.isOverSold(bottles){
                    (line.cases, line.bottles) = line.shipAvailable
                    overSoldItems = overSoldItems + item + ","
                } else {
                    (line.cases, line.bottles) = line.CasesBottlesFromTotal(bottles)
                }
            }
        }

    }
    
    func saveMoboList() {
        guard let orderInventory = orderInventory else {
            return
        }
        savedMoboDict.removeAll()
        for line in orderInventory where ((line as? AccountOrderInventory)?.moboListArray.count ?? 0) > 0 {
            guard let line = line as? AccountOrderInventory else {
                return
            }
            savedMoboDict[line.itemCode] = (list: line.moboString, bottles: line.moboTotal.quantity)
        }
    }
    
    func loadMoboList() {
        guard let orderMobos = orderMobos else {
            return
        }
        for (item, moboTuple) in savedMoboDict {
            var quantityDepleted : Int = 0
            let moboString = moboTuple.list
            let quantityBottles = moboTuple.bottles
            let moboArray = moboString.split{$0 == ","}.map { String($0) }
            for mobo in moboArray {
                
                for moboList in orderMobos where (moboList as? MoboList)?.itemCode == item  && (moboList as? MoboList)?.orderNo == mobo {
                    if quantityDepleted == quantityBottles {
                        break
                    }
                    guard let moboList = moboList as? MoboList else {
                        return
                    }
                    moboList.delegate = self
                    let quantityDelta = quantityBottles - quantityDepleted
                    let amountToDeplete = moboList.moboBottleTotal >= quantityDelta ? quantityDelta : moboList.moboBottleTotal
                    moboList.depleteBottles(amountToDeplete)
                    quantityDepleted += amountToDeplete
                }
                if quantityDepleted == quantityBottles {
                    break
                }
            }
        }
    }
    
    func loadMoboArray() {
        guard let orderMobos = orderMobos else {
            return
        }
        guard let orderInventory = orderInventory else {
            return
        }
        for moboList in orderMobos where ((moboList as? MoboList)?.orderBottleTotal ?? 0) > 0 {
            guard let moboList = moboList as? MoboList else {
                return
            }
            for line in orderInventory where (line as? AccountOrderInventory)?.itemCode == moboList.itemCode {
                guard let inventory = line as? AccountOrderInventory else {
                    return
                }
                inventory.loadMoboArray(moboList: moboList)
            }
        }
    }
    
    func loadSavedOrder(queryHeaderResult: FMResultSet?, detailDict: DetailDictType, moboDict: MoboDictType) {
        isSaved = true
        if let orderNo = queryHeaderResult?.int(forColumn: "order_no") {
            self.orderNo = Int(orderNo)
        }
        if let orderTypeRaw = queryHeaderResult?.string(forColumn: "type"),
            let orderType = OrderType(rawValue: orderTypeRaw) {
            self.orderType = orderType
        }
        if let shipDate = queryHeaderResult?.string(forColumn: "ship_date"),
            let nextShipDate = self.orderType.shipDate(account: account) {
            self.shipDate = shipDate < nextShipDate ? nextShipDate : shipDate
        }
        if let address = queryHeaderResult?.string(forColumn: "ship_to") {
            let addressIndex = shipToList?.index{$0.code == address} ?? 0
            self.shipTo = shipToList?[addressIndex]
        }
        notes = queryHeaderResult?.string(forColumn: "notes") 
        coopCases = Int(queryHeaderResult?.int(forColumn: "coop_qty") ?? 0)
        if let coopNo = queryHeaderResult?.string(forColumn: "coop_no") {
            if coopNo.count > 0 {
                self.coopNo = coopNo
            }
        }
        poNo = queryHeaderResult?.string(forColumn: "po_no")
        self.savedDetailDict = detailDict
        self.savedMoboDict = moboDict
    }
    
    func updateOrderMobo(moboList: MoboList) {
        guard let orderInventory = orderInventory else {
            return
        }
        for line in orderInventory where (line as? AccountOrderInventory)?.itemCode == moboList.itemCode {
            guard let inventory = line as? AccountOrderInventory else {
                return
            }
            inventory.orderType = orderType
            inventory.delegate = self
            inventory.updateMoboArray(moboList: moboList)
        }
    }
    
    var getDbHeaderInsert: String {
        let saveTime = Date().getDateTimeString()
        guard let divisionNo = account?.divisionNo,
            let customerNo = account?.customerNoRaw else {
                return ""
        }
        let notes = (self.notes ?? "").replacingOccurrences(of: "'", with: "''")
        let columns = "(TYPE, DIVISION_NO, CUSTOMER_NO, SAVE_TIME, SHIP_DATE, NOTES, COOP_QTY, COOP_NO, TOTAL_QTY, TOTAL_PRICE, PO_NO, SHIP_TO) "
        let orderType = self.orderType.rawValue
        let shipDate = self.shipDate ?? ""
        let coopCases = "\(self.coopCases ?? 0)"
        let coopNo = self.coopNo ?? ""
        let poNo = self.poNo ?? ""
        let shipTo = self.shipTo?.code ?? ""
        let values =  "VALUES ('" + orderType + "', '" + divisionNo + "', '" + customerNo + "', '" + saveTime + "', '" + shipDate + "', '" + notes + "', '" + coopCases + "', '" + coopNo + "', \(orderTotal), \(priceTotal), '" + poNo + "', '" + shipTo + "')"
        return columns + values
    }
    
    func getDbDetailInsert(orderNo: Int?) -> String? {
        var details : String = ""
        guard let orderInventory = orderInventory,
            let orderNo = orderNo else {
            return nil
        }
        for line in orderInventory where ((line as? OrderInventory)?.bottleTotal ?? 0) > 0 {
            guard let inventory = line as? OrderInventory else {
                return nil
            }
            details = details + inventory.getDbDetailInsert(orderNo) + ","
        }
        guard details.count > 0 else {
            return nil
        }
        return String(details[details.startIndex..<details.index(details.startIndex, offsetBy: details.count - 1)])
    }
    
    func getDbHeaderUpdate() ->  String? {
        guard let orderNo = orderNo else {
            return nil
        }
        let notes = (self.notes ?? "").replacingOccurrences(of: "'", with: "''")
        let saveTime = Date().getDateTimeString()
        let orderType = self.orderType.rawValue
        let shipDate = self.shipDate ?? ""
        let coopCases = "\(self.coopCases ?? 0)"
        let coopNo = self.coopNo ?? ""
        let shipTo = self.shipTo?.code ?? ""
        return "TYPE='" + orderType + "', SAVE_TIME='" + saveTime + "', SHIP_DATE='" + shipDate + "', NOTES='" + notes + "', COOP_QTY='" + coopCases + "', COOP_NO='" + coopNo + "', TOTAL_QTY=\(orderTotal), TOTAL_PRICE=\(priceTotal), PO_NO='" + (poNo ?? "") + "', SHIP_TO='" + shipTo + "' WHERE ORDER_NO=\(orderNo)"
    }
    
    func saveOrder() throws {
        do {
            var orderSavedService = OrderSavedService<AccountOrder>(order: self)
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
            let orderSavedService = OrderSavedService<AccountOrder>(order: self)
            try orderSavedService.deleteOrder()
        } catch {
            throw ErrorCode.dbError
        }
    }
    
    func getTransmitData() -> Data? {
        guard let orderInventory = orderInventory else {
            return nil
        }
        var orderDict = [String : Any]()
        var detailArray = [[String : Any]]()
        let notes = (self.notes ?? "").replacingOccurrences(of: "'", with: "")
        orderDict["custNo"] = account?.customerNoRaw ?? ""
        orderDict["type"] = orderType.rawValue
        orderDict["date"] = shipDate ?? ""
        orderDict["note"] = notes 
        orderDict["coop"] = coopNo ?? ""
        orderDict["po"] = poNo ?? ""
        orderDict["shipTo"] = shipTo?.code ?? ""
        orderDict["id"] = orderId ?? ""
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0) > 0 {
            guard let line = line as? AccountOrderInventory else {
                continue
            }
            var detailDict = [String : Any]()
            detailDict["item"] = line.itemCode
            detailDict["price"] = line.unitPrice
            detailDict["mobos"] = line.moboString
            detailDict["moboqty"] = line.moboTotal.quantity
            detailDict["qty"] = line.bottleTotal
            detailDict["over"] = line.isPriceOverride ? 1 : 0
            detailArray.append(detailDict)
        }
        orderDict["details"] = detailArray
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: orderDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
}
