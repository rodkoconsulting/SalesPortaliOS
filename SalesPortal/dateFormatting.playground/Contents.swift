//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let dateTestString = "2016-02-01 05:00:00 +0000"

extension NSDateFormatter {
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    private static let dateConvertedFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss ZZZZ"
        return formatter
    }()
    
    
    private static let dateShipFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    private static let dateShipPrintFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE M/d/yy"
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
    
    func getDateShipPrint() -> String {
        return NSDateFormatter.dateShipPrintFormatter.stringFromDate(self)
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
}

extension String {
    func getGridDate() -> NSDate? {
        if self.containsString("+") {
            return NSDateFormatter.dateConvertedFormatter.dateFromString(self)
        }
        return NSDateFormatter.dateGridFormatter.dateFromString(self)
    }
    
    func getGridDateString() -> String {
        return self.getDate()?.getDateGridString() ?? ""
    }
    
    func getShipDatePrint() -> String {
        return self.getDate()?.getDateShipPrint() ?? ""
    }
    
    func getDate() -> NSDate? {
        return NSDateFormatter.dateFormatter.dateFromString(self)
    }
    
    func getShipDate() -> NSDate? {
        return NSDateFormatter.dateShipFormatter.dateFromString(self)
    }
    
    func getShipMonth() -> String? {
        return self.getDate()?.getMonthString()
    }
}

let dateTestDate = dateTestString.getGridDate()


let testDict = ["test1" : "value1"]

var newDict = testDict

newDict["test1"] = "value2"

testDict["test1"]

newDict["test1"]

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func rounded()-> Double
    {
        return (round(self*10000)/10000).truncate(0)
    }
}

let test = 1.83333 * 12
let test2 = Int(test.rounded())

let quantity = 0.67
let uomInt = 12




let num = (quantity * Double(uomInt))
(round(num*10)/10).truncate(0)
(quantity * Double(uomInt)).rounded()
Int((quantity * Double(uomInt)).rounded())


let totalbottles = 11

let cases = totalbottles / uomInt

let bottles = totalbottles - (cases * uomInt)

