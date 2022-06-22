
import Foundation

class SampleOrderHistoryViewController: OrderHistoryViewController {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        moduleType = Module.sampleOrderHistory
        classType = SampleOrderInventory.self
    }
}
