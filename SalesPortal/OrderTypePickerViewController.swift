//
//  OrderTypePickerViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/9/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit


class OrderTypePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, OrderTypeErrorDelegate {

    
    @IBOutlet weak var orderTypePicker: UIPickerView!
    
    @IBAction func doneSelected(sender: UIBarButtonItem) {
        if let currentPick = currentPick {
            order?.orderType = currentPick
            if !alertIsDisplaying{
                dismiss()
            }
        }
    }
    
    @IBAction func cancelSelected(sender: AnyObject) {
            dismiss()
    }
    
    weak var order: Order?
    var currentPick: OrderType?
    var alertIsDisplaying: Bool = false
    
    func sendAlert(error: ErrorCode) {
        alertIsDisplaying = true
        let alertController = UIAlertController(title: "Error!", message: "\(error)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in self.dismiss()})
        alertController.addAction(ok)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTypePicker.delegate = self
        orderTypePicker.dataSource = self
        orderTypePicker.backgroundColor = UIColor.lightGrayColor()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let orderTypeValue = order?.orderType.rawValue, let orderTypeIndex = OrderType.allValues.indexOf(orderTypeValue) {
            orderTypePicker.selectRow(orderTypeIndex, inComponent: 0, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return OrderType.allValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return OrderType.allValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPick = OrderType(rawValue: OrderType.allValues[row])
    }
    
    
    func dismiss() {
        performSegueWithIdentifier("unwindToOrderHeader", sender: nil)
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
