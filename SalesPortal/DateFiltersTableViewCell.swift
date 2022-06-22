
import UIKit
import XuniInputKit

class DateFiltersTableViewCell: UITableViewCell {

    @IBOutlet weak var operatorComboBox: ComboBox!
    @IBOutlet weak var conditionComboBox: ComboBox!
    @IBOutlet weak var dateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
