
import UIKit
import XuniInputKit

let kMONTHTAG = 1
let kSTATETAG = 2

class InventorySettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XuniDropDownDelegate, XuniComboBoxDelegate  {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    weak var dataSettings: InventoryDataSettings?
    
    var settingLabels = [String]()
    let settingTags = [kMONTHTAG, kSTATETAG]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingLabels = ["Month", "State"]
        settingsTableView.rowHeight = 100
        settingsTableView.allowsSelection = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitVc()
    }

    func exitVc() {
        for row in 0 ..< settingsTableView.numberOfRows(inSection: 0) {
            let cell = settingsTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! InventorySettingsTableViewCell
            cell.settingsComboBox.selectedItem = nil
            cell.settingsComboBox.itemsSource.removeAllObjects()
            cell.settingsComboBox.collectionView.removeAllObjects()
            cell.settingsComboBox.delegate = nil
            cell.settingsComboBox = nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingLabels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! InventorySettingsTableViewCell
        let row = indexPath.row
        cell.settingsLabel.text = settingLabels[row]
        cell.settingsComboBox.delegate = self
        cell.settingsComboBox.displayMemberPath = "name"
        cell.settingsComboBox.isEditable = false
        cell.settingsComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        cell.settingsComboBox.tag = settingTags[row]
        if let myDataSettings = dataSettings {
            if settingTags[row] == kMONTHTAG {
                cell.settingsComboBox.itemsSource = ComboData.monthData(myDataSettings.monthValues)
                if let defaultMonthIndex = myDataSettings.monthValues.firstIndex(of: myDataSettings.month) {
                    cell.settingsComboBox.selectedIndex = UInt(myDataSettings.monthValues.distance(from: myDataSettings.monthValues.startIndex, to: defaultMonthIndex))
                }
            } else if settingTags[row] == kSTATETAG {
                cell.settingsComboBox.itemsSource = ComboData.stateData()
                if let defaultStateIndex = States.allValues.firstIndex(of: myDataSettings.repState.rawValue) {
                    cell.settingsComboBox.selectedIndex = UInt(States.allValues.distance(from: States.allValues.startIndex, to: defaultStateIndex))
                }
            }
            cell.settingsComboBox.dropDownHeight = Double(cell.settingsComboBox.itemsSource.count * Constants.ComboCellHeight)
        }
        return cell
    }
    
    func selectedIndexChanged(_ sender: XuniComboBox!) {
        if let myDataSettings = dataSettings {
            if sender.tag == kMONTHTAG {
                myDataSettings.month = myDataSettings.monthValues[Int(sender.selectedIndex)]
            } else if sender.tag == kSTATETAG {
                myDataSettings.repState = States(rawValue:States.allValues[Int(sender.selectedIndex)]) ?? States.NY
            }
        }
    }
}
