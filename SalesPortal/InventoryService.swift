

import Foundation


class InventoryService: SyncService, SyncServiceType {
    typealias poDictType = [(onPo: Double, poEta: String, poDate: String)]
    let date: String
    
    init(module: Module, apiCredentials: [String : String], date: String) {
        self.date = date
        super.init(module: module, apiCredentials: apiCredentials)
    }
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let repState = self.apiCredentials["state"] else {
            return (nil, nil, false)
        }
        guard repState.characters.count > 0 else {
            return (nil, nil, false)
        }
        let dB = FMDatabase(path: Constants.databasePath)
        let inventoryList = NSMutableArray()
        var inventorySearch = [[String : String]]()
        var poList: [InventoryPo] = []
        var poDict: [String:poDictType]
        //let state = repState.characters.last!
        if dB.open() {
            let poQuery = "SELECT ITEM_CODE, ON_PO, PO_NO, PO_ETA, PO_DATE FROM INV_PO ORDER BY ITEM_CODE, PO_ETA, PO_DATE"
            let poResults:FMResultSet? = dB.executeQuery(poQuery, withArgumentsIn: nil)
            while poResults?.next() == true {
                let purchaseOrder = InventoryPo(queryResult: poResults!)
                poList.append(purchaseOrder)
            }
            dB.close()
        }
        poDict = self.poListToDict(poList)
        if dB.open() {
            let sqlQuery = "SELECT q.ITEM_CODE, DATE, QTY_AVAIL, QTY_OH, ON_SO, ON_MO, ON_BO, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, CLOSURE, TYPE, VARIETAL, ORGANIC, BIODYNAMIC, FOCUS, COUNTRY, REGION, APPELLATION, RESTRICT_OFFSALE, RESTRICT_OFFSALE_NOTES, RESTRICT_PREMISE, RESTRICT_ALLOCATED, RESTRICT_APPROVAL, RESTRICT_MAX, RESTRICT_STATE, RESTRICT_SAMPLE, RESTRICT_BO, RESTRICT_MO, UPC, SCORE_WA, SCORE_WS, SCORE_IWC, SCORE_BH, SCORE_VM, SCORE_OTHER, PRICE_DESC FROM INV_QTY q INNER JOIN INV_DESC d ON q.ITEM_CODE = d.ITEM_CODE INNER JOIN INV_PRICE p ON p.ITEM_CODE = q.ITEM_CODE WHERE p.PRICE_LEVEL = '" + repState + "' AND p.DATE = (SELECT DATE FROM INV_PRICE AS p2 WHERE p2.ITEM_CODE = p.ITEM_CODE and p2.PRICE_LEVEL = p.PRICE_LEVEL AND p2.DATE <= '" + self.date + "' ORDER BY DATE DESC LIMIT 1) ORDER BY BRAND, DESC"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let inventory = Inventory(queryResult: results!, poDict: poDict)
                let inventoryDict = ["DisplayText":inventory.itemDescription, "DisplaySubText": inventory.itemCode]
                inventoryList.add(inventory)
                inventorySearch.append(inventoryDict)
            }
            dB.close()
        }
        return inventoryList.count > 0 ? (inventoryList, inventorySearch, false) : (nil, nil, false)
    }
    
    func poListToDict(_ poList: [InventoryPo]) -> [String: poDictType] {
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
                    completion(data: nil, error: errorCode)
                    return
            }
            completion(data: InvSync(qtyDict: qtyDict, descDict: descDict, priceDict: priceDict, poDict: poDict), error: nil)
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


