
import Foundation

enum ApiOperationEnum: String {
    case Clear = "C"
    case Update = "U"
    case Empty = "E"
    case Error = "Error"
}

class ApiOperation : NSObject, NSURLSessionDelegate {
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
    let queryURL: NSURL
    let username: String
    let password: String
    
    typealias JSONDictionaryCompletion = (data: [String: AnyObject]?, error: ErrorCode?) -> Void
    
    init(url: NSURL, credentials: [String : String]){
        self.queryURL = url
        self.username = credentials["username"]!
        self.password = credentials["password"]!
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    func downloadJSONFromURL(completion: (JSONDictionaryCompletion)) {
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: queryURL)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTaskWithRequest(request){
            (let data, let response, let error) in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                completion(data: nil, error: ErrorCode.ServerError)
                return
            }
            switch(httpResponse.statusCode){
            case 200:
                let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? [String: AnyObject]
                completion(data: jsonDictionary, error: nil)
            case 401:
                completion(data: nil, error: ErrorCode.HttpError(statusCode: 401))
            default:
                completion(data: nil, error: ErrorCode.HttpError(statusCode: httpResponse.statusCode as Int))
            }
        }
        dataTask.resume()
    }
}