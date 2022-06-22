
import UIKit
import XuniInputKit

class InventorySettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsLabel: UILabel!                                                                                                              
    @IBOutlet weak var settingsComboBox: ComboBox!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
