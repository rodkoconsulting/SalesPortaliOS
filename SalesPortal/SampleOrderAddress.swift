import Foundation

class OrderAddress : NSObject {
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
