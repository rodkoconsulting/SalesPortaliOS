//
//  SampleOrderAddressService.swift
//  SalesPortal
//
//  Created by administrator on 1/23/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

class SampleOrderAddressService {
    
    class func getAddressList() -> [SampleOrderAddress]? {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return nil
        }
        var addressList = [SampleOrderAddress]()
        if dB.open() {
            let sqlQuery =
                "SELECT CODE, REP, NAME, ADDRESS, REGION FROM SAMPLE_ADDRESSES WHERE IS_REP = 'true' AND IS_ACTIVE = 'true'"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                addressList.append(SampleOrderAddress(queryResult: results!))
            }
            dB.close()
        }
        return addressList.count > 0 ? addressList : nil
    }
}

class AccountOrderAddressService {
    
    class func getAddressList(account: Account) -> (list: [AccountOrderAddress]?, primary: AccountOrderAddress?) {
        guard let dB = FMDatabase(path: Constants.databasePath) else {
            return (nil, nil)
        }
        var addressList = [AccountOrderAddress]()
        var primaryAddress : AccountOrderAddress?
        if dB.open() {
            let sqlQuery =
            "SELECT CODE, NAME, ADDRESS FROM ACCOUNT_ADDRESSES WHERE DIVISION_NO = '\(account.divisionNo)' AND CUSTOMER_NO = '\(account.customerNoRaw)'"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                let address = AccountOrderAddress(queryResult: results!)
                addressList.append(address)
                if (account.shipTo == address.code) {
                    primaryAddress = address
                }
            }
            dB.close()
        }
        return addressList.count > 0 ? (addressList, primaryAddress) : (nil, nil)
    }
}
