
import Foundation
    
    class HolidayDates: SyncRows {
        let dateString: String?
        
        required init(dict: [String: Any]?)
        {
            dateString = dict?["Date"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
                guard let dateString = self.dateString else {
                    return nil
                }
                return "DATE='" + dateString + "'"
        }()
        
        lazy var getDbInsert: String? = {
            [unowned self] in
                guard let dateString = self.dateString else {
                        return nil
                }
                return "('" + dateString + "')"
        }()
    }
    
struct HolidayListSync {
    let dateSync: Sync<HolidayDates>
    
    init(dateDict: [String : Any]) {
        dateSync = Sync<HolidayDates>(dict: dateDict)
    }
}

class HolidayList {
    let dateString: String
    
    init(queryResult: FMResultSet) {
        dateString = queryResult.string(forColumn: "date")
    }
    
    lazy var holidayDate : Date? = {
        [unowned self] in
        return self.dateString.getShipDate()
    }()
}

