//
//  DateFiltersTableViewCell.swift
//  InventoryPortal
//
//  Created by administrator on 12/14/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import UIKit

protocol DatePickerDelegate : class {
    func didChangePickerDate(sender sender: UIDatePicker, date: String)
}

class DateFiltersTableViewCell: UITableViewCell, UIPickerViewDelegate  {

    @IBOutlet weak var operatorPicker: UIPickerView!
    @IBOutlet weak var conditionPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func dateChanged(sender: AnyObject) {
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "M/d/yy"
        //let date = dateFormatter.stringFromDate(datePicker.date)
        let date = datePicker.date.getDateGridString()
        self.delegate?.didChangePickerDate(sender: datePicker, date: date)
    }
    
}
