

import Foundation


class SampleOrderInventoryService: SyncService, OrderSyncServiceType {
    typealias poDictType = [(onPo: Double, poEta: String, poDate: String, poComment: String)]
    let date: String
    
    init(module: Module, apiCredentials: [String : String], date: String) {
        self.date = date
        super.init(module: module, apiCredentials: apiCredentials)
    }
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let state = apiCredentials["state"] ?? "Y"
        let sampleOrderInventoryList = NSMutableArray()
        var inventorySearch = [[String : String]]()
        var poList: [InventoryPo] = []
        var poDict: [String:poDictType]
        if dB.open() {
            let poQuery = "SELECT ITEM_CODE, ON_PO, PO_NO, PO_ETA, PO_DATE, PO_CMT FROM INV_PO ORDER BY ITEM_CODE, PO_ETA, PO_DATE"
            let poResults:FMResultSet? = dB.executeQuery(poQuery, withArgumentsIn: nil)
            while poResults?.next() == true {
                let purchaseOrder = InventoryPo(queryResult: poResults!)
                poList.append(purchaseOrder)
            }
            dB.close()
        }
        poDict = self.poListToDict(poList)
        if dB.open() {
            let sqlQuery = "WITH ORDERS AS (" +
                "SELECT h.SHIP_DATE, " +
                "d.ITEM_CODE, d.QTY " +
                "FROM SAMPLE_LIST_HEADER h " +
                "INNER JOIN SAMPLE_LIST_DETAIL d ON h.ORDER_NO = d.ORDER_NO " +
                "INNER JOIN SAMPLE_ADDRESSES a " +
                "ON h.SHIP_TO = a.CODE " +
                "WHERE a.IS_REP = 'true'" +
                "), ITEMS AS (" +
                "SELECT ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER, RECEIPT_DATE, REGEN, NAT, VEGAN, HVE FROM INV_DESC " +
                "UNION " +
                "SELECT ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, '', '', '', '', '', FOCUS, COUNTRY, REGION, APPELLATION, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' FROM SAMPLE_ITEMS_INACTIVE " +
                "WHERE ITEM_CODE IN (SELECT DISTINCT ITEM_CODE FROM ORDERS)" +
                ") " +
                "SELECT DISTINCT i.ITEM_CODE, o.QTY AS 'LAST_QTY', o.SHIP_DATE AS 'LAST_DATE', QTY_AVAIL, QTY_OH, ON_SO, ON_MO, ON_BO, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER, RECEIPT_DATE, REGEN, NAT, VEGAN, HVE, PRICE_DESC FROM ITEMS i LEFT OUTER JOIN INV_QTY q ON q.ITEM_CODE = i.ITEM_CODE LEFT OUTER JOIN INV_PRICE p ON p.ITEM_CODE = i.ITEM_CODE LEFT OUTER JOIN ORDERS o ON o.ITEM_CODE = i.ITEM_CODE WHERE (p.PRICE_LEVEL = '" + state + "' OR p.PRICE_LEVEL ISNULL) AND (p.DATE ISNULL or p.DATE = (SELECT DATE FROM INV_PRICE AS p2 WHERE p2.ITEM_CODE = p.ITEM_CODE and p2.PRICE_LEVEL = p.PRICE_LEVEL AND p2.DATE <= '" + self.date + "' ORDER BY DATE DESC LIMIT 1)) AND (o.SHIP_DATE ISNULL OR o.SHIP_DATE = (SELECT SHIP_DATE FROM ORDERS AS o2 WHERE o2.ITEM_CODE = o.ITEM_CODE ORDER BY SHIP_DATE DESC LIMIT 1)) ORDER BY BRAND, DESC"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let sampleOrderInventory = SampleOrderInventory(queryResult: results!, poDict: poDict)
                let inventoryDict = ["DisplayText":sampleOrderInventory.itemDescription, "DisplaySubText": sampleOrderInventory.itemCode]
                sampleOrderInventoryList.add(sampleOrderInventory)
                inventorySearch.append(inventoryDict)
            }
            dB.close()
        }
        return sampleOrderInventoryList.count > 0 ? (sampleOrderInventoryList, inventorySearch, false) : (nil, nil, false)
    }
    
    func poListToDict(_ poList: [InventoryPo]) -> [String: poDictType] {
        var previousItem = ""
        var poDict = [String:poDictType]()
        for po in poList {
            if po.itemCode != previousItem {
                poDict[po.itemCode] = [(po.onPo, po.poEta, po.poDate, po.poComment)]
            } else {
                poDict[po.itemCode]! += [(po.onPo, po.poEta, po.poDate, po.poComment)]
            }
            previousItem = po.itemCode
        }
        return poDict
    }
    
    
    
    func getApi(_ timeSyncDict: [String : String], completion: @escaping (_ data: InvSync?, _ error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiInv(timeSyncDict, credentialDict: self.apiCredentials){
            (apiDict, errorCode) in
            guard let inventoryDict = apiDict,
                let qtyDict = inventoryDict["Qty"] as? [String : AnyObject],
                let descDict = inventoryDict["Desc"] as? [String : AnyObject],
                let priceDict = inventoryDict["Price"] as? [String : AnyObject],
                let poDict = inventoryDict["Po"] as? [String : AnyObject]
                else {
                    completion(nil, errorCode)
                    return
            }
            completion(InvSync(qtyDict: qtyDict, descDict: descDict, priceDict: priceDict, poDict: poDict), nil)
        }
    }
    
    
    func updateDb(_ invSync: InvSync) throws {
        let inventoryQtyService = DatabaseService(tableName: DatabaseTable.InventoryQuantity)
        let inventoryDescService = DatabaseService(tableName: DatabaseTable.InventoryDesc)
        let inventoryPriceService = DatabaseService(tableName: DatabaseTable.InventoryPrice)
        let inventoryPoService = DatabaseService(tableName: DatabaseTable.InventoryPo)
        
        do {
            try inventoryQtyService.updateDb(invSync.qtySync)
            try inventoryDescService.updateDb(invSync.descSync)
            try inventoryPriceService.updateDb(invSync.priceSync)
            try inventoryPoService.updateDb(invSync.poSync)
        } catch ErrorCode.serverError {
            throw ErrorCode.serverError
        } catch {
            throw ErrorCode.dbError
        }
    }
    
}


