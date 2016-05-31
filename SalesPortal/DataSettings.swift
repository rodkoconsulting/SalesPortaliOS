//
//  DataSettings.swift
//  InventoryPortal
//
//  Created by administrator on 10/7/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation

protocol InventoryDataSettingsDelegate {
    func changedDataSettings()
    func changedStateSettings()
}

class InventoryDataSettings {
    var monthValues = [String]()
    
    var delegate : InventoryDataSettingsDelegate?
    var date: String
    let shipDates = NSDate().getNextShip()
    var month: String {
        didSet {
            delegate?.changedDataSettings()
        }
    }
    
    var repState: String{
        didSet {
            delegate?.changedDataSettings()
            delegate?.changedStateSettings()
        }
    }
    
    init() {
        month = shipDates.shipMonth
        date = shipDates.shipDate
        repState = "N\(Credentials.getStateCredentials())"
        initMonths()
    }
    
    func initMonths() {
        let nextMonth = NSDate().getNextWeekMonth()
        monthValues.append(month)
        if nextMonth != month {
            monthValues.append(nextMonth)
        }
    }
    
    func refreshDates() {
        monthValues.removeAll()
        initMonths()
    }
    
    
    
}