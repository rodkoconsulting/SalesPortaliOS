//
//  DataSettings.swift
//  InventoryPortal
//
//  Created by administrator on 10/7/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation

protocol InventoryDataSettingsDelegate: class {
    func changedDataSettings()
    func changedStateSettings()
}

class InventoryDataSettings {
    var monthValues = [String]()
    
    weak var delegate : InventoryDataSettingsDelegate?
    var date: String
    let shipDates = Date().getNextShip()
    var month: String {
        didSet {
            if month != oldValue {
                date = month == monthValues[0] ? Date().getNextShip().shipDate : Date().addWeek().getNextShip().shipDate
                delegate?.changedDataSettings()
            }
        }
    }
    
    var repState: States {
        didSet {
            if repState != oldValue {
                delegate?.changedDataSettings()
                delegate?.changedStateSettings()
            }
        }
    }
    
    init() {
        month = shipDates.shipMonth
        date = shipDates.shipDate
        let savedState = Credentials.getStateCredentials()
        repState = States(rawValue: savedState) ?? States.NY
        initMonths()
    }
    
    func initMonths() {
        let nextMonth = Date().getNextWeekMonth()
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
