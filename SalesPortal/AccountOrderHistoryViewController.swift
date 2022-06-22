
import Foundation

class AccountOrderHistoryViewController: OrderHistoryViewController, isOrderHistoryVc {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.accountOrderHistory
        classType = AccountOrderInventory.self
    }
    
    override func setAccountInventoryDelegate(_ orderInventory: OrderInventory) {
        if let accountOrderInventory = orderInventory as? AccountOrderInventory,
            let accountOrder = order as? AccountOrder {
                accountOrderInventory.delegate = accountOrder
                accountOrderInventory.orderType = order?.orderType
        }
    }
}
