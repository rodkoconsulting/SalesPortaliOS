//
//  ShipDateViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/6/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniCalendarKit

protocol  ShipDateDelegate : class {
    func shipMonthChanged()
}

class ShipDateViewController: UIViewController, XuniCalendarDelegate {

  
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: XuniCalendar!
    
    weak var order : Order?
    weak var delegate: ShipDateDelegate?
    var currentDate: NSDate?
    var dateText: String = "Ship"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let order = order else {
            return
        }
        dateText = order.orderType == .PickUp ? "Pick Up" : "Ship"
        navigationBar.title = order.account.customerName
        calendar.delegate = self
        calendar.maxSelectionCount = 1
        if let minShipDate = order.minShipDate.getDate() {
            calendar.minDate = minShipDate
            calendar.maxDate = minShipDate.getMaxShipDate(order.account.shipDays)
        }
        calendar.selectedDate = order.shipDate.getDate()
        calendar.displayDate = calendar.selectedDate
        currentDate = calendar.selectedDate
        updateDateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        if let order  = order,
            let selectedDate = currentDate?.getDateShipString()  {
            let monthChanged = selectedDate.getShipMonth() != order.shipDate.getShipMonth()
            order.shipDate = selectedDate
            if monthChanged {
                delegate?.shipMonthChanged()
            }
        }
        performSegueWithIdentifier("unwindToOrderHeader", sender: self)
    }
    
    func updateDateLabel() {
        dateLabel.text = "\(dateText) Date: \(calendar.selectedDate.getDateShipPrint())"
    }
    
    func daySlotLoading(sender: XuniCalendar, args: XuniCalendarDaySlotLoadingEventArgs) {
        if (args.isAdjacentDay) {
            return
        }
        if args.date.isLessThanDate(calendar.minDate) || args.date.isGreaterThanDate(calendar.maxDate) {
            return
        }
        guard let order = order else {
            return
        }
        let shipIcon = args.date.isShipDay(order.account.shipDays) ? UIImage(named: "shipDay") : UIImage(named: "nonShipDay")
        let rect = args.daySlot.frame
        let size = rect.size
        var rect1: CGRect
        var rect2: CGRect
        let imageDaySlot = XuniCalendarImageDaySlot(calendar: sender, frame: rect)
        rect1 = CGRectMake(0, 0, size.width, size.height / 6 * 4)
        rect2 = CGRectMake(size.width / 2 - 6 / 2, size.height / 6 * 4, 6, 6)
        imageDaySlot.dayTextRect = rect1
        imageDaySlot.imageRect = rect2
        imageDaySlot.imageSource = shipIcon
        args.daySlot = imageDaySlot
    }

    func selectionChanging(sender: XuniCalendar!, args: XuniCalendarSelectionChangedEventArgs!) {
        guard let order = order else {
            return
        }
        let selectedDate = args.selectedDates.startDate
        if !selectedDate.isShipDay(order.account.shipDays) {
            calendar.displayDate = currentDate
            calendar.selectedDate = currentDate
            
        }
    }
    
    func selectionChanged(sender: XuniCalendar!, args: XuniCalendarSelectionChangedEventArgs!) {
        currentDate = calendar.selectedDate
        updateDateLabel()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
