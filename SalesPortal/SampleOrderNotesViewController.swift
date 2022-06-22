
import UIKit
import XuniInputKit

class SampleOrderNotesViewController: OrderNotesViewController, isOrderNotesVc  {
    
    override func callChildViewDidLoad() {
        navigationBar.title = "Sample Notes"
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        maxLength = 30
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    override func callChildDismiss() {

    }

    override func callChildInitNotes() {
    
    }
}
