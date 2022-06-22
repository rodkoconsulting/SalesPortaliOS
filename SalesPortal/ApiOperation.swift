
import Foundation

enum ApiOperationEnum: String {
    case Clear = "C"
    case Update = "U"
    case Empty = "E"
    case Error = "Error"
}

class ApiOperation : NSObject, URLSessionDelegate {
    lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: Foundation.URLSession = Foundation.URLSession(configuration: self.config, delegate: self, delegateQueue:OperationQueue.main)
    let queryURL: URL
    let username: String
    let password: String
    
    typealias JSONDictionaryCompletion = (_ data: [String: AnyObject]?, _ error: ErrorCode?) -> Void
    typealias JSONPostCompletion = (_ success: Bool, _ error: ErrorCode?) -> Void
    
    init(url: URL, credentials: [String : String]){
        self.queryURL = url
        self.username = credentials["username"]!
        self.password = credentials["password"]!
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func uploadJSONToURL(_ jsonData: Data, completion: @escaping (JSONPostCompletion)) {
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)!
        let base64LoginString = loginData.base64EncodedString(options: [])
        let request: NSMutableURLRequest = NSMutableURLRequest(url: queryURL)
        request.setValue("Basic " + base64LoginString, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse/*, let data = data */ else {
                completion(false, ErrorCode.serverError)
                return
            }
            switch(httpResponse.statusCode){
            case 200:
                completion(true, nil)
            case 401:
                completion(false, ErrorCode.httpError(statusCode: 401))
            default:
                completion(false, ErrorCode.httpError(statusCode: httpResponse.statusCode as Int))
            }
        })
        dataTask.resume()
    }
    
    func downloadJSONFromURL(_ completion: @escaping (JSONDictionaryCompletion)) {
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)!
        let base64LoginString = loginData.base64EncodedString(options: [])
        let request: NSMutableURLRequest = NSMutableURLRequest(url: queryURL)
        request.setValue("Basic " + base64LoginString, forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(nil, ErrorCode.serverError)
                return
            }
            switch(httpResponse.statusCode){
            case 200:
                guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: AnyObject] else {
                    completion(nil, ErrorCode.serverError)
                    return
                }
                completion(jsonDictionary, nil)
            case 401:
                completion(nil, ErrorCode.httpError(statusCode: 401))
            default:
                completion(nil, ErrorCode.httpError(statusCode: httpResponse.statusCode as Int))
            }
        })
        dataTask.resume()
    }
}
