import Foundation

protocol isOrderAddress {
    var code: String { get }
    var name: String { get }
    var address: String { get }
}

class SampleOrderAddress : NSObject, isOrderAddress  {
    var code: String
    var rep: String
    var name: String
    var address: String
    var region: String
    
    init(queryResult: FMResultSet?) {
        code = queryResult?.string(forColumn: "code") ?? ""
        rep = queryResult?.string(forColumn: "rep") ?? ""
        name = queryResult?.string(forColumn: "name") ?? ""
        address = queryResult?.string(forColumn: "address") ?? ""
        region = queryResult?.string(forColumn: "region") ?? ""
    }
}

class AccountOrderAddress : NSObject, isOrderAddress  {
    var code: String
    var name: String
    var address: String
    
    init(queryResult: FMResultSet?) {
        code = queryResult?.string(forColumn: "code") ?? ""
        name = queryResult?.string(forColumn: "name") ?? ""
        address = queryResult?.string(forColumn: "address") ?? ""
    }
}
