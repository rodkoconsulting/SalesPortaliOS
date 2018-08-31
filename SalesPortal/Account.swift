    //
    //  Inventory.swift
    //  StormyNew
    //
    //  Created by administrator on 7/2/15.
    //  Copyright (c) 2015 Polaner Selections. All rights reserved.
    //
    
    import Foundation
    
    enum ShipDays: Int {
        case monday = 2
        case tuesday
        case wednesday
        case thursday
        case friday
        
        static let fullWeek = [monday, tuesday, wednesday, thursday, friday]
    }
    
    enum AccountStatus: String {
        case CodSla = "CS"
        case CodInt = "CI"
        case CodPol = "CP"
        case PastDue = "P"
        case Expired = "E"
        case Inactive = "I"
        case Ok = ""
    }
    
    enum Territory: String {
        case NJ
        case NYM
        case NYLI
        case NYU
        case NYWH
        case PA
        case Manager
    }
    
    extension AccountStatus {
        var gridText: String {
            switch self {
            case .CodInt:
                return "COD INT"
            case .CodSla:
                return "COD SLA"
            case .CodPol:
                return "COD POL"
            case .PastDue:
                return "Past Due"
            case .Expired:
                return "Expired"
            case .Inactive:
                return "Inactive"
            case .Ok:
                return ""
            }
        }
        
        var gridColor: UIColor? {
            switch self {
            case .CodInt, .CodSla, .CodPol:
                    return GridSettings.colorCod
            case .PastDue:
                    return GridSettings.colorPastDue
            case .Expired:
                    return GridSettings.colorExpired
            case .Inactive:
                    return GridSettings.colorInactive
            case .Ok:
                    return nil
            }
        }
    }
    
    enum States: String {
        case NY = "Y"
        case NJ = "J"
        case PA = "P"
        
        static let allValues = [NY.rawValue, NJ.rawValue, PA.rawValue]
        
        func labelText() -> String {
            switch self {
            case .NY:
                return "NY"
            case .NJ:
                return "NJ"
            case .PA:
                return "PA"                }
        }
    }
    
    class AccountInvoiceHeader: SyncRows {
        let division: String?
        let customerNo: String?
        let invoiceNo: String?
        let headerSeqNo: String?
        let invoiceType: String?
        let invoiceDate: String?
        let comment: String?
        
        required init(dict: [String: Any]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            invoiceNo = dict?["InvNo"] as? String
            headerSeqNo = dict?["SeqNoH"] as? String
            invoiceType = dict?["Type"] as? String
            invoiceDate = dict?["Date"] as? String
            comment = dict?["Comment"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo else {
                    return nil
            }
            return "INVOICE_NO='" + invoiceNo + "' and HEADER_SEQ_NO='" + headerSeqNo + "'"
            }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo,
                let division = self.division,
                let customerNo = self.customerNo,
                let invoiceType = self.invoiceType,
                let invoiceDate = self.invoiceDate,
                let comment = self.comment else {
                    return nil
            }
            return "('" + invoiceNo + "', '" + headerSeqNo + "', '" + division + "', '" + customerNo + "', '" + invoiceType + "', '" + invoiceDate + "', '" + comment + "')"
            }()
    
    }
    
    class AccountInvoiceDetail: SyncRows {
        let invoiceNo: String?
        let headerSeqNo: String?
        let detailSeqNo: String?
        let itemCode: String?
        let quantity: Double?
        let unitPrice: Double?
        let total: Double?
        
        required init(dict: [String: Any]?) {
            invoiceNo = dict?["InvNo"] as? String
            headerSeqNo = dict?["SeqNoH"] as? String
            detailSeqNo = dict?["SeqNoD"] as? String
            itemCode = dict?["Item"] as? String
            quantity = dict?["Qty"] as? Double
            unitPrice = dict?["Price"] as? Double
            total = dict?["Total"] as? Double
        }
        
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo,
                let detailSeqNo = self.detailSeqNo else {
                    return nil
            }
            return "INVOICE_NO='" + invoiceNo + "' and HEADER_SEQ_NO='" + headerSeqNo + "' and DETAIL_SEQ_NO='" + detailSeqNo + "'"
            }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let invoiceNo = self.invoiceNo,
                let headerSeqNo = self.headerSeqNo,
                let detailSeqNo = self.detailSeqNo,
                let itemCode = self.itemCode,
                let quantity = self.quantity,
                let unitPrice = self.unitPrice,
                let total = self.total else {
                    return nil
            }
            return "('" + invoiceNo + "', '" + headerSeqNo + "', '" + detailSeqNo + "', '" + itemCode + "', " + "\(quantity)" + ", " + "\(unitPrice)" + ", " + "\(total)" + ")"
            }()
    }
    
    class AccountItemsInactive: InvDesc {
        
    }
    
    class AccountAddress: SyncRows {
        let division: String?
        let customerNo: String?
        let shipToCode: String?
        let shipToName: String?
        let shipToAddress: String?
        
        required init(dict: [String: Any]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            shipToCode = dict?["Code"] as? String
            shipToName = dict?["Name"] as? String
            shipToAddress = dict?["Addr"] as? String
        }
        
        lazy var getDbDelete: String? = {
            [unowned self] in
            
            guard let division = self.division,
                let customerNo = self.customerNo,
                let shipToCode = self.shipToCode else {
                    return nil
            }
            return "DIVISION_NO='" + division + "' and CUSTOMER_NO='" + customerNo + "' and CODE='" + shipToCode + "'"
            }()
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let division = self.division,
                let customerNo = self.customerNo,
                let shipToCode = self.shipToCode,
                let shipToName = self.shipToName,
                let shipToAddress = self.shipToAddress
                else {
                    return nil
            }
            return "('" + division + "', '" + customerNo + "', '" + shipToCode + "', '" + shipToName + "', '" + shipToAddress + "')"
            }()
    }

    
    class AccountList: SyncRows {
        let division: String?
        let customerNo: String?
        let customerName: String?
        let shipDays: String?
        let priceLevel: String?
        let coopList: String?
        let status: String?
        let buyer1: String?
        let buyer2: String?
        let buyer3: String?
        let buyer1Email: String?
        let buyer2Email: String?
        let buyer3Email: String?
        let buyer1Phone: String?
        let buyer2Phone: String?
        let buyer3Phone: String?
        let affil: String?
        let addr1: String?
        let addr2: String?
        let city: String?
        let state: String?
        let zip: String?
        let rep: String?
        let region: String?
        let shipTo: String?
        
        required init(dict: [String: Any]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            customerName = dict?["CustName"] as? String
            shipDays = dict?["Days"] as? String
            priceLevel = dict?["Price"] as? String
            coopList = dict?["Coop"] as? String
            status = dict?["Status"] as? String
            buyer1 = dict?["Buyer1"] as? String
            buyer2 = dict?["Buyer2"] as? String
            buyer3 = dict?["Buyer3"] as? String
            buyer1Email = dict?["Buyer1Email"] as? String
            buyer2Email = dict?["Buyer2Email"] as? String
            buyer3Email = dict?["Buyer3Email"] as? String
            buyer1Phone = dict?["Buyer1Phone"] as? String
            buyer2Phone = dict?["Buyer2Phone"] as? String
            buyer3Phone = dict?["Buyer3Phone"] as? String
            affil = dict?["Affil"] as? String
            addr1 = dict?["Addr1"] as? String
            addr2 = dict?["Addr2"] as? String
            city = dict?["City"] as? String
            state = dict?["State"] as? String
            zip = dict?["Zip"] as? String
            rep = dict?["Rep"] as? String
            region = dict?["Region"] as? String
            shipTo = dict?["ShipTo"] as? String
        }
        
        lazy var getDbDelete: String?  = {
            [unowned self] in
            guard let division = self.division,
                let customerNo = self.customerNo else {
                return nil
            }
            return "DIVISION_NO='" + division + "' and CUSTOMER_NO='" + customerNo + "'"
            }()
        
        
        lazy var getDbInsert: String? = {
            [unowned self] in
            guard let division = self.division,
                let customerNo = self.customerNo,
                let customerName = self.customerName,
                let shipDays = self.shipDays,
                let priceLevel = self.priceLevel,
                let coopList = self.coopList,
                let status = self.status,
                let buyer1 = self.buyer1,
                let buyer2 = self.buyer2,
                let buyer3 = self.buyer3,
                let buyer1Email = self.buyer1Email,
                let buyer2Email = self.buyer2Email,
                let buyer3Email = self.buyer3Email,
                let buyer1Phone = self.buyer1Phone,
                let buyer2Phone = self.buyer2Phone,
                let buyer3Phone = self.buyer3Phone,
                let affil = self.affil,
                let addr1 = self.addr1,
                let addr2 = self.addr2,
                let city = self.city,
                let state = self.state,
                let zip = self.zip,
                let rep = self.rep,
                let region = self.region,
                let shipTo = self.shipTo else {
                    return nil
            }
            return "('" + division + "', '" + customerNo + "', '" + customerName + "', '" + shipDays + "', '" + priceLevel + "', '" + coopList + "', '" + status + "', '" + buyer1 + "', '" + buyer2 + "', '" + buyer3 + "', '" + buyer1Email + "', '" + buyer2Email + "', '" + buyer3Email + "', '" + buyer1Phone + "', '" + buyer2Phone + "', '" + buyer3Phone + "', '" + affil + "', '" + addr1 + "', '" + addr2 + "', '" + city + "', '" + state + "', '" + zip + "', '" + rep + "', '" + region + "', '" + shipTo + "')"
            }()

    }
    
    
    struct AccountSync {
        let listSync: Sync<AccountList>
        let invoiceHeaderSync: Sync<AccountInvoiceHeader>
        let invoiceDetailSync: Sync<AccountInvoiceDetail>
        let itemsInactiveSync: Sync<AccountItemsInactive>
        let addressSync: Sync<AccountAddress>
        
        init(listDict: [String : Any], invoiceHeaderDict: [String : Any], invoiceDetailDict: [String : Any], itemsInactiveDict: [String : Any], addressDict: [String : Any]) {
            listSync = Sync<AccountList>(dict: listDict)
            invoiceHeaderSync = Sync<AccountInvoiceHeader>(dict: invoiceHeaderDict)
            invoiceDetailSync = Sync<AccountInvoiceDetail>(dict: invoiceDetailDict)
            itemsInactiveSync = Sync<AccountItemsInactive>(dict: itemsInactiveDict)
            addressSync = Sync<AccountAddress>(dict: addressDict)
        }
    }
    
    @objcMembers
    class Account : NSObject {
        
        let divisionNo: String
        let customerNoRaw: String
        let shipDaysRaw: String
        let customerName: String
        let priceLevelRaw: String
        let coopString: String
        let status: AccountStatus
        let buyer1: String
        let buyer2: String
        let buyer3: String
        let buyer1Email: String
        let buyer2Email: String
        let buyer3Email: String
        let buyer1Phone: String
        let buyer2Phone: String
        let buyer3Phone: String
        let affil: String
        let addr1: String
        let addr2: String
        let city: String
        let state: String
        let zip: String
        let rep: String
        let region: String
        let shipTo: String
        
        
        init(queryResult: FMResultSet?) {
            divisionNo = queryResult?.string(forColumn: "division_no") ?? ""
            customerNoRaw = queryResult?.string(forColumn: "customer_no") ?? ""
            shipDaysRaw = queryResult?.string(forColumn: "ship_days") ?? ""
            customerName = queryResult?.string(forColumn: "customer_name") ?? ""
            priceLevelRaw = queryResult?.string(forColumn: "price_level") ?? ""
            coopString = queryResult?.string(forColumn: "coop_list") ?? ""
            status = AccountStatus(rawValue:queryResult?.string(forColumn: "status") ?? "") ?? AccountStatus.Ok
            buyer1 = queryResult?.string(forColumn: "buyer1") ?? ""
            buyer2 = queryResult?.string(forColumn: "buyer2") ?? ""
            buyer3 = queryResult?.string(forColumn: "buyer3") ?? ""
            buyer1Email = queryResult?.string(forColumn: "buyer1Email") ?? ""
            buyer2Email = queryResult?.string(forColumn: "buyer2Email") ?? ""
            buyer3Email = queryResult?.string(forColumn: "buyer3Email") ?? ""
            buyer1Phone = queryResult?.string(forColumn: "buyer1Phone") ?? ""
            buyer2Phone = queryResult?.string(forColumn: "buyer2Phone") ?? ""
            buyer3Phone = queryResult?.string(forColumn: "buyer3Phone") ?? ""
            affil = queryResult?.string(forColumn: "affil") ?? ""
            addr1 = queryResult?.string(forColumn: "addr1") ?? ""
            addr2 = queryResult?.string(forColumn: "addr2") ?? ""
            city = queryResult?.string(forColumn: "city") ?? ""
            state = queryResult?.string(forColumn: "state") ?? ""
            zip = queryResult?.string(forColumn: "zip") ?? ""
            rep = queryResult?.string(forColumn: "rep") ?? ""
            region = queryResult?.string(forColumn: "region") ?? ""
            shipTo = queryResult?.string(forColumn: "ship_to") ?? ""
        }
        
        lazy var customerNo : String = {
            [unowned self]  in
                return self.divisionNo + self.customerNoRaw
        }()
        
        lazy var shipDays : [ShipDays] = {
            [unowned self] in
            var shipDayArray: [ShipDays] = [ShipDays]()
            for (index, day) in self.shipDaysRaw.enumerated() {
                if let shipDay = ShipDays(rawValue: index + 2 ), day == "Y" {
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
            return self.coopString.split(maxSplits: Int.max, omittingEmptySubsequences: true, whereSeparator: { $0 == "," }).map { String($0) }
        }()
        
        lazy var statusString: String = {
            [unowned self] in
            return self.status.gridText
        }()
        
        lazy var isMasterAccount: Bool = {
            [unowned self] in
            return customerNoRaw.left(2) == Constants.masterAccountPrefix
        }()
        
        class func getTerritory(_ region: String) -> Territory {
            let territory = region.replacingOccurrences(of: " ", with: "")
            switch (territory) {
            case ("NYL"):
                return .NYLI
            case ("NYW"):
                return .NYWH
            case ("MAN"):
                return .Manager
            default:
                return Territory(rawValue: territory) ?? .Manager
            }
        }
        
    }
