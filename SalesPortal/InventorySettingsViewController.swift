//
//  SettingsViewController.swift
//  InventoryPortal
//
//  Created by administrator on 10/7/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit

let kMONTHPICKERTAG = 1
let kSTATEPICKERTAG = 2

class InventorySettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    weak var dataSettings: InventoryDataSettings?
    
    var settingLabels = [String]()
    //var settingPickers = [UIPickerView]()
    let settingTags = [kMONTHPICKERTAG, kSTATEPICKERTAG]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingLabels = ["Month", "State"]
        settingsTableView.rowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingLabels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCellWithIdentifier("SettingsTableCell", forIndexPath: indexPath) as! InventorySettingsTableViewCell
        let row = indexPath.row
        cell.settingsLabel.text = settingLabels[row]
        cell.settingsPicker.delegate = self
        cell.settingsPicker.dataSource = self
        cell.settingsPicker.tag = settingTags[row]
        if let myDataSettings = dataSettings {
            if settingTags[row] == kMONTHPICKERTAG {
                if let defaultMonthIndex = myDataSettings.monthValues.indexOf(myDataSettings.month) {                cell.settingsPicker.selectRow(defaultMonthIndex, inComponent: 0, animated: false)
                }
            } else if settingTags[row] == kSTATEPICKERTAG {
                if let defaultStateIndex = Constants.stateValues.indexOf(myDataSettings.repState) {
                    cell.settingsPicker.selectRow(defaultStateIndex, inComponent: 0, animated: false)
                }
            }
        }
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let myDataSettings = dataSettings {
            if pickerView.tag == kMONTHPICKERTAG {
                return myDataSettings.monthValues.count
            } else if pickerView.tag == kSTATEPICKERTAG {
                return Constants.stateValues.count
            }
        }
        return 0
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let myDataSettings = dataSettings {
            if pickerView.tag == kMONTHPICKERTAG {
                return myDataSettings.monthValues[row]
            } else if pickerView.tag == kSTATEPICKERTAG {
                return Constants.stateValues[row]
            }
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let myDataSettings = dataSettings {
            if pickerView.tag == kMONTHPICKERTAG {
                myDataSettings.month = myDataSettings.monthValues[row]
            } else if pickerView.tag == kSTATEPICKERTAG {
                myDataSettings.repState = Constants.stateValues[row]
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 24.0
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        if let myDataSettings = dataSettings {
            if pickerView.tag == kMONTHPICKERTAG {
                pickerLabel?.text = myDataSettings.monthValues[row]
            } else if pickerView.tag == kSTATEPICKERTAG {
                pickerLabel?.text = Constants.stateValues[row]
            }
        }
        return pickerLabel!;
    }
    
    //func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    //    return CGFloat(25.0)
    //}

}
