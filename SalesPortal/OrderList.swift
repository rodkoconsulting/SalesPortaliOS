
import Foundation

enum OrderListFilter: String {
    case All = "All Orders"
    case Daily = "Daily Sales"
    case MoBo = "MO / BO / BH"
    case Future = "Future Orders"
    case Samples = "Samples"
    
    static let rawValues = [All.rawValue, Daily.rawValue, MoBo.rawValue, Future.rawValue, Samples.rawValue]
    
}


extension OrderListFilter {
    
    var getIndex: Int? {
        return OrderListFilter.rawValues.index(of: self.rawValue)
    }
    
    func isFilterMatch(_ orderList: OrderList) -> Bool {
        switch self {
        case .All:
            return true
        case .Daily:
            return orderList.isDailySale
        case .MoBo:
            return orderList.isMoBo
        case .Future:
            return orderList.isFutureOrder
        case .Samples:
            return orderList.isSampleOrder
        }
    }
}


    class OrderHeader: SyncRows {
        let division: String?
        let customerNo: String?
        let orderNo: String?
        let orderDate: String?
        let shipExpireDate: String?
        let orderStatus: String?
        let holdCode: String?
        let coopNo: String?
        let comment: String?
        
        required init(dict: [String: Any]?) {
            division = dict?["Div"] as? String
            customerNo = dict?["CustNo"] as? String
            orderNo = dict?["OrderNo"] as? String
            orderDate = dict?["OrderDate"] as? String
            shipExpireDate = dict?["ShipDate"] as? String
            orderStatus = dict?["Status"] as? String
            holdCode = dict?["Hold"] as? String
            coopNo = dict?["Coop"] as? String
            comment = dict?["Comment"] as? String
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
                let division = self.division,
                let customerNo = self.customerNo,
                let orderDate = self.orderDate,
                let shipExpireDate = self.shipExpireDate,
                let orderStatus = self.orderStatus,
                let holdCode = self.holdCode,
                let coopNo = self.coopNo,
                let comment = self.comment else {
                    return nil
            }
            return "('" + orderNo + "', '" + orderDate + "', '" + shipExpireDate + "', '" + division + "', '" + customerNo + "', '" + orderStatus + "', '" + holdCode + "', '" + coopNo + "', '" + comment + "')"
            }()
    }

class OrderDetail: SyncRows {
    let orderNo: String?
    let lineNo: String?
    let itemCode: String?
    let quantity: Double?
    let price: Double?
    let total: Double?
    let comment: String?
    
    required init(dict: [String: Any]?) {
        orderNo = dict?["OrderNo"] as? String
        lineNo = dict?["Line"] as? String
        itemCode = dict?["Item"] as? String
        quantity = dict?["Qty"] as? Double
        price = dict?["Price"] as? Double
        total = dict?["Total"] as? Double
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
            let quantity = self.quantity,
            let price = self.price,
            let total = self.total else {
                return nil
        }
        let comment = self.comment ?? ""
        return "('" + orderNo + "', '" + lineNo + "', '" + itemCode + "', '\(quantity)', '\(price)', '\(total)', '" + comment +  "')"
        }()
}


struct OrderListSync {
    let orderHeaderSync: Sync<OrderHeader>
    let orderDetailSync: Sync<OrderDetail>
    
    init(orderHeaderDict: [String : Any], orderDetailDict: [String : Any]) {
        orderHeaderSync = Sync<OrderHeader>(dict: orderHeaderDict)
        orderDetailSync = Sync<OrderDetail>(dict: orderDetailDict)
    }
}


class OrderList : NSObject {
    
    let orderNo: String
    let orderDate: Date?
    let poEta: Date?
    let customerNo: String
    let customerName: String
    let shipExpireDate: Date?
    let orderStatus: String
    let holdCodeRaw: String
    let coopNo: String
    let comment: String
    let lineComment: String
    let itemCode: String
    let itemDescriptionRaw: String
    let brand: String
    let vintage: String
    let uom: String
    let size: String
    let damagedNotes: String
    let quantity: Double
    let price: Double
    let total: Double
    let totalGroupLabel: String = "Total:"
    let rep: String
    let region: String
    
    lazy var territory: String = {
        [unowned self] in
        return Account.getTerritory(self.region).rawValue
    }()
    
    lazy var expirationDate : Date? = {
        [unowned self] in
        if ["MO", "IN"].contains(self.holdCode) {
            return self.shipExpireDate
        }
        return nil
    }()
    
    lazy var isSampleApproved : Bool = {
        return self.orderStatus == "O" && self.holdCodeRaw == "SM"
    }()
    
    lazy var holdCode : String = {
        [unowned self] in
        if self.holdCodeRaw == "MOAPP" {
            return "MO"
        }
        return self.isSampleApproved ? "" : self.holdCodeRaw
    }()

    
    lazy var shipDate : Date? = {
        [unowned self] in
        if ["MO", "BO", "IN"].contains(self.holdCode) {
            return nil
        }
        return self.shipExpireDate
    }()
    
    lazy var boEta : Date? = {
        [unowned self] in
        guard self.holdCode == "BO" && (self.poEta?.getYearInt() ?? 0) > 2000 else {
            return nil
        }
        return self.poEta
    }()
    
    lazy var orderType : String = {
        [unowned self] in
        guard !(self.total == 0 && !["MO", "IN", "BO","SM","MOAPP"].contains(self.holdCodeRaw)) else {
            return "BH"
        }
        if self.orderStatus == "I" {
            return self.orderStatus
        }
        switch self.holdCodeRaw {
        case "BO", "IN":
            return "BO"
        case "MOAPP":
            return "MO"
        case "BH", "MO", "SM":
            return self.holdCodeRaw
        default:
            return "S"
        }
    }()
    
    lazy var isShippingBh : Bool = {
        [unowned self] in
        return self.orderType == "BH" && self.holdCode != "BH"
    }()
    
    lazy var textColor : UIColor? = {
        [unowned self] in
        guard self.holdCode != "BO" else {
            return nil
        }
        return UIColor.black
    }()
    
    lazy var quantityMas : Double = {
        [unowned self] in
        return Double(Int((self.quantity * Double(self.uomInt)).roundedBottles())) / Double(self.uomInt)
    }()
    
    
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
        let bottleSizeArray = self.size.characters.split(maxSplits: Int.max, omittingEmptySubsequences: true, whereSeparator: { $0 == " " }).map { String($0) }
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
    
    lazy var isDailySale : Bool = {
        [unowned self] in
        if self.orderType == "I" {
            return true
        }
        if (self.orderType == "S" || self.isShippingBh) && self.shipDate?.getDateString() == Date().getDailySalesDate().getDateString() {
            return true
        }
        return false
    }()
    
    lazy var isMoBo : Bool = {
        [unowned self] in
        return (self.orderType == "MO" || self.orderType == "BO" || self.orderType == "BH" ) && !self.isShippingBh
    }()
  
    lazy var isFutureOrder : Bool = {
        [unowned self] in
        return self.orderType == "S" || self.orderType == "I" || self.isShippingBh
    }()
    
    lazy var isSampleOrder : Bool = {
        [unowned self] in
        return self.orderType == "SM"
    }()
    
    lazy var gridColor: UIColor? = {
        [unowned self] in
        guard ["MO","IN"].contains(self.holdCode) else {
            return nil
        }
        guard let expirationDate = self.expirationDate else {
            return nil
        }

        if expirationDate.isLessThanDate(Date()) {
            return GridSettings.colorMoboHasExpired
        }
        if expirationDate.isLessThanDate((Date().getDailySalesDate())) {
            return GridSettings.colorMoboWillExpire
        }
        return nil
    }()
    
    init(queryResult: FMResultSet?) {
        orderNo = queryResult?.string(forColumn: "order_no") ?? ""
        customerNo = queryResult?.string(forColumn: "customer_no") ?? ""
        customerName = queryResult?.string(forColumn: "customer_name") ?? ""
        let orderDateString = queryResult?.string(forColumn: "order_date") ?? ""
        orderDate = orderDateString.getShipDate()
        let shipExpireDateString = queryResult?.string(forColumn: "ship_date") ?? ""
        shipExpireDate = shipExpireDateString.getShipDate()
        let poEtaString = queryResult?.string(forColumn: "po_eta") ?? ""
        poEta = poEtaString.getDate()
        orderStatus = queryResult?.string(forColumn: "status") ?? ""
        holdCodeRaw = queryResult?.string(forColumn: "hold") ?? ""
        coopNo = queryResult?.string(forColumn: "coop") ?? ""
        comment = queryResult?.string(forColumn: "comment") ?? ""
        lineComment = queryResult?.string(forColumn: "line_comment") ?? ""
        itemCode = queryResult?.string(forColumn: "item_code") ?? ""
        itemDescriptionRaw = queryResult?.string(forColumn: "desc") ?? ""
        brand = queryResult?.string(forColumn: "brand") ?? ""
        vintage = queryResult?.string(forColumn: "vintage") ?? ""
        uom = queryResult?.string(forColumn: "uom") ?? ""
        size = queryResult?.string(forColumn: "size") ?? ""
        damagedNotes = queryResult?.string(forColumn: "damaged_notes") ?? ""
        quantity = queryResult?.double(forColumn: "qty") ?? 0
        price = queryResult?.double(forColumn: "price") ?? 0
        total = queryResult?.double(forColumn: "total") ?? 0
        rep = queryResult?.string(forColumn: "rep") ?? ""
        region = queryResult?.string(forColumn: "region") ?? ""
    }    
}

