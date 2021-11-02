//
//  AccountService.swift
//  SalesPortal
//
//  Created by administrator on 5/23/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation

class SampleListService: SyncService, SyncServiceType {

    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let sampleListArray = NSMutableArray()
        var sampleListSearch = [[String : String]]()
        var isMultipleReps = false
        var previousRep : String = ""
        if dB.open() {
            let sqlQuery =
                "WITH ITEMS AS (" +
                "SELECT ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, FOCUS, COUNTRY, REGION, APPELLATION FROM INV_DESC " +
                "UNION " +
                "SELECT ITEM_CODE, DESC, BRAND, MASTER_VENDOR, VINTAGE, UOM, SIZE, DAMAGED_NOTES, FOCUS, COUNTRY, REGION, APPELLATION FROM SAMPLE_ITEMS_INACTIVE " +
                "WHERE ITEM_CODE IN (SELECT DISTINCT ITEM_CODE FROM SAMPLE_LIST_DETAIL)" +
                ") " +
                "SELECT h.ORDER_NO, h.SHIP_DATE, h.REP, h.IS_POSTED, " +
                "d.ITEM_CODE, d.QTY, d.COMMENT, " +
                "a.NAME, " +
                "i.DESC, i.BRAND, i.MASTER_VENDOR, i.VINTAGE, i.UOM, i.SIZE, i.DAMAGED_NOTES, i.FOCUS, i.COUNTRY, i.REGION, i.APPELLATION " +
                "FROM SAMPLE_LIST_HEADER h " +
                "INNER JOIN SAMPLE_LIST_DETAIL d ON h.ORDER_NO = d.ORDER_NO " +
                "INNER JOIN SAMPLE_ADDRESSES a " +
                "ON h.SHIP_TO = a.CODE " +
                "LEFT OUTER JOIN ITEMS i " +
                "ON d.ITEM_CODE = i.ITEM_CODE " +
                "ORDER BY h.REP, h.SHIP_DATE desc, h.ORDER_NO, i.BRAND, i.DESC"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let sampleList = SampleList(queryResult: results!)
                if !isMultipleReps {
                    if previousRep.count > 0 && previousRep != sampleList.rep {
                        isMultipleReps = true
                    } else
                    {
                        previousRep = sampleList.rep
                    }
                }
                if let itemDescription = sampleList.itemDescription {
                    let itemListDict = ["DisplayText": itemDescription, "DisplaySubText": sampleList.itemCode]
                    if !sampleListSearch.contains(where: {$0 == itemListDict}) {
                        sampleListSearch.append(itemListDict)
                    }
                }
                sampleListArray.add(sampleList)
            }
            dB.close()
        }
        return sampleListArray.count > 0 ? (sampleListArray, sampleListSearch, isMultipleReps) : (nil, nil, false)
    }
    
    func getApi(_ timeSyncDict: [String : String], completion: @escaping (_ data: SampleListSync?, _ error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiSamples(timeSyncDict, credentialDict: self.apiCredentials){
            (apiDict, errorCode) in
            guard let sampleListDict = apiDict,
                let sampleHeaderDict = sampleListDict["H"] as? [String : AnyObject],
                let sampleDetailDict = sampleListDict["D"] as? [String : AnyObject],
                let sampleAddressDict = sampleListDict["A"] as? [String : AnyObject],
                let sampleItemsInactiveDict = sampleListDict["I"] as? [String : AnyObject]
                else {
                    completion(nil, errorCode)
                    return
            }
            completion(SampleListSync(sampleHeaderDict: sampleHeaderDict, sampleDetailDict: sampleDetailDict, sampleAddressDict: sampleAddressDict, sampleItemsInactiveDict: sampleItemsInactiveDict), nil)
        }
    }
    
    func updateDb(_ sampleListSync: SampleListSync) throws {
        let sampleHeaderService = DatabaseService(tableName: DatabaseTable.SampleListHeader)
        let sampleDetailService = DatabaseService(tableName: DatabaseTable.SampleListDetail)
        let sampleAddressService = DatabaseService(tableName: DatabaseTable.SampleAddress)
        let sampleItemsInactiveService = DatabaseService(tableName: DatabaseTable.SampleItemsInactive)
        do {
            try sampleHeaderService.updateDb(sampleListSync.sampleHeaderSync)
            try sampleDetailService.updateDb(sampleListSync.sampleDetailSync)
            try sampleAddressService.updateDb(sampleListSync.sampleAddressSync)
            try sampleItemsInactiveService.updateDb(sampleListSync.sampleItemsInactiveSync)
        } catch ErrorCode.serverError {
            throw ErrorCode.serverError
        } catch {
            throw ErrorCode.dbError
        }
    }
    
}


