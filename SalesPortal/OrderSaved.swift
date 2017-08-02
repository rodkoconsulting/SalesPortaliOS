class OrderSavedList : NSObject {
    
    let orderNo: Int
    let customerName: String
    let orderTypeRaw: String
    let shipDate: Date?
    let saveTime: Date
    let price: Double
    let total: Double
    
    init?(queryResult: FMResultSet?) {
        guard let orderNo = queryResult?.int(forColumn: "order_no") else {
            return nil
        }
        self.orderNo = Int(orderNo)
        orderTypeRaw = queryResult?.string(forColumn: "type") ?? ""
        let rawShipDate = queryResult?.string(forColumn: "ship_date").getShipDate()
        shipDate = rawShipDate?.getYearInt() >= Date().getYearInt() ? rawShipDate : nil
        saveTime = queryResult?.string(forColumn: "save_time").getDateTime() as! Date ?? Date()
        customerName = queryResult?.string(forColumn: "customer_name") ?? ""
        price = queryResult?.double(forColumn: "total_price") ?? 0
        total = queryResult?.double(forColumn: "total_qty") ?? 0
    }
    
    lazy var orderType: String = {
        [unowned self] in
        let orderType = OrderType(rawValue: self.orderTypeRaw) ?? OrderType.Standard
        return orderType.orderText
    }()

    
}
