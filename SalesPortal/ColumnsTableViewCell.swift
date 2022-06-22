
import UIKit

protocol ColumnCellDelegate : class {
    func didChangeSwitchState(_ sender: ColumnsTableViewCell, isOn: Bool)
}

class ColumnsTableViewCell: UITableViewCell {

    @IBOutlet weak var columnsLabel: UILabel!
    @IBOutlet weak var columnsSwitch: UISwitch!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var filterImage: UIImageView!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        self.switchDelegate?.didChangeSwitchState(self, isOn:columnsSwitch.isOn)
        setStateLabel()
    }
    
    weak var switchDelegate: ColumnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setStateLabel() {
        stateLabel.text = columnsSwitch.isOn ? "Visible" : "Hidden"
        stateLabel.textColor = columnsSwitch.isOn ? UIColor.black : UIColor.red
    }
}
