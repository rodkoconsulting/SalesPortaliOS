//
//  SampleOrderAddressService.swift
//  SalesPortal
//
//  Created by administrator on 1/23/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

class OrderAddressService {
    
    class func getAddressList() -> [OrderAddress]? {
        let dB = FMDatabase(path: Constants.databasePath)
        var addressList = [OrderAddress]()
        if dB.open() {
            let sqlQuery =
                "SELECT CODE, REP, NAME, ADDRESS, REGION FROM SAMPLE_ADDRESSES WHERE IS_REP = 1 AND IS_ACTIVE = 1"
            let results:FMResultSet? = dB.executeQuery(sqlQuery, withArgumentsIn: nil)
            while results?.next() == true {
                addressList.append(OrderAddress(queryResult: results!))
            }
            dB.close()
        }
        return addressList.count > 0 ? addressList : nil
    }
}
