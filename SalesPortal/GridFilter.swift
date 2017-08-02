//
//  GridFilter.swift
//  InventoryPortal
//
//  Created by administrator on 11/20/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation
//import XuniFlexGridKit

enum FilterOperator : String {
    case And = "And"
    case Or = "Or"
    
    static let allValues = [And, Or]
}

enum FilterType : String {
    case String = "String"
    case Number = "Number"
    case Date = "NumberDate"
    case Bool = "StringBool"
}

enum StringCondition : String {
    case Contains = "Contains"
    case NotContains = "Not Contains"
    case StartsWith = "Starts With"
    case EndsWith = "Ends With"
    case Equals = "Equals"
    case NotEquals = "Not Equals"

    static let allValues = [Contains.rawValue, NotContains.rawValue, StartsWith.rawValue, EndsWith.rawValue, Equals.rawValue, NotEquals.rawValue]
    
    func isMatched(text: String, filterText: String) -> Bool {
        switch self {
        case .Contains:
            return text.range(of: filterText) != nil
        case .NotContains:
            return text.range(of: filterText) == nil
        case .StartsWith:
            return text.hasPrefix(filterText)
        case .EndsWith:
            return text.hasSuffix(filterText)
        case .Equals:
            return text == filterText
        case .NotEquals:
            return text != filterText
        }
    }
}

enum NumberCondition : String {
    case Equals = "Equals"
    case Greater = "Greater"
    case GreaterEquals = "Greater/Equals"
    case Less = "Less"
    case LessEquals = "Less/Equals"
    case NotEquals = "Not Equals"
    
    static let allValues = [Equals.rawValue, Greater.rawValue, GreaterEquals.rawValue, Less.rawValue, LessEquals.rawValue, NotEquals.rawValue]
    
    func isMatched(number: Double, filterNumber: Double) -> Bool {
        switch self {
        case .Equals:
            if number == filterNumber {
                return true
            }
        case .Greater:
            if number > filterNumber {
                return true
            }
        case .GreaterEquals:
            if number >= filterNumber {
                return true
            }
        case .Less:
            if number < filterNumber {
                return true
            }
        case .LessEquals:
            if number <= filterNumber {
                return true
            }
        case .NotEquals:
            if number != filterNumber {
                return true
            }
        }
        return false
    }
}

enum DateCondition : String {
    case Equals = "Equals"
    case Greater = "Greater"
    case Less = "Less"
    
    static let allValues = [Equals.rawValue, Greater.rawValue, Less.rawValue]
    
    func isMatched(date: Date, filterDate: Date) -> Bool {
        switch self {
        case .Equals:
            if date == filterDate {
                return true
            }
        case .Greater:
            if date.isGreaterThanDate(filterDate)  {
                return true
            }
        case .Less:
            if date.isLessThanDate(filterDate) {
                return true
            }
        }
        return false
    }
}

enum BoolCondition: String {
    case Equals = "Equals"
    
    static let allValues = [Equals.rawValue]
}


class ColumnFilter : NSObject {
    var value : String = ""
    var filterOperator : FilterOperator = FilterOperator.And
    var condition : String

    init(condition: String) {
        self.condition = condition
    }
    
    func getStringResult(value: String) -> Bool {
        let text = value.lowercased()
        let filterText = self.value.lowercased()
        guard let condition = StringCondition(rawValue: self.condition) else {
            return false
        }
        return condition.isMatched(text: text, filterText: filterText)
    }
    
    func getNumberResult(value: String) -> Bool {
        guard let number = Double(value),
            let filterNumber = Double(self.value),
            let condition = NumberCondition(rawValue: self.condition) else {
                return false
        }
        return condition.isMatched(number: number, filterNumber: filterNumber)
    }
    
    func getDateResult(value: String) -> Bool {
            guard let date = value.getGridDate(),
                    let filterDate = self.value.getGridDate(),
                    let condition = DateCondition(rawValue: self.condition) else {
                return false
            }
        return condition.isMatched(date: date as Date, filterDate: filterDate as Date)
        }
    
    func getBoolResult(value: String) -> Bool {
        let boolValue = (value as NSString).boolValue
        let filterValue = (self.value as NSString).boolValue
        return filterValue == boolValue
    }

    
    func getResult(value: String, filterType: FilterType) -> Bool {
        switch filterType {
        case .String:
                return getStringResult(value: value)
        case .Number:
                return getNumberResult(value: value)
        case .Date:
            return getDateResult(value: value)
        case .Bool:
            return getBoolResult(value: value)
        }
    }
    
}

class ColumnFilters : NSObject {
    
    var filterType: FilterType = FilterType.String
    var header: String
    var filterList : [ColumnFilter] = [ColumnFilter]()
    var operatorList: [FilterOperator] = FilterOperator.allValues
    var conditionList : [String] {
        get {
            switch filterType {
                case .String:
                    return StringCondition.allValues
                case .Number:
                    return NumberCondition.allValues
                case .Date:
                    return DateCondition.allValues
                case .Bool:
                    return BoolCondition.allValues
            }
        }
    }
    
    
    init(header: String) {
        self.header = header
    }
    
    func getFilterResults(_ filterTuple: [(filterBool: Bool, filterOperator: FilterOperator)]) -> Bool {
        var filterResults = filterTuple.first!.filterBool
        guard filterTuple.count > 1  else {
            return filterResults
        }
        for filter in 0...filterTuple.count - 1 {
            let filterBool = filterTuple[filter].filterBool
            let filterOperator = filterTuple[filter].filterOperator
            filterResults = filterOperator == FilterOperator.And ? filterResults && filterBool : filterResults || filterBool
        }
        return filterResults
    }

}
