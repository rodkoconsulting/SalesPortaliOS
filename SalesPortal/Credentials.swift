
import Foundation

struct Credentials {
    
    let apiInit: String = "users/"
    let credentialName: String = "polPortal"
    let username: String
    let password: String
    var state: String?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    var credentialDict: [String : String] {
        get {
            return ["username": username, "password": password]
        }
    }
    
    typealias JSONDictionaryCompletion = (data: [String: AnyObject]?, error: ErrorCode?) -> Void
    
    static func getCredentials() -> [String : String]? {
        guard let dictionary = Locksmith.loadDataForUserAccount("polPortal") as? [String: String] else {
            return nil
        }
        return dictionary
    }
    
    static func saveStateCredentials(state state: String) {
        guard var credentials = Credentials.getCredentials() else {
            return
        }
        credentials["state"] = String(state[state.endIndex.predecessor()])
        Credentials.deleteCredentials()
        try! Locksmith.saveData(credentials, forUserAccount: "polPortal")
    }
    
    static func getStateCredentials() -> String {
        guard let credentials = Credentials.getCredentials(), let credentialState = credentials["state"] else {
            return "Y"
        }
        guard credentialState.characters.count > 0 else {
            return "Y"
        }
        return credentialState
    }
    
    func saveCredentials(userDict: [String : AnyObject]) {
        var dict = credentialDict
        for (key, value) in userDict {
            dict[key] = value as? String
        }
        
        try! Locksmith.saveData(dict, forUserAccount: "polPortal")
    }
    
    static func deleteCredentials() -> Void {
        do {
            try Locksmith.deleteDataForUserAccount("polPortal")
        } catch {
            
        }
    }
    
    func verifyCredentials(completion: (JSONDictionaryCompletion)) {
        let apiService = ApiService(apiString: apiInit)
        apiService.getApiUser(credentialDict){
            (let JSONDictionary, error) in
            completion(data: JSONDictionary, error: error)
        }
        
    }
}