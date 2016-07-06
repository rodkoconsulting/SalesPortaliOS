import Foundation

struct ApiService {
    
    let apiBaseURL: NSURL?
    let apiInit: String
    
    typealias JSONDictionaryCompletion = (data: [String: AnyObject]?, error: ErrorCode?) throws -> Void
    typealias CredentialDict = [String : String]
    
    
    init(apiString: String) {
        apiInit = apiString
        apiBaseURL = NSURL(string: "https://api.polanerselections.com:8443/\(apiInit)")
    }
    
    func getApiUser(credentialDict: CredentialDict, completion: (JSONDictionaryCompletion)) {
        let apiOperation = ApiOperation(url: apiBaseURL!, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (let JSONDictionary, error) in
            try! completion(data: JSONDictionary, error: error)
        }
    }
    
    func getApiInv(timeSyncDict: [String : String], credentialDict: CredentialDict, completion: (JSONDictionaryCompletion)) {
        guard let qtyDateTime = timeSyncDict["qty"],
                let descDateTime = timeSyncDict["desc"],
                let priceDateTime = timeSyncDict["price"],
                let poDateTime = timeSyncDict["po"] else {
            try! completion(data: nil, error: ErrorCode.DbError)
            return
        }
        
        let qtySyncArray = qtyDateTime.characters.split{$0 == " "}.map { String($0) }
        let descSyncArray = descDateTime.characters.split{$0 == " "}.map { String($0) }
        let priceSyncArray = priceDateTime.characters.split{$0 == " "}.map { String($0) }
        let poSyncArray = poDateTime.characters.split{$0 == " "}.map { String($0) }
        
        let apiString = "\(qtySyncArray[0])/\(qtySyncArray[1])/" +
            "\(priceSyncArray[0])/\(priceSyncArray[1])/" +
            "\(descSyncArray[0])/\(descSyncArray[1])/" +
            "\(poSyncArray[0])/\(poSyncArray[1])/"
        
        guard let apiURL = NSURL(string: apiString, relativeToURL: apiBaseURL) else {
            try! completion(data: nil, error: ErrorCode.UnknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (let JSONDictionary, error) in
            try! completion(data: JSONDictionary, error: error)
        }
    }
    
    func getApiAccount(timeSyncDict: [String : String], credentialDict: CredentialDict, completion: (JSONDictionaryCompletion)) {
        guard let listDateTime = timeSyncDict["list"],
                let invHeadDateTime = timeSyncDict["HistH"],
                let invDetDateTime = timeSyncDict["HistD"],
                let itemsInactiveDateTime = timeSyncDict["Inact"] else {
            try! completion(data: nil, error: ErrorCode.DbError)
            return
        }
        let listSyncArray = listDateTime.characters.split{$0 == " "}.map { String($0) }
        let invHeadSyncArray = invHeadDateTime.characters.split{$0 == " "}.map { String($0) }
        let invDetSyncArray = invDetDateTime.characters.split{$0 == " "}.map { String($0) }
        let itemsInactiveSyncArray = itemsInactiveDateTime.characters.split{$0 == " "}.map { String($0) }
        let apiString = "\(listSyncArray[0])/\(listSyncArray[1])/" +
            "\(invHeadSyncArray[0])/\(invHeadSyncArray[1])/" +
            "\(invDetSyncArray[0])/\(invDetSyncArray[1])/" +
            "\(itemsInactiveSyncArray[0])/\(itemsInactiveSyncArray[1])/"
        guard let apiURL = NSURL(string: apiString, relativeToURL: apiBaseURL) else {
            try! completion(data: nil, error: ErrorCode.UnknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (let JSONDictionary, error) in
            try! completion(data: JSONDictionary, error: error)
        }
    }

}


