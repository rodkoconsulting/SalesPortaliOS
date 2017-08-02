//
//  ShipDateViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/6/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniCalendarKit

protocol FilterDateDelegate : class {
    func didChangeFilterDate(_ date: String, tag: Int)
}

class FilterDateViewController: UIViewController, XuniCalendarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: XuniCalendar!
    
    weak var delegate: FilterDateDelegate?
    
    var date : Date?
    var senderTag : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = "Filter Date"
        calendar.delegate = self
        calendar.maxSelectionCount = 1
        calendar.selectedDate = date
        calendar.displayDate = calendar.selectedDate
        updateDateLabel()
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        guard let tag = senderTag, let date = date else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        delegate?.didChangeFilterDate(date.getDateGridString(), tag: tag)
        self.dismiss(animated: false, completion: nil)
    }
    
    func updateDateLabel() {
        dateLabel.text =  calendar.selectedDate.getDateShipPrint()
    }
    
    func selectionChanged(_ sender: XuniCalendar!, selectedDates: XuniCalendarRange!) {
        date = calendar.selectedDate
        updateDateLabel()
    }
    
}
