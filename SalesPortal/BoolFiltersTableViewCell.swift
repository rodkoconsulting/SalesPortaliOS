
import UIKit
import XuniInputKit

class BoolFiltersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var operatorComboBox: ComboBox!
    @IBOutlet weak var conditionComboBox: ComboBox!
    @IBOutlet weak var boolComboBox: ComboBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
