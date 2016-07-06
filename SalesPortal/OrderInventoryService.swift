

import Foundation


class OrderInventoryService: SyncService, SyncServiceType {
    typealias poDictType = [(onPo: Double, poEta: String, poDate: String)]
    let date: String
    let account: Account
    
    init(module: Module, apiCredentials: [String : String], date: String, account: Account) {
        self.date = date
        self.account = account
        super.init(module: module, apiCredentials: apiCredentials)
    }
    
    lazy var queryDb: (gridData:NSMutableArray?, searchData: [[String : AnyObject]]?) = {
        [unowned self] in
        let dB = FMDatabase(path: Constants.databasePath)
        let orderInventoryList = NSMutableArray()
        var inventorySearch = [[String : AnyObject]]()
        var poList: [InventoryPo] = []
        var poDict: [String:poDictType]
        //let state = repState.characters.last!
        if dB.open() {
            let poQuery = "SELECT ITEM_CODE, ON_PO, PO_NO, PO_ETA, PO_DATE FROM INV_PO ORDER BY ITEM_CODE, PO_ETA, PO_DATE"
            let poResults:FMResultSet? = dB.executeQuery(poQuery, withArgumentsInArray: nil)
            while poResults?.next() == true {
                let purchaseOrder = InventoryPo(queryResult: poResults!)
                poList.append(purchaseOrder)
            }
            dB.close()
        }
        poDict = self.poListToDict(poList)
        if dB.open() {
            let sqlQuery = "WITH INVOICES AS (" +
                "SELECT d.ITEM_CODE, h.INVOICE_DATE, d.Price, SUM(d.QUANTITY) AS QUANTITY FROM ACCOUNTS_INV_HEAD h INNER JOIN ACCOUNTS_INV_DET d ON h.INVOICE_NO = d.INVOICE_NO and h.HEADER_SEQ_NO = d.HEADER_SEQ_NO WHERE h.DIVISION_NO = '\(self.account.divisionNo)' and h.CUSTOMER_NO = '\(self.account.customerNoRaw)'" +
                "GROUP BY h.INVOICE_DATE, d.ITEM_CODE " +
                "HAVING SUM(d.QUANTITY) > 0" +
                "), ITEMS AS (" +
                "SELECT ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER FROM INV_DESC " +
                "UNION " +
                "SELECT ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER FROM ACCOUNTS_ITEMS_INACTIVE " +
                "WHERE ITEM_CODE IN (SELECT DISTINCT ITEM_CODE FROM INVOICES)" +
                ") " +
                "SELECT DISTINCT d.ITEM_CODE, i.QUANTITY AS 'LAST_QTY', i.INVOICE_DATE AS 'LAST_DATE', i.Price as 'LAST_PRICE', QTY_AVAIL, QTY_OH, ON_SO, ON_MO, ON_BO, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER, PRICE_DESC FROM ITEMS d LEFT OUTER JOIN  INV_QTY q ON q.ITEM_CODE = d.ITEM_CODE LEFT OUTER JOIN INV_PRICE p ON p.ITEM_CODE = d.ITEM_CODE LEFT OUTER JOIN INVOICES i ON i.ITEM_CODE = d.ITEM_CODE WHERE (p.PRICE_LEVEL = '\(self.account.priceLevel.rawValue)' OR p.PRICE_LEVEL ISNULL) AND (p.DATE ISNULL or p.DATE = (SELECT DATE FROM INV_PRICE AS p2 WHERE p2.ITEM_CODE = p.ITEM_CODE and p2.PRICE_LEVEL = p.PRICE_LEVEL AND p2.DATE <= '\(self.date)' ORDER BY DATE DESC LIMIT 1)) AND (i.INVOICE_DATE ISNULL OR i.INVOICE_DATE = (SELECT INVOICE_DATE FROM INVOICES AS i2 WHERE i2.ITEM_CODE = i.ITEM_CODE ORDER BY INVOICE_DATE DESC LIMIT 1)) ORDER BY BRAND, DESC"
            //let sqlQuery = "SELECT q.ITEM_CODE, DATE, QTY_AVAIL, QTY_OH, ON_SO, ON_MO, ON_BO, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER, PRICE_DESC FROM INV_QTY q INNER JOIN INV_DESC d ON q.ITEM_CODE = d.ITEM_CODE INNER JOIN INV_PRICE p ON p.ITEM_CODE = q.ITEM_CODE WHERE p.PRICE_LEVEL = '\(self.state.rawValue)'  AND p.DATE = (SELECT DATE FROM INV_PRICE AS p2 WHERE p2.ITEM_CODE = p.ITEM_CODE and p2.PRICE_LEVEL = p.PRICE_LEVEL AND p2.DATE <= '\(self.date)' ORDER BY DATE DESC LIMIT 1) ORDER BY BRAND, DESC"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsInArray: nil)
            while results?.next() == true {
                let orderInventory = OrderInventory(queryResult: results!, poDict: poDict)
                let inventoryDict = ["DisplayText":orderInventory.itemDescription, "DisplaySubText": orderInventory.itemCode]
                orderInventoryList.addObject(orderInventory)
                inventorySearch.append(inventoryDict)
            }
            dB.close()
        }
        return orderInventoryList.count > 0 ? (orderInventoryList, inventorySearch) : (nil, nil)

        }()
    
    func poListToDict(poList: [InventoryPo]) -> [String: poDictType] {
        var previousItem = ""
        var poDict = [String:poDictType]()
        for po in poList {
            if po.itemCode != previousItem {
                poDict[po.itemCode] = [(po.onPo, po.poEta, po.poDate)]
            } else {
                poDict[po.itemCode]! += [(po.onPo, po.poEta, po.poDate)]
            }
            previousItem = po.itemCode
        }
        return poDict
    }
    
    
    
    func getApi(timeSyncDict: [String : String], completion: (data: InvSync?, error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiInv(timeSyncDict, credentialDict: self.apiCredentials){
            (let apiDict, errorCode) in
            guard let inventoryDict = apiDict,
                let qtyDict = inventoryDict["Qty"] as? [String : AnyObject],
                let descDict = inventoryDict["Desc"] as? [String : AnyObject],
                let priceDict = inventoryDict["Price"] as? [String : AnyObject],
                let poDict = inventoryDict["Po"] as? [String : AnyObject]
                else {
                    completion(data: nil, error: errorCode)
                    return
            }
            completion(data: InvSync(qtyDict: qtyDict, descDict: descDict, priceDict: priceDict, poDict: poDict), error: nil)
        }
    }
    
    
    func updateDb(invSync: InvSync) throws {
        let inventoryQtyService = DatabaseService(tableName: DatabaseTable.InventoryQuantity)
        let inventoryDescService = DatabaseService(tableName: DatabaseTable.InventoryDesc)
        let inventoryPriceService = DatabaseService(tableName: DatabaseTable.InventoryPrice)
        let inventoryPoService = DatabaseService(tableName: DatabaseTable.InventoryPo)
        
        do {
            try inventoryQtyService.updateDb(invSync.qtySync)
            try inventoryDescService.updateDb(invSync.descSync)
            try inventoryPriceService.updateDb(invSync.priceSync)
            try inventoryPoService.updateDb(invSync.poSync)
        } catch ErrorCode.ServerError {
            throw ErrorCode.ServerError
        } catch {
            throw ErrorCode.DbError
        }
    }
}


