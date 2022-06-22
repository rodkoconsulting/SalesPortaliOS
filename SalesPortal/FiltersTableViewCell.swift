
import UIKit
import XuniInputKit

class FiltersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var conditionComboBox: ComboBox!
    @IBOutlet weak var operatorComboBox: ComboBox!
    @IBOutlet weak var valueText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
