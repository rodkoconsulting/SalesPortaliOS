

import Foundation

enum SampleListFilter: String {
    case Mtd = "MTD"
    case Ytd = "YTD"
    case oneYear = "1 Year"
    
    static let rawValues = [Mtd.rawValue, Ytd.rawValue, oneYear.rawValue]
}


extension SampleListFilter {
    
    var getIndex: Int? {
        return SampleListFilter.rawValues.firstIndex(of: self.rawValue)
    }
    
    func isFilterMatch(_ sampleList: SampleList) -> Bool {
        switch self {
        case .Mtd:
            return sampleList.isMtd
        case .Ytd:
            return sampleList.isYtd
        case .oneYear:
            return true
        }
    }
}


class SampleHeader: SyncRows {
    let orderNo: String?
    let shipDate: String?
    let rep: String?
    let shipTo: String?
    
    required init(dict: [String: Any]?) {
        orderNo = dict?["OrderNo"] as? String
        shipDate = dict?["Date"] as? String
        rep = dict?["Rep"] as? String
        shipTo = dict?["ShipTo"] as? String
    }
    
    lazy var getDbDelete: String? = {
        [unowned self] in
        guard let orderNo = self.orderNo else {
            return nil
        }
        return "ORDER_NO='" + orderNo + "'"
        }()
    
    lazy var getDbInsert: String? = {
        [unowned self] in
        guard let orderNo = self.orderNo,
            let shipDate = self.shipDate,
            let rep = self.rep,
            let shipTo = self.shipTo else {
                return nil
        }
        return "('" + orderNo + "', '" + shipDate + "', '" + rep + "', '" + shipTo + "')"
        }()
}

class SampleDetail: SyncRows {
    let orderNo: String?
    let lineNo: String?
    let itemCode: String?
    let quantity: Double?
    let comment: String?
    
    required init(dict: [String: Any]?) {
        orderNo = dict?["OrderNo"] as? String
        lineNo = dict?["Line"] as? String
        itemCode = dict?["Item"] as? String
        quantity = dict?["Qty"] as? Double
        comment = dict?["Cmt"] as? String
    }
    
    lazy var getDbDelete: String? = {
        [unowned self] in
        guard let orderNo = self.orderNo,
            let lineNo = self.lineNo else {
                return nil
        }
        return "ORDER_NO='" + orderNo + "' AND LINE_NO='" + lineNo + "'"
        }()
    
    lazy var getDbInsert: String? = {
        [unowned self] in
        guard let orderNo = self.orderNo,
            let lineNo = self.lineNo,
            let itemCode = self.itemCode,
            let quantity = self.quantity else {
                return nil
        }
        let comment = self.comment ?? ""
        return "('" + orderNo + "', '" + lineNo + "', '" + itemCode + "', '\(quantity)', '" + comment + "')"
        }()
}

class SampleAddress: SyncRows {
    let shipToCode: String?
    let shipToRep: String?
    let shipToName: String?
    let shipToAddress: String?
    let repRegion: String?
    let isRep: Bool?
    let isActive: Bool?
    
    required init(dict: [String: Any]?) {
        shipToCode = dict?["Code"] as? String
        shipToRep = dict?["Rep"] as? String
        shipToName = dict?["Name"] as? String
        shipToAddress = dict?["Addr"] as? String
        repRegion = dict?["Reg"] as? String
        isRep = dict?["isRep"] as? Bool
        isActive = dict?["isAct"] as? Bool
    }
    
    lazy var getDbDelete: String? = {
        [unowned self] in
        guard let shipToCode = self.shipToCode else {
            return nil
        }
        return "CODE='" + shipToCode + "'"
        }()
    
    lazy var getDbInsert: String? = {
        [unowned self] in
        guard let shipToCode = self.shipToCode,
            let shipToRep = self.shipToRep,
            let shipToName = self.shipToName,
            let shipToAddress = self.shipToAddress,
            let repRegion = self.repRegion,
            let isRep = self.isRep,
            let isActive = self.isActive
        else {
                return nil
        }
        return "('" + shipToCode + "', '" + shipToRep + "', '" + shipToName + "', '" + shipToAddress + "', '" + repRegion + "', '\(isRep)', '\(isActive)')"
        }()
}

class SampleItemsInactive: SyncRows {
    let itemCode: String?
    let description: String?
    let brand: String?
    let masterVendor: String?
    let vintage: String?
    let uom: String?
    let size: String?
    let damagedNotes: String?
    let focus: String?
    let country: String?
    let region: String?
    let appellation: String?
    
    required init(dict: [String: Any]?)
    {
        itemCode = dict?["Code"] as? String
        description = dict?["Desc"] as? String
        brand = dict?["Brand"] as? String
        masterVendor = dict?["MVendor"] as? String
        vintage = dict?["Vintage"] as? String
        uom = dict?["Uom"] as? String
        size = dict?["Size"] as? String
        damagedNotes = dict?["DamNotes"] as? String
        focus = dict?["Focus"] as? String
        country = dict?["Country"] as? String
        region = dict?["Region"] as? String
        appellation = dict?["App"] as? String
    }

    
    lazy var getDbDelete : String? = {
        [unowned self] in
        guard let itemCode = self.itemCode else {
            return nil
        }
        return "ITEM_CODE='" + itemCode + "'"
        }()
    
    lazy var getDbInsert : String? = {
        [unowned self] in
        guard let itemCode = self.itemCode,
            let description = self.description,
            let brand = self.brand,
            let masterVendor = self.masterVendor,
            let vintage = self.vintage,
            let uom = self.uom,
            let size = self.size,
            let damagedNotes = self.damagedNotes,
            let focus = self.focus,
            let country = self.country,
            let region = self.region,
            let appellation = self.appellation else {
                return nil
        }
        return "('" + itemCode + "', '" + description + "', '" + brand + "', '" + masterVendor + "', '" + vintage + "', '" + uom + "', '" + size + "', '" + damagedNotes + "', '" + focus + "', '" + country + "', '" + region + "', '" + appellation + "')"
        }()

}


struct SampleListSync {
    let sampleHeaderSync: Sync<SampleHeader>
    let sampleDetailSync: Sync<SampleDetail>
    let sampleAddressSync: Sync<SampleAddress>
    let sampleItemsInactiveSync: Sync<SampleItemsInactive>
    
    init(sampleHeaderDict: [String : Any], sampleDetailDict: [String : Any], sampleAddressDict: [String : Any], sampleItemsInactiveDict: [String : Any]) {
        sampleHeaderSync = Sync<SampleHeader>(dict: sampleHeaderDict)
        sampleDetailSync = Sync<SampleDetail>(dict: sampleDetailDict)
        sampleAddressSync = Sync<SampleAddress>(dict: sampleAddressDict)
        sampleItemsInactiveSync = Sync<SampleItemsInactive>(dict: sampleItemsInactiveDict)
    }
}

@objcMembers
class SampleList : NSObject {
    
    let orderNo: String
    let itemCode: String
    let itemDescriptionRaw: String
    let comment: String
    let brand: String
    let vintage: String
    let uom: String
    let size: String
    let shipDate: Date?
    let damagedNotes: String
    let quantity: Double
    let rep: String
    let region: String
    let isFocusString: String
    let shipToName: String
    let masterVendor: String?
    let country: String?
    let appellation: String?

    
    
    lazy var quantityMas : Double = {
        [unowned self] in
        return Double(Int((self.quantity * Double(self.uomInt)).roundedBottles())) / Double(self.uomInt)
        }()
    
    lazy var quantityBottle: Int = {
        [unowned self] in
        Int(round(self.quantity * Double(self.uomInt)))
        } ()
    
    lazy var uomString : String = {
        [unowned self] in
        return self.uom.replacingOccurrences(of: "C", with: "")
        }()
    
    lazy var uomInt : Int = {
        [unowned self] in
        return Int(self.uomString) ?? 12
        }()
    
    lazy var sizeDescription : String = {
        [unowned self] in
        let bottleSizeArray = self.size.split(maxSplits: Int.max, omittingEmptySubsequences: true, whereSeparator: { $0 == " " }).map { String($0) }
        guard bottleSizeArray.count > 0 else {
            return "750"
        }
        let sizeString = bottleSizeArray[0]
        let unitString = bottleSizeArray[1]
        return unitString == "L" ? sizeString + unitString : sizeString
        }()
    
    lazy var itemDescription : String? = {
        [unowned self] in
        guard !self.itemDescriptionRaw.isEmpty else {
            return ""
        }
        return self.brand + " " + self.itemDescriptionRaw + " " + self.vintage + " (" + self.uomString + "/" + self.sizeDescription + ")" + self.damagedNotes
        }()
    
    lazy var isFocus : Bool = {
        [unowned self] in
        return self.isFocusString == "Y"
        }()

    lazy var isMtd : Bool = {
        [unowned self] in
        return self.shipDate?.getYearInt() == Date().getYearInt() && self.shipDate?.getMonthInt() == Date().getMonthInt()
        }()
    
    lazy var isYtd : Bool = {
        [unowned self] in
        return self.shipDate?.getYearInt() == Date().getYearInt()
        }()

    lazy var gridColor: UIColor? = {
        [unowned self] in
        if self.isFocus {
            return GridSettings.colorFocus
        }
        return nil
        }()
    
    init(queryResult: FMResultSet?) {
        orderNo = queryResult?.string(forColumn: "order_no") ?? ""
        let shipDateString = queryResult?.string(forColumn: "ship_date") ?? ""
        shipDate = shipDateString.getShipDate()
        isFocusString = queryResult?.string(forColumn: "focus") ?? ""
        itemCode = queryResult?.string(forColumn: "item_code") ?? ""
        itemDescriptionRaw = queryResult?.string(forColumn: "desc") ?? ""
        brand = queryResult?.string(forColumn: "brand") ?? ""
        vintage = queryResult?.string(forColumn: "vintage") ?? ""
        uom = queryResult?.string(forColumn: "uom") ?? ""
        size = queryResult?.string(forColumn: "size") ?? ""
        damagedNotes = queryResult?.string(forColumn: "damaged_notes") ?? ""
        quantity = queryResult?.double(forColumn: "qty") ?? 0
        rep = queryResult?.string(forColumn: "rep") ?? ""
        region = queryResult?.string(forColumn: "region") ?? ""
        shipToName = queryResult?.string(forColumn: "name") ?? ""
        masterVendor = queryResult?.string(forColumn: "master_vendor") ?? ""
        country = queryResult?.string(forColumn: "country") ?? ""
        appellation = queryResult?.string(forColumn: "appellation") ?? ""
        comment = queryResult?.string(forColumn: "comment") ?? ""
    }
}

