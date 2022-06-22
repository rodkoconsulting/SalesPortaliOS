
import Foundation

class SampleOrderInventory: OrderInventory {

    override init(queryResult: FMResultSet?, poDict: [String : poDictType]?) {
        super.init(queryResult: queryResult, poDict: poDict)
    }
    
    override func getDbDetailInsert(_ orderNo: Int) -> String {
        let comment = (self.comment ?? "").replacingOccurrences(of: "'", with: "''")
        return "(\(orderNo), '" + itemCode + "', \(bottleTotal), 0.0, '" + "''" + "', 0, 0, '" + comment + "')"
    }
}
