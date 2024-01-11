
import Foundation

class OrderListService: SyncService, SyncServiceType {
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let orderListArray = NSMutableArray()
        var orderListSearch = [[String : String]]()
        var isMultipleReps = false
        var previousRep : String = ""
        if dB.open() {
            let sqlQuery =
            "SELECT hoi.ORDER_NO, a.CUSTOMER_NAME, hoi.CUSTOMER_NO, a.AFFIL, hoi.ORDER_DATE, hoi.SHIP_DATE, hoi.ARR_DATE, hoi.PO_ETA, hoi.STATUS, hoi.HOLD, hoi.COOP, " +
            "hoi.COMMENT, hoi.SHIP_TO, hoi.ITEM_CODE, " +
            "i.DESC, i.BRAND, i.VINTAGE, i.UOM, i.SIZE, i.DAMAGED_NOTES, i.RESTRICT_ALLOCATED, " +
            "hoi.QTY, hoi.PRICE, hoi.TOTAL, " +
            "a.REP, a.REGION " +
            "FROM (" +
            "SELECT DISTINCT h.DIVISION_NO, h.CUSTOMER_NO, h.ORDER_NO, h.ORDER_DATE, h.SHIP_DATE, h.ARR_DATE, p.PO_ETA, h.STATUS, h.HOLD, h.COOP, h.COMMENT, h.SHIP_TO, " +
            "d.ITEM_CODE, d.LINE_NO, d.QTY, d.PRICE, d.TOTAL, d.COMMENT AS LINE_COMMENT " +
            "FROM ORDER_LIST_HEADER h " +
            "INNER JOIN ORDER_LIST_DETAIL d ON h.ORDER_NO = d.ORDER_NO " +
            "LEFT OUTER JOIN INV_PO p ON d.ITEM_CODE = p.ITEM_CODE " +
            "WHERE (p.PO_ETA ISNULL or p.PO_ETA = (SELECT PO_ETA FROM INV_PO AS p2 WHERE p2.ITEM_CODE = p.ITEM_CODE ORDER BY PO_ETA LIMIT 1)) " +
            ") hoi " +
            "LEFT OUTER JOIN " +
            "(" +
            "SELECT DIVISION_NO, CUSTOMER_NO, REGION, REP, CUSTOMER_NAME, AFFIL FROM ACCOUNTS_LIST " +
            "UNION ALL " +
            "SELECT '00', CODE, REGION, REP, NAME, '' FROM SAMPLE_ADDRESSES " +
            ") a " +
            "ON hoi.DIVISION_NO = a.DIVISION_NO AND hoi.CUSTOMER_NO = a.CUSTOMER_NO " +
            "LEFT OUTER JOIN " +
            "(" +
            "SELECT ITEM_CODE, DESC, BRAND, VINTAGE, UOM, SIZE, DAMAGED_NOTES, RESTRICT_ALLOCATED FROM INV_DESC " +
            "UNION " +
            "SELECT ITEM_CODE, DESC, BRAND, VINTAGE, UOM, SIZE, DAMAGED_NOTES, RESTRICT_ALLOCATED FROM ACCOUNTS_ITEMS_INACTIVE " +
            ") i " +
            "ON hoi.ITEM_CODE = i.ITEM_CODE " +
            "ORDER BY a.REGION, a.REP, a.CUSTOMER_NAME, hoi.ORDER_DATE desc"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let orderList = OrderList(queryResult: results!)
                if !isMultipleReps {
                    if previousRep.count > 0 && previousRep != orderList.rep {
                        isMultipleReps = true
                    } else
                    {
                        previousRep = orderList.rep
                    }
                }
                let customerListDict = ["DisplayText": orderList.customerName, "DisplaySubText": orderList.customerNo]
                if !orderListSearch.contains(where: {$0 == customerListDict}) {
                    orderListSearch.append(customerListDict)
                }
                if let itemDescription = orderList.itemDescription {
                    let itemListDict = ["DisplayText": itemDescription, "DisplaySubText": orderList.itemCode]
                    if !orderListSearch.contains(where: {$0 == itemListDict}) {
                        orderListSearch.append(itemListDict)
                    }
                }
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


