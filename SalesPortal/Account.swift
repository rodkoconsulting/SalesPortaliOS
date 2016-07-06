    //
    //  Inventory.swift
    //  StormyNew
    //
    //  Created by administrator on 7/2/15.
    //  Copyright (c) 2015 Polaner Selections. All rights reserved.
    //
    
    import Foundation
    
    enum ShipDays: Int {
        case Monday = 2
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
    }
    
    enum States: String {
        case NY = "Y"
        case NJ = "J"
    }
    
    class AccountInvoiceHeader: SyncRows {
        let division: String?
        let customerNo: String?
        let invoiceNo: String?
        let headerSeqNo: String?
        let invoiceType: String?
        let invoiceDate: String?
        
        required init(dict: [String: AnyObject]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            invoiceNo = dict?["InvNo"] as? String
            headerSeqNo = dict?["SeqNoH"] as? String
            invoiceType = dict?["Type"] as? String
            invoiceDate = dict?["Date"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo else {
                    return nil
            }
            return "INVOICE_NO='\(invoiceNo)' and HEADER_SEQ_NO='\(headerSeqNo)'"
            }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo,
                let division = self.division,
                let customerNo = self.customerNo,
                let invoiceType = self.invoiceType,
                let invoiceDate = self.invoiceDate else {
                    return nil
            }
            return "('\(invoiceNo)', '\(headerSeqNo)', '\(division)', '\(customerNo)', '\(invoiceType)', '\(invoiceDate)')"
            }()
    }
    
    class AccountInvoiceDetail: SyncRows {
        let invoiceNo: String?
        let headerSeqNo: String?
        let detailSeqNo: String?
        let itemCode: String?
        let quantity: Double?
        let unitPrice: Double?
        
        required init(dict: [String: AnyObject]?) {
            invoiceNo = dict?["InvNo"] as? String
            headerSeqNo = dict?["SeqNoH"] as? String
            detailSeqNo = dict?["SeqNoD"] as? String
            itemCode = dict?["Item"] as? String
            quantity = dict?["Qty"] as? Double
            unitPrice = dict?["Price"] as? Double
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo,
                let detailSeqNo = self.detailSeqNo else {
                    return nil
            }
            return "INVOICE_NO='\(invoiceNo)' and HEADER_SEQ_NO='\(headerSeqNo)' and DETAIL_SEQ_NO='\(detailSeqNo)'"
            }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo,
                let detailSeqNo = self.detailSeqNo,
                let itemCode = self.itemCode,
                let quantity = self.quantity,
                let unitPrice = self.unitPrice else {
                    return nil
            }
            return "('\(invoiceNo)', '\(headerSeqNo)', '\(detailSeqNo)', '\(itemCode)', \(quantity), \(unitPrice))"
            }()
    }
    
    class AccountItemsInactive: InvDesc {
        
    }
    
    class AccountList: SyncRows {
        let division: String?
        let customerNo: String?
        let customerName: String?
        let shipDays: String?
        let priceLevel: String?
        let coopList: String?
        
        required init(dict: [String: AnyObject]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            customerName = dict?["CustName"] as? String
            shipDays = dict?["Days"] as? String
            priceLevel = dict?["Price"] as? String
            coopList = dict?["Coop"] as? String
           
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
                let priceLevel = self.priceLevel,
                let coopList = self.coopList else {
                    return nil
            }
            return "('\(division)', '\(customerNo)', '\(customerName)', '\(shipDays)', '\(priceLevel)', '\(coopList)')"
            }()

    }
    
    
    struct AccountSync {
        let listSync: Sync<AccountList>
        let invoiceHeaderSync: Sync<AccountInvoiceHeader>
        let invoiceDetailSync: Sync<AccountInvoiceDetail>
        let itemsInactiveSync: Sync<AccountItemsInactive>
        
        init(listDict: [String : AnyObject], invoiceHeaderDict: [String : AnyObject], invoiceDetailDict: [String : AnyObject], itemsInactiveDict: [String : AnyObject]) {
            listSync = Sync<AccountList>(dict: listDict)
            invoiceHeaderSync = Sync<AccountInvoiceHeader>(dict: invoiceHeaderDict)
            invoiceDetailSync = Sync<AccountInvoiceDetail>(dict: invoiceDetailDict)
            itemsInactiveSync = Sync<AccountItemsInactive>(dict: itemsInactiveDict)
        }
    }
    
    class Account : NSObject {
        
        let divisionNo: String
        let customerNoRaw: String
        let shipDaysRaw: String
        let customerName: String
        let priceLevelRaw: String
        let coopString: String
        
        init(queryResult: FMResultSet?) {
            divisionNo = queryResult?.stringForColumn("division_no") ?? ""
            customerNoRaw = queryResult?.stringForColumn("customer_no") ?? ""
            shipDaysRaw = queryResult?.stringForColumn("ship_days") ?? ""
            customerName = queryResult?.stringForColumn("customer_name") ?? ""
            priceLevelRaw = queryResult?.stringForColumn("price_level") ?? ""
            coopString = queryResult?.stringForColumn("coop_list") ?? ""
        }
        
        lazy var customerNo : String = {
            [unowned self]  in
                return "\(self.divisionNo)\(self.customerNoRaw)"
        }()
        
        lazy var shipDays : [ShipDays] = {
            [unowned self] in
            var shipDayArray: [ShipDays] = [ShipDays]()
            for (index, day) in self.shipDaysRaw.characters.enumerate() {
                if let shipDay = ShipDays(rawValue: index + 2 ) where day == "Y" {
                    shipDayArray.append(shipDay)
                }
            }
            return shipDayArray
        }()
        
        lazy var priceLevel: States = {
            [unowned self] in
            return States(rawValue: self.priceLevelRaw) ?? States.NY
        }()
        
        lazy var coopList: [String] = {
            [unowned self] in
            return self.coopString.characters.split(Int.max, allowEmptySlices: false, isSeparator: { $0 == "," }).map { String($0) }
        }()
        
    }
