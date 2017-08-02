//
//  Locksmith.swift
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import CoreFoundation
import UIKit
import Security

public let LocksmithDefaultService = Bundle.main.infoDictionary![String(kCFBundleIdentifierKey)] as? String ?? "com.locksmith.defaultService"
/// This key is used to index the result of `performRequest` when there are multiple results.
/// An NSArray of the matching `[String: AnyObject]`s will be provided under this key.
public let LocksmithMultipleResultsKey = "locksmith_multiple_results_key"

// MARK: Locksmith Error
public enum LocksmithError: String, Error {
    case Allocate = "Failed to allocate memory."
    case AuthFailed = "Authorization/Authentication failed."
    case Decode = "Unable to decode the provided data."
    case Duplicate = "The item already exists."
    case InteractionNotAllowed = "Interaction with the Security Server is not allowed."
    case NoError = "No error."
    case NotAvailable = "No trust results are available."
    case NotFound = "The item cannot be found."
    case Param = "One or more parameters passed to the function were not valid."
    case RequestNotSet = "The request was not set"
    case TypeNotFound = "The type was not found"
    case UnableToClear = "Unable to clear the keychain"
    case Undefined = "An undefined error occurred"
    case Unimplemented = "Function or operation not implemented."
    
    init?(fromStatusCode code: Int) {
        switch code {
        case Int(errSecAllocate):
            self = .Allocate
        case Int(errSecAuthFailed):
            self = .AuthFailed
        case Int(errSecDecode):
            self = .Decode
        case Int(errSecDuplicateItem):
            self = .Duplicate
        case Int(errSecInteractionNotAllowed):
            self = .InteractionNotAllowed
        case Int(errSecItemNotFound):
            self = .NotFound
        case Int(errSecNotAvailable):
            self = .NotAvailable
        case Int(errSecParam):
            self = .Param
        case Int(errSecUnimplemented):
            self = .Unimplemented
        default:
            return nil
        }
    }
}

// MARK: Locksmith
open class Locksmith: NSObject {
    // MARK: Perform request
    open class func performRequest(_ request: LocksmithRequest) throws -> [String: AnyObject]? {
        let type = request.type
        var result: AnyObject?
        var optionalStatus: OSStatus?
        let parsedRequest: NSMutableDictionary = parseRequest(request)
        let requestReference = parsedRequest as CFDictionary

        switch type {
        case .create:
            optionalStatus = withUnsafeMutablePointer(to: &result) { SecItemAdd(requestReference, UnsafeMutablePointer($0)) }
        case .read:
            optionalStatus = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(requestReference, UnsafeMutablePointer($0)) }
        case .delete:
            optionalStatus = SecItemDelete(requestReference)
        case .update:
            optionalStatus =  Locksmith.performUpdate(requestReference, result: &result)
        }
        
        guard let unwrappedStatus = optionalStatus else {
            throw LocksmithError.TypeNotFound
        }
        
        let statusCode = Int(unwrappedStatus)
        if let error = LocksmithError(fromStatusCode: statusCode) {
            throw error
        }
        
        var resultsDictionary: [String: AnyObject]?
        
        if type == .read && unwrappedStatus == errSecSuccess {
            if request.matchLimit == .all {
                if let results = result as? NSArray {
                    resultsDictionary = [String: AnyObject]()
                    
                    let convertedResults = results.map({ (i) -> [String: AnyObject]? in
                        return Locksmith.dataToDictionary(i as AnyObject)
                    }).flatMap { $0 }
                    
                    resultsDictionary![LocksmithMultipleResultsKey] = convertedResults as AnyObject
                }
            } else {
                resultsDictionary = Locksmith.dataToDictionary(result)
            }
        }
        
        return resultsDictionary
    }
    
    fileprivate class func dataToDictionary(_ data: AnyObject?) -> [String: AnyObject]? {
        var resultsDictionary: [String: AnyObject]?
        if let data = data as? Data {
            // Convert the retrieved data to a dictionary
            resultsDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: AnyObject]
        }
        return resultsDictionary
    }
    
    // MARK: Private methods
    fileprivate class func performUpdate(_ request: CFDictionary, result: inout AnyObject?) -> OSStatus {
        // We perform updates to the keychain by first deleting the matching object, then writing to it with the new value.
        SecItemDelete(request)
        
        // Even if the delete request failed (e.g. if the item didn't exist before), still try to save the new item.
        // If we get an error saving, we'll tell the user about it.
        let status: OSStatus = withUnsafeMutablePointer(to: &result) { SecItemAdd(request, UnsafeMutablePointer($0)) }
        return status
    }
    
    fileprivate class func parseRequest(_ request: LocksmithRequest) -> NSMutableDictionary {
        var parsedRequest = NSMutableDictionary()
        
        var options = [String: AnyObject?]()
        options[String(kSecAttrAccount)] = request.userAccount as AnyObject
        options[String(kSecAttrAccessGroup)] = request.group as AnyObject
        options[String(kSecAttrService)] = request.service as AnyObject
        options[String(kSecAttrSynchronizable)] = request.synchronizable as AnyObject
        options[String(kSecClass)] = request.securityClass.rawValue as AnyObject
        
        if let accessibleMode = request.accessible {
            options[String(kSecAttrAccessible)] = accessibleMode.rawValue as AnyObject
        }
        
        for (key, option) in options {
            parsedRequest.setOptional(option, forKey: key as NSCopying)
        }
        
        switch request.type {
        case .create:
            parsedRequest = parseCreateRequest(request, inDictionary: parsedRequest)
        case .delete:
            parsedRequest = parseDeleteRequest(request, inDictionary: parsedRequest)
        case .update:
            parsedRequest = parseCreateRequest(request, inDictionary: parsedRequest)
        default: // case .Read:
            parsedRequest = parseReadRequest(request, inDictionary: parsedRequest)
        }
        
        return parsedRequest
    }
    
    fileprivate class func parseCreateRequest(_ request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        
        if let data = request.data {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
            dictionary.setObject(encodedData, forKey: String(kSecValueData))
        }
        
        return dictionary
    }
    
    
    fileprivate class func parseReadRequest(_ request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        dictionary.setOptional(kCFBooleanTrue, forKey: String(kSecReturnData))
        
        switch request.matchLimit {
        case .one:
            dictionary.setObject(kSecMatchLimitOne, forKey: String(kSecMatchLimit))
        case .many, .all:
            dictionary.setObject(kSecMatchLimitAll, forKey: String(kSecMatchLimit))
        }
        
        return dictionary
    }
    
    fileprivate class func parseDeleteRequest(_ request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        return dictionary
    }
}

// MARK: Convenient Class Methods
extension Locksmith {
    public class func saveData(_ data: [String: AnyObject], forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) throws {
        let saveRequest = LocksmithRequest(userAccount: userAccount, requestType: .create, data: data, service: service)
        try Locksmith.performRequest(saveRequest)
    }
    
    public class func loadDataForUserAccount(_ userAccount: String, inService service: String = LocksmithDefaultService) -> [String: AnyObject]? {
        let readRequest = LocksmithRequest(userAccount: userAccount, service: service)
        
        do {
            let dictionary = try Locksmith.performRequest(readRequest)
            return dictionary
        } catch {
            return nil
        }
    }
    
    public class func deleteDataForUserAccount(_ userAccount: String, inService service: String = LocksmithDefaultService) throws {
        let deleteRequest = LocksmithRequest(userAccount: userAccount, requestType: .delete, service: service)
        try Locksmith.performRequest(deleteRequest)
    }
    
    public class func updateData(_ data: [String: AnyObject], forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) throws {
        let updateRequest = LocksmithRequest(userAccount: userAccount, requestType: .update, data: data, service: service)
        try Locksmith.performRequest(updateRequest)
    }
    
    public class func clearKeychain() throws {
        // Delete all of the keychain data of the given class
        func deleteDataForSecClass(_ secClass: CFTypeRef) throws {
            let request = NSMutableDictionary()
            request.setObject(secClass, forKey: String(kSecClass))
            
            let status: OSStatus? = SecItemDelete(request as CFDictionary)
            
            if let status = status {
                let statusCode = Int(status)
                if let error = LocksmithError(fromStatusCode: statusCode) {
                    throw error
                }
            }
        }
        
        // For each of the sec class types, delete all of the saved items of that type
        let classes = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        
        for classType in classes {
            do {
                try deleteDataForSecClass(classType)
            } catch let error as LocksmithError {
                // There was an error
                // If the error indicates that there was no item with that security class, that's fine.
                // Some of the sec classes will have nothing in them in most cases.
                if error != LocksmithError.NotFound {
                    throw LocksmithError.UnableToClear
                }
            }
        }
    }
    
    /// Returns all the data for a given service.
    /// :param: service The service to load data for. This may be omitted, and the default service will be used.
    /// :return: An array of dictionaries corresponding to all of the results for this service.
    public class func loadAllDataForService(_ service: String = LocksmithDefaultService) throws -> [[String: AnyObject]]? {
        var resultForAllSecurityClasses = [[String: AnyObject]?]()
        
        // TODO: Switch to `allClasses`
        let classes = [SecurityClass.genericPassword]
        
        for classType in classes {
            let request = LocksmithRequest(userAccount: nil, service: "myService")
            request.matchLimit = .all
            request.securityClass = classType
            
            if let result = try Locksmith.performRequest(request) {
                let array = result[LocksmithMultipleResultsKey] as? [[String: AnyObject]]
                array?.forEach({ (dict) -> () in
                    resultForAllSecurityClasses.append(dict)
                })
            }
        }
        
        return resultForAllSecurityClasses.flatMap{ $0 }
    }
}

// MARK: Dictionary Extension
extension NSMutableDictionary {
    func setOptional(_ optional: AnyObject?, forKey key: NSCopying) {
        if let object: AnyObject = optional {
            self.setObject(object, forKey: key)
        }
    }
}
