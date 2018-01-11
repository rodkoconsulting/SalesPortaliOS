import Foundation

struct ApiService {
    
    let apiBaseURL: URL?
    let apiInit: String
    
    typealias JSONDictionaryCompletion = (_ data: [String: AnyObject]?, _ error: ErrorCode?) -> Void
    typealias JSONPostCompletion = (_ success: Bool, _ error: ErrorCode?) -> Void
    typealias CredentialDict = [String : String]
    
    
    init(apiString: String) {
        apiInit = apiString
        //apiBaseURL = URL(string: "http://10.0.4.135:8000/" + apiInit)
        apiBaseURL = URL(string: "https://api.polanerselections.com:8443/" + apiInit)
    }
    
    func getApiUser(_ credentialDict: CredentialDict, completion: @escaping (JSONDictionaryCompletion)) {
        let apiOperation = ApiOperation(url: apiBaseURL!, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (JSONDictionary, error) in
            completion(JSONDictionary, error)
        }
    }
    
    func getApiInv(_ timeSyncDict: [String : String], credentialDict: CredentialDict, completion: @escaping (JSONDictionaryCompletion)) {
        guard let qtyDateTime = timeSyncDict["qty"],
                let descDateTime = timeSyncDict["desc"],
                let priceDateTime = timeSyncDict["price"],
                let poDateTime = timeSyncDict["po"] else {
            completion(nil, ErrorCode.dbError)
            return
        }
        
        let qtySyncArray = qtyDateTime.characters.split{$0 == " "}.map { String($0) }
        let descSyncArray = descDateTime.characters.split{$0 == " "}.map { String($0) }
        let priceSyncArray = priceDateTime.characters.split{$0 == " "}.map { String($0) }
        let poSyncArray = poDateTime.characters.split{$0 == " "}.map { String($0) }
        
        let apiString = qtySyncArray[0] + "/" + qtySyncArray[1] + "/" +
            priceSyncArray[0] + "/" + priceSyncArray[1] + "/" +
            descSyncArray[0] + "/" + descSyncArray[1] + "/" +
            poSyncArray[0] + "/" + poSyncArray[1] + "/"
        
        guard let apiURL = URL(string: apiString, relativeTo: apiBaseURL) else {
            completion(nil, ErrorCode.unknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (JSONDictionary, error) in
            completion(JSONDictionary, error)
        }
    }
    
    func getApiAccount(_ timeSyncDict: [String : String], credentialDict: CredentialDict, completion: @escaping (JSONDictionaryCompletion)) {
        guard let listDateTime = timeSyncDict["list"],
                let invHeadDateTime = timeSyncDict["HistH"],
                let invDetDateTime = timeSyncDict["HistD"],
                let itemsInactiveDateTime = timeSyncDict["Inact"] else {
            completion(nil, ErrorCode.dbError)
            return
        }
        let listSyncArray = listDateTime.characters.split{$0 == " "}.map { String($0) }
        let invHeadSyncArray = invHeadDateTime.characters.split{$0 == " "}.map { String($0) }
        let invDetSyncArray = invDetDateTime.characters.split{$0 == " "}.map { String($0) }
        let itemsInactiveSyncArray = itemsInactiveDateTime.characters.split{$0 == " "}.map { String($0) }
        let apiString = listSyncArray[0] + "/" + listSyncArray[1] + "/" +
            invHeadSyncArray[0] + "/" + invHeadSyncArray[1] + "/" +
            invDetSyncArray[0] + "/" + invDetSyncArray[1] + "/" +
            itemsInactiveSyncArray[0] + "/" + itemsInactiveSyncArray[1] + "/"
        guard let apiURL = URL(string: apiString, relativeTo: apiBaseURL) else {
            completion(nil, ErrorCode.unknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (JSONDictionary, error) in
            completion(JSONDictionary, error)
        }
    }
    
    func getApiOrders(_ timeSyncDict: [String : String], credentialDict: CredentialDict, completion: @escaping (JSONDictionaryCompletion)) {
        guard let headerDateTime = timeSyncDict["H"],
            let detailDateTime = timeSyncDict["D"] else {
                completion(nil, ErrorCode.dbError)
                return
        }
        let headerSyncArray = headerDateTime.characters.split{$0 == " "}.map { String($0) }
        let detailSyncArray = detailDateTime.characters.split{$0 == " "}.map { String($0) }
        let apiString = headerSyncArray[0] + "/" + headerSyncArray[1] + "/" +
            detailSyncArray[0] + "/" + detailSyncArray[1] + "/"
        guard let apiURL = URL(string: apiString, relativeTo: apiBaseURL) else {
            completion(nil, ErrorCode.unknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (JSONDictionary, error) in
            completion(JSONDictionary, error)
        }
    }
    
    func getApiSamples(_ timeSyncDict: [String : String], credentialDict: CredentialDict, completion: @escaping (JSONDictionaryCompletion)) {
        guard let headerDateTime = timeSyncDict["H"],
            let detailDateTime = timeSyncDict["D"],
            let addressDateTime = timeSyncDict["A"],
            let inactiveItemsDateTime = timeSyncDict["I"] else {
                completion(nil, ErrorCode.dbError)
                return
        }
        let headerSyncArray = headerDateTime.characters.split{$0 == " "}.map { String($0) }
        let detailSyncArray = detailDateTime.characters.split{$0 == " "}.map { String($0) }
        let addressSyncArray = addressDateTime.characters.split{$0 == " "}.map { String($0) }
        let inactiveItemsSyncArray = inactiveItemsDateTime.characters.split{$0 == " "}.map { String($0) }
        let apiString = headerSyncArray[0] + "/" + headerSyncArray[1] + "/" +
            detailSyncArray[0] + "/" + detailSyncArray[1] + "/" +
            addressSyncArray[0] + "/" + addressSyncArray[1] + "/" +
            inactiveItemsSyncArray[0] + "/" + inactiveItemsSyncArray[1] + "/"
        guard let apiURL = URL(string: apiString, relativeTo: apiBaseURL) else {
            completion(nil, ErrorCode.unknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.downloadJSONFromURL {
            (JSONDictionary, error) in
            completion(JSONDictionary, error)
        }
    }
    
    func sendApiOrder(_ jsonData: Data, credentialDict: CredentialDict, completion: @escaping (JSONPostCompletion)) {
        guard let apiURL = apiBaseURL else {
            completion(false, ErrorCode.unknownError)
            return
        }
        let apiOperation = ApiOperation(url: apiURL, credentials: credentialDict)
        apiOperation.uploadJSONToURL(jsonData) {
            (success, error) in
            completion(success, error)
        }
    }
}


