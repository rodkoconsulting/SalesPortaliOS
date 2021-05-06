//
//  Order.swift
//  SalesPortal
//
//  Created by administrator on 2/7/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

protocol isOrderType : class {
    var orderNo: Int? { get set }
    var shipDate: String? { get set }
    var shipToList: [isOrderAddress]? { get }
    var shipTo: isOrderAddress? { get set }
    var minShipDate: String? { get set }
    var notes: String? { get set }
    var isSaved: Bool { get set }
    var account: Account? { get }
    var orderType: OrderType { get set }
    var getDbHeaderInsert: String { get }
    var orderInventory: NSMutableArray? { get set }
    var searchData: [[String : String]] { get set }
    var overSoldItems: String { get set }
    var orderTotal: Double { get set }
    func saveOrder() throws
    func deleteOrder() throws
    func getDbDetailInsert(orderNo: Int?) -> String?
    func getDbHeaderUpdate() -> String?
    func loadSavedLines()
    func getTransmitData() -> Data?
    func loadSavedOrder(queryHeaderResult: FMResultSet?, detailDict: DetailDictType, moboDict: MoboDictType)
}
