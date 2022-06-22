
import Foundation

struct SampleOrderService {
    
    typealias JSONPostCompletion = (_ success: Bool, _ error: ErrorCode?) -> Void
    
    let sampleOrder: SampleOrder
    let apiCredentials: [String : String]?
    let dB : FMDatabase
    
    init(sampleOrder: SampleOrder, apiCredentials: [String : String]? = nil) {
        self.sampleOrder = sampleOrder
        self.apiCredentials = apiCredentials
        self.dB = FMDatabase(path: Constants.databasePath as String)
    }
    
    func sendOrder(_ completion: @escaping (JSONPostCompletion) ){
        let apiService = ApiService(apiString: "transmit_sample/")
        guard let jsonData = sampleOrder.getTransmitData(),
            let credentials = apiCredentials else {
                completion(false, ErrorCode.dbError)
                return
        }
        apiService.sendApiOrder(jsonData, credentialDict: credentials){
            (success, errorCode) in
            completion(success, errorCode)
        }
    }
    
    func depleteDb() {
        depleteTransmitInventory()
    }
    
    func depleteTransmitInventory() {
        guard let orderInventory = sampleOrder.orderInventory else {
            return
        }
        for line in orderInventory where ((line as? OrderInventory)?.bottles ?? 0) > 0 {
            guard let item = line as? OrderInventory else {
                return
            }
            let quantityAvailable = Double(Int((item.quantityAvailable * Double(item.uomInt)).roundedBottles()) - item.bottles) / Double(item.uomInt)
            updateDbInventory(item.itemCode, quantityAvailable: quantityAvailable)
        }
    }
    
    func updateDbInventory(_ itemCode: String, quantityAvailable: Double) {
        guard let dB = FMDatabase(path: Constants.databasePath as String) else {
            return
        }
        guard dB.open() else {
            return
        }
        let sqlUpdateInventory = "UPDATE INV_QTY SET QTY_AVAIL=\(quantityAvailable) WHERE ITEM_CODE='\(itemCode)'"
        dB.executeUpdate(sqlUpdateInventory, withArgumentsIn: nil)
    }
}
