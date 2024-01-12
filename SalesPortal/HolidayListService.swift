
import Foundation

class HolidayListService: SyncService, SyncServiceType {
    
    func queryDb() -> (gridData:NSMutableArray?, searchData: [[String : String]]?, isManager: Bool) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil, false)
        }
        let holidayListArray = NSMutableArray()
        if dB.open() {
            let sqlQuery = "SELECT DATE FROM HOLIDAYS_DATES"
            let results: FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let holiday = results!.string(forColumn: "date").getShipDate()
                holidayListArray.add(holiday as Any)
            }
            dB.close()
        }
        return holidayListArray.count > 0 ? (holidayListArray, nil, false) : (nil, nil, false)
    }
    
    func getApi(_ timeSyncDict: [String : String], completion: @escaping (_ data: HolidayListSync?, _ error: ErrorCode?) -> Void) {
        let apiService = ApiService(apiString: module.apiInit)
        apiService.getApiHolidays(timeSyncDict, credentialDict: self.apiCredentials){
            (apiDict, errorCode) in
            guard let holidayListDict = apiDict
                else {
                    completion(nil, errorCode)
                    return
                    }
        completion(HolidayListSync(dateDict: holidayListDict), nil)
        }
    }
    
    func updateDb(_ holidayListSync: HolidayListSync) throws {
        let holidayDatabaseService = DatabaseService(tableName: DatabaseTable.HolidayList)
        do {
            try holidayDatabaseService.updateDb(holidayListSync.dateSync)
        } catch ErrorCode.serverError {
            throw ErrorCode.serverError
        } catch {
            throw ErrorCode.dbError
        }
    }
}


