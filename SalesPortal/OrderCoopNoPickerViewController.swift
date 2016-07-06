//
//  OrderTypePickerViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/9/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit

protocol OrderCoopNoDelegate: class {
    func changedCoopNo()
}

class OrderCoopNoPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var coopNoPicker: UIPickerView!
    
    @IBAction func doneSelected(sender: UIBarButtonItem) {
        if let currentPick = currentPick {
            if currentPick != Constants.noCoopText {
                order?.coopNo = currentPick
            } else {
                order?.coopNo = nil
            }
            delegate?.changedCoopNo()
            dismiss()
        }
    }
    
    @IBAction func cancelSelected(sender: AnyObject) {
        dismiss()
    }
    
    weak var order: Order?
    var currentPick: String?
    var coopList: [String] = []
    weak var delegate: OrderCoopNoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let coopList = order?.account.coopList {
            self.coopList = coopList
        }
        self.coopList.insert("None", atIndex: 0)
        currentPick = order?.coopNo ?? "None"
        coopNoPicker.delegate = self
        coopNoPicker.dataSource = self
        coopNoPicker.backgroundColor = UIColor.lightGrayColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let orderCoopNo = order?.coopNo, let orderCoopNoIndex = coopList.indexOf(orderCoopNo) {
            coopNoPicker.selectRow(orderCoopNoIndex, inComponent: 0, animated: false)
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
        return coopList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coopList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPick = coopList[row]
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
 }
