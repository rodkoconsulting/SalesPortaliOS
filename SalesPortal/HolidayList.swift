
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

struct Holidays {
    
    let storageName: String
    
    init() {
        self.storageName = "Holidays"
    }
    
    func getHolidays() -> [Date]? {
        guard let holidays = Locksmith.loadDataForUserAccount(userAccount: storageName) as? [String: [Date]] else {
            return nil
        }
        return holidays[storageName]
    }
    
    func saveHolidays(_ holidayList: NSMutableArray) {
        let holidayArray = holidayList as NSArray as? [Date]
        let dict = [storageName : holidayArray]
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: storageName)
        } catch {
            
        }
        try! Locksmith.saveData(data: dict as [String : Any], forUserAccount: storageName)
    }
}

