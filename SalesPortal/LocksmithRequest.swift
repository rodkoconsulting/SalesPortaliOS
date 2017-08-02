//
//  LocksmithRequest.swift
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import UIKit
import Security

// With thanks to http://iosdeveloperzone.com/2014/10/22/taming-foundation-constants-into-swift-enums/

// MARK: Security Class
public enum SecurityClass: RawRepresentable {
    case genericPassword, internetPassword, certificate, key, identity
    static let allClasses = [genericPassword, internetPassword, certificate, key, identity]
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = .genericPassword
        case String(kSecClassInternetPassword):
            self = .internetPassword
        case String(kSecClassCertificate):
            self = .certificate
        case String(kSecClassKey):
            self = .key
        case String(kSecClassIdentity):
            self = .identity
        default:
            print("SecurityClass: Invalid raw value provided. Defaulting to .GenericPassword")
            self = .genericPassword
        }
    }
    
    public var rawValue: String {
        switch self {
        case .genericPassword:
            return String(kSecClassGenericPassword)
        case .internetPassword:
            return String(kSecClassInternetPassword)
        case .certificate:
            return String(kSecClassCertificate)
        case .key:
            return String(kSecClassKey)
        case .identity:
            return String(kSecClassIdentity)
        }
    }
}

// MARK: Accessible
public enum Accessible: RawRepresentable {
    case whenUnlocked, afterFirstUnlock, always, whenPasscodeSetThisDeviceOnly, whenUnlockedThisDeviceOnly, afterFirstUnlockThisDeviceOnly, alwaysThisDeviceOnly
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = .whenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = .afterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = .always
        case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):
            self = .whenPasscodeSetThisDeviceOnly
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = .whenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = .afterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = .alwaysThisDeviceOnly
        default:
            print("Accessible: invalid rawValue provided. Defaulting to Accessible.WhenUnlocked.")
            self = .whenUnlocked
        }
    }
    
    public var rawValue: String {
        switch self {
        case .whenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case .afterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case .always:
            return String(kSecAttrAccessibleAlways)
        case .whenPasscodeSetThisDeviceOnly:
            return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        case .whenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .afterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .alwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}

// MARK: Match Limit
public enum MatchLimit {
    case one, all
    @available(*, deprecated: 1.1.2, message: "Use .All instead.") case many
}

// MARK: Request Type
public enum RequestType {
    case create, read, update, delete
}

// MARK: Locksmith Request
open class LocksmithRequest: NSObject {
    // Keychain Options
    // Required
    open var service: String = LocksmithDefaultService
    open var userAccount: String?
    open var type: RequestType = .read  // Default to non-destructive
    
    // Optional
    open var securityClass: SecurityClass = .genericPassword  // Default to password lookup
    open var group: String?
    open var data: [String:AnyObject]?
    open var matchLimit: MatchLimit = .one
    open var synchronizable = false
    open var accessible: Accessible?
    
    required public init(userAccount: String?, service: String = LocksmithDefaultService) {
        self.service = service
        self.userAccount = userAccount
    }
    
    public convenience init(userAccount: String?, requestType: RequestType, service: String = LocksmithDefaultService) {
        self.init(userAccount: userAccount, service: service)
        self.type = requestType
    }
    
    public convenience init(userAccount: String, requestType: RequestType, data: [String: AnyObject], service: String = LocksmithDefaultService) {
        self.init(userAccount: userAccount, requestType: requestType, service: service)
        self.data = data
    }
}
