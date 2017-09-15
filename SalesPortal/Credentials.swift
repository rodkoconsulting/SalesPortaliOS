
import Foundation

struct Credentials {
    
    let apiInit: String = "users/"
    let credentialName: String = "polPortal"
    let username: String
    let password: String
    var state: String?
    var isRep: Bool = true
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    var credentialDict: [String : String] {
        get {
            return ["username": username, "password": password]
        }
    }
    
    typealias JSONDictionaryCompletion = (_ data: [String: AnyObject]?, _ error: ErrorCode?) -> Void
    
    static func getCredentials() -> [String : String]? {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: "polPortal") as? [String: String] else {
            return nil
        }
        return dictionary
    }
    
    static func saveStateCredentials(state: String) {
        guard var credentials = Credentials.getCredentials() else {
            return
        }
        credentials["state"] = String(state[state.characters.index(before: state.endIndex)])
        try! Locksmith.updateData(data: credentials as [String : Any], forUserAccount: "polPortal")
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
    
    func saveCredentials(_ userDict: [String : AnyObject]) {
        var dict = credentialDict
        for (key, value) in userDict {
            dict[key] = value as? String
        }
        
        try! Locksmith.saveData(data: dict as [String : Any], forUserAccount: "polPortal")
    }
    
    static func deleteCredentials() -> Void {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "polPortal")
        } catch {
            
        }
    }
    
    func verifyCredentials(_ completion: @escaping (JSONDictionaryCompletion)) {
        let apiService = ApiService(apiString: apiInit)
        apiService.getApiUser(credentialDict){
            (JSONDictionary, error) in
            completion(JSONDictionary, error)
        }
        
    }
}
