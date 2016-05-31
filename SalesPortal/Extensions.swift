//
//  Dates.swift
//  InventoryPortal
//
//  Created by administrator on 10/12/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation

enum DateStrings : String {
    case PoDate = "10001231"
    case PoEtaDate = "19991231"
}

extension String {
    func getGridDate() -> NSDate? {
        return NSDateFormatter.dateGridFormatter.dateFromString(self)
    }
    
    func getDate() -> NSDate? {
        return NSDateFormatter.dateFormatter.dateFromString(self)
    }
}

extension NSDateFormatter {
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    private static let dateShipFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    private static let dateTimeFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yy h:mm a"
        return formatter
    }()
    
    private static let monthFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private static let dateGridFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yy"
        return formatter
    }()

}

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
    }
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
    }
    
    func isAfterHours() -> Bool
    {
        var hour: Int = 0
        var minute: Int = 0
        NSCalendar.currentCalendar().getHour(&hour, minute: &minute, second: nil, nanosecond: nil, fromDate:self)
        return hour > Constants.hourCutoff || (hour > (Constants.hourCutoff - 1) && minute > Constants.minuteCutoff)
    }
    
    func addDay() -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func addWeek() -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 7, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func isHoliday() -> Bool {
        guard let path = NSBundle.mainBundle().pathForResource("Holidays", ofType: "plist"),
            let holidayDict = NSDictionary(contentsOfFile: path),
            let holidays = holidayDict["Holidays"] as? [NSDate] else {
                return false
        }
        for holiday in holidays {
            if NSCalendar.currentCalendar().isDate(self, inSameDayAsDate: holiday) {
                return true
            }
        }
        return false
    }

    func isWeekendOrHoliday() -> Bool {
        return NSCalendar.currentCalendar().isDateInWeekend(self) || isHoliday()
    }
    
    func getDateString() -> String {
        return NSDateFormatter.dateFormatter.stringFromDate(self)
    }
    
    func getDateShipString() -> String {
        return NSDateFormatter.dateShipFormatter.stringFromDate(self)
    }
    
    func getDateGridString() -> String {
        return NSDateFormatter.dateGridFormatter.stringFromDate(self)
    }
    
    func getDateTimeString() -> String {
        return NSDateFormatter.dateTimeFormatter.stringFromDate(self)
    }
    
    func getMonthString() -> String {
        return NSDateFormatter.monthFormatter.stringFromDate(self)
    }
    
    func getYearInt() -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self).year
    }
    
    func getNextWeekMonth() -> String {
        return self.addWeek().getMonthString()
    }
    
   func getNextShip() -> (shipDate: String, shipMonth: String) {
        var shipDate = self
        if shipDate.isAfterHours() {
            shipDate = shipDate.addDay()
        }
        while shipDate.isWeekendOrHoliday() {
            shipDate = shipDate.addDay()
        }
        shipDate = shipDate.addDay()
        while shipDate.isWeekendOrHoliday() {
            shipDate = shipDate.addDay()
        }
        return (shipDate.getDateShipString(), shipDate.getMonthString())
    }

    class func defaultPoDate() -> NSDate {
        return NSDateFormatter.dateFormatter.dateFromString(DateStrings.PoDate.rawValue)!
    }
    
    class func defaultPoEtaDate() -> NSDate {
        return NSDateFormatter.dateFormatter.dateFromString(DateStrings.PoEtaDate.rawValue)!
    }
}
