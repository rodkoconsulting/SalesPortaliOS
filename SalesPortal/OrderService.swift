//
//  OrderService .swift
//  SalesPortal
//
//  Created by administrator on 7/19/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

struct OrderService {
    
    typealias JSONPostCompletion = (_ success: Bool, _ error: ErrorCode?) -> Void

    let order: isOrderType
    let apiCredentials: [String : String]?
    let dB : FMDatabase
    
    init(order: isOrderType, apiCredentials: [String : String]? = nil) {
        self.order = order
        self.apiCredentials = apiCredentials
        self.dB = FMDatabase(path: Constants.databasePath as String)
    }
    
    func sendOrder(_ completion: @escaping (JSONPostCompletion) ){
        let apiService = ApiService(apiString: order.orderType.apiString)
        guard let jsonData = order.getTransmitData(),
            let credentials = apiCredentials else {
            completion(false, ErrorCode.dbError)
                    return
        }
        apiService.sendApiOrder(jsonData, credentialDict: credentials){
            (success, errorCode) in
            completion(success, errorCode)
        }
    }
    
    func depleteDb() {
        depleteTransmitOrders()
        depleteTransmitInventory()
    }
    
    func depleteTransmitOrders() {
        guard let accountOrder = order as? AccountOrder, let orderInventory = accountOrder.orderInventory else {
            return
        }
        for line in orderInventory where ((line as? AccountOrderInventory)?.bottleTotal ?? 0) > 0 {
            guard let item = line as? AccountOrderInventory else {
                return
            }
            for mobo in item.moboListArray where mobo.orderBottleTotal > 0 {
                let quantityOnMo = mobo.quantity - Double(mobo.orderBottleTotal) / Double(item.uomInt)
                updateDbMo(mobo.orderNo, itemCode: item.itemCode, quantity: quantityOnMo)
            }
        }
    }
    
    func depleteTransmitInventory() {
        guard let orderInventory = order.orderInventory else {
            return
        }
        for line in orderInventory where ((line as? OrderInventory)?.bottleTotal ?? 0) > 0 {
            guard let item = line as? OrderInventory else {
                return
            }
            var moboTotal = 0
            if let accountItem = line as? AccountOrderInventory {
                moboTotal = accountItem.moboTotal.quantity
            }
            let transmittedBottles = item.bottleTotal - moboTotal
            if transmittedBottles > 0 {
                let quantityAvailable = order.orderType == .Standard || order.orderType == .Master || order.orderType == .Sample || order.orderType == .BillHoldInvoice ? Double(Int((item.quantityAvailable * Double(item.uomInt)).roundedBottles()) - transmittedBottles) / Double(item.uomInt) : item.quantityAvailable
                let quantityOnSo = order.orderType == .Standard || order.orderType == .BillHoldInvoice  ? Double(Int((item.onSo * Double(item.uomInt)).roundedBottles()) + transmittedBottles) / Double(item.uomInt) : item.onSo
                let quantityOnMo = order.orderType == .Master ? Double(Int((item.onMo * Double(item.uomInt)).roundedBottles()) + transmittedBottles) / Double(item.uomInt) : item.onMo
                let quantityOnBo = order.orderType == .Back ? Double(Int((item.onBo * Double(item.uomInt)).roundedBottles()) + transmittedBottles) / Double(item.uomInt) : item.onBo
                updateDbInventory(item.itemCode, quantityAvailable: quantityAvailable, quantityOnSo: quantityOnSo, quantityOnMo: quantityOnMo, quantityOnBo: quantityOnBo)
            }
        }
    }
    
    func updateDbMo(_ orderNo: String, itemCode: String, quantity: Double) {
        guard let dB = FMDatabase(path: Constants.databasePath as String) else {
            return
        }
        guard dB.open() else {
            return
        }
        let sqlUpdateInventory = "UPDATE ORDER_LIST_DETAIL SET QTY=\(quantity) WHERE ITEM_CODE='\(itemCode)' AND ORDER_NO='\(orderNo)'"
        dB.executeUpdate(sqlUpdateInventory, withArgumentsIn: nil)
    }
    
    func updateDbInventory(_ itemCode: String, quantityAvailable: Double, quantityOnSo: Double, quantityOnMo: Double, quantityOnBo: Double) {
        guard let dB = FMDatabase(path: Constants.databasePath as String) else {
            return
        }
        guard dB.open() else {
            return
        }
        let sqlUpdateInventory = "UPDATE INV_QTY SET QTY_AVAIL=\(quantityAvailable), ON_SO=\(quantityOnSo), ON_MO=\(quantityOnMo), ON_BO=\(quantityOnBo) WHERE ITEM_CODE='\(itemCode)'"
        dB.executeUpdate(sqlUpdateInventory, withArgumentsIn: nil)
    }
    
    }
