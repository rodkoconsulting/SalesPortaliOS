    //
    //  Inventory.swift
    //  StormyNew
    //
    //  Created by administrator on 7/2/15.
    //  Copyright (c) 2015 Polaner Selections. All rights reserved.
    //
    
    import Foundation
    
    enum ShipDays: Int {
        case Monday = 1
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
    }
    
    enum States: String {
        case NY = "Y"
        case NJ = "J"
    }
    
    class AccountList: SyncRows {
        let division: String?
        let customerNo: String?
        let customerName: String?
        let shipDays: String?
        let priceLevel: String?
        
        required init(dict: [String: AnyObject]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            customerName = dict?["CustName"] as? String
            shipDays = dict?["Days"] as? String
            priceLevel = dict?["Price"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
            guard let division = self.division,
                let customerNo = self.customerNo else {
                return nil
            }
            return "DIVISION_NO='\(division)' and CUSTOMER_NO='\(customerNo)'"
            }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let division = self.division,
                let customerNo = self.customerNo,
                let customerName = self.customerName,
                let shipDays = self.shipDays,
                let priceLevel = self.priceLevel else {
                    return nil
            }
            return "(DIVISION_NO, CUSTOMER_NO, CUSTOMER_NAME, SHIP_DAYS, PRICE_LEVEL) VALUES ('\(division)', \(customerNo), \(customerName), \(shipDays), \(priceLevel))"
            }()

    }
    
    
    struct AccountSync {
        let listSync: Sync<AccountList>
        
        init(listDict: [String : AnyObject]) {
            listSync = Sync<AccountList>(dict: listDict)
        }
    }
    
    class Account : NSObject {
        
        let divisionNo: String
        let customerNoRaw: String
        let shipDaysRaw: String
        let customerName: String
        let priceLevelRaw: String
        
        
        init(queryResult: FMResultSet?) {
            divisionNo = queryResult?.stringForColumn("division") ?? ""
            customerNoRaw = queryResult?.stringForColumn("customer_no") ?? ""
            shipDaysRaw = queryResult?.stringForColumn("ship_days") ?? ""
            customerName = queryResult?.stringForColumn("customer_name") ?? ""
            priceLevelRaw = queryResult?.stringForColumn("price_level") ?? ""
        }
        
        lazy var customerNo : String = {
            [unowned self]  in
                return "\(self.divisionNo)\(self.customerNoRaw)"
        }()
        
        lazy var shipDays : [ShipDays] = {
            [unowned self] in
            var shipDayArray: [ShipDays] = [ShipDays]()
            for (index, day) in self.shipDaysRaw.characters.enumerate() {
                if let shipDay = ShipDays(rawValue: index) where day == "Y" {
                    shipDayArray.append(shipDay)
                }
            }
            return shipDayArray
        }()
        
        lazy var priceLevel: States = {
            [unowned self] in
            return States(rawValue: self.priceLevelRaw) ?? States.NY
        }()
        
    }
