
import UIKit
import XuniCalendarKit

protocol  ShipDateDelegate : class {
    func shipMonthChanged()
}

class ShipDateViewController: UIViewController, XuniCalendarDelegate {

  
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendar: CalendarUI!
    
    weak var order : isOrderType?
    weak var delegate: ShipDateDelegate?
    var currentDate: Date?
    var dateText: String = "Ship"

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let order = order else {
            return
        }
        dateText = order.orderType == .PickUp ? "Pick Up" : "Ship"
        
        navigationBar.title = order.account?.customerName ?? "Sample"
        let shipDays = order.account?.shipDays ?? ShipDays.fullWeek
        calendar.delegate = self
        calendar.maxSelectionCount = 1
        if let minShipDate = order.minShipDate?.getDate() {
            calendar.minDate = minShipDate
            calendar.maxDate = minShipDate.getMaxShipDate(shipDays)
        }
        calendar.selectedDate = order.shipDate?.getDate()
        calendar.displayDate = calendar.selectedDate
        currentDate = calendar.selectedDate
        updateDateLabel()
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        if let order  = order,
            let selectedDate = currentDate?.getDateShipString()  {
            let monthChanged = selectedDate.getShipMonth() != order.shipDate?.getShipMonth()
            order.shipDate = selectedDate
            if monthChanged {
                delegate?.shipMonthChanged()
            }
        }
        self.dismiss(animated: false, completion: nil)
        //performSegue(withIdentifier: "unwindToOrderHeader", sender: self) 8/16/17
    }
    
    func updateDateLabel() {
        dateLabel.text = dateText + " Date: " + calendar.selectedDate.getDateShipPrint()
    }
    
    func daySlotLoading(_ sender: XuniCalendar, date: Date, isAdjacentDay: Bool, daySlot: XuniCalendarDaySlotBase) -> XuniCalendarDaySlotBase! {
        if isAdjacentDay {
            return daySlot
        }
        if date.isLessThanDate(calendar.minDate) || date.isGreaterThanDate(calendar.maxDate) {
            return daySlot
        }
        guard let order = order else {
            return daySlot
        }
        let shipIcon = date.isShipDay(order.account?.shipDays) ? UIImage(named: "shipDay") : UIImage(named: "nonShipDay")
        let rect = daySlot.frame
        let size = rect.size
        var rect1: CGRect
        var rect2: CGRect
        let imageDaySlot = XuniCalendarImageDaySlot(calendar: sender, frame: rect)
        rect1 = CGRect(x: 0, y: 0, width: size.width, height: size.height / 6 * 4)
        rect2 = CGRect(x: size.width / 2 - 6 / 2, y: size.height / 6 * 4, width: 6, height: 6)
        imageDaySlot?.dayTextRect = rect1
        imageDaySlot?.imageRect = rect2
        imageDaySlot?.imageSource = shipIcon
        return imageDaySlot
    }
    
    func selectionChanging(_ sender: XuniCalendar!, selectedDates: XuniCalendarRange!) {
        guard let order = order else {
            return
        }
        guard let selectedDate = selectedDates.startDate else {
            return
        }
        if !selectedDate.isShipDay(order.account?.shipDays) {
            calendar.selectedDate = currentDate
        }
    }
    
    func selectionChanged(_ sender: XuniCalendar!, selectedDates: XuniCalendarRange!) {
        currentDate = calendar.selectedDate
        updateDateLabel()
    }
    
    func displayDateChanging(_ sender: XuniCalendar!) {
        guard let order = order else {
            return
        }
        guard sender.selectedDate.isShipDay(order.account?.shipDays) else {
            calendar.selectedDate = currentDate
            return
        }
        currentDate = sender.selectedDate
        updateDateLabel()
    }
    
    func displayDateChanged(_ sender: XuniCalendar!) {
        calendar.refresh()
    }

}
