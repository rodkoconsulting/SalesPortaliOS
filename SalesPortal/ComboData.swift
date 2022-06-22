
import Foundation

@objcMembers
class ComboData: NSObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    class func addressData(_ addresses: [isOrderAddress]) -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< addresses.count {
            let addressDisplay = "\(addresses[i].name): \(addresses[i].address)"
            let data = ComboData(name: addressDisplay)
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func orderTypeData() -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< OrderType.allValues.count {
            let data = ComboData(name: OrderType.allValues[i])
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func orderListFilterData() -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< OrderListFilter.rawValues.count {
            let data = ComboData(name: OrderListFilter.rawValues[i])
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func sampleListFilterData() -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< SampleListFilter.rawValues.count {
            let data = ComboData(name: SampleListFilter.rawValues[i])
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func monthData(_ months: [String]) -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< months.count {
            let data = ComboData(name: months[i])
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func coopNoData(_ coopNos: [String]?) -> NSMutableArray {
        let dataArray = NSMutableArray()
        guard let coopNos = coopNos else {
            return dataArray
        }
        dataArray.add(ComboData(name: "None"))
        for i in 0 ..< coopNos.count {
            let data = ComboData(name: coopNos[i])
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func stateData() -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< States.allValues.count {
            if let state = States(rawValue: States.allValues[i]) {
                let data = ComboData(name: state.labelText())
                dataArray.add(data)
            }
        }
        return dataArray
    }
    
    class func filterConditionData(_ conditionList: [String]) -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< conditionList.count {
                let data = ComboData(name: conditionList[i])
                dataArray.add(data)
        }
        return dataArray
    }
    
    class func filterOperatorData(_ operatorList: [FilterOperator]) -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< operatorList.count {
            let data = ComboData(name: operatorList[i].rawValue)
            dataArray.add(data)
        }
        return dataArray
    }
    
    class func filterBoolData() -> NSMutableArray {
        let dataArray = NSMutableArray()
        for i in 0 ..< Constants.boolList.count {
            let data = ComboData(name: Constants.boolList[i])
            dataArray.add(data)
        }
        return dataArray
    }

}
