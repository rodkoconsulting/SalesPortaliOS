//
//  OrderNotesViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/14/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit

class OrderNotesViewController: UIViewController, OrderCoopNoDelegate  {

    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var poNoTextField: UITextField!
    @IBOutlet weak var coopNoButton: UIButton!
    @IBOutlet weak var coopNoLabel: UILabel!
    @IBOutlet weak var coopCasesLabel: UILabel!
    @IBOutlet weak var coopCasesControl: UISegmentedControl!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    weak var order: Order?
    
    @IBAction func coopCasesChanged(sender: AnyObject) {
        if let _ =  order?.coopNo {
            order?.coopCases = Constants.coopCaseList[  coopCasesControl.selectedSegmentIndex]
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        guard let order = order else {
            performSegueWithIdentifier("unwindToHeader", sender: self)
            return
        }
        order.notes = notesTextField.text
        order.poNo = poNoTextField.text
        performSegueWithIdentifier("unwindToHeader", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = order?.account.customerName
        initNotes()
        // Do any additional setup after loading the view.
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOrderCoopNoPickerVC" {
            guard let orderCoopNoPickerViewController = segue.destinationViewController as? OrderCoopNoPickerViewController else {
                return
            }
            orderCoopNoPickerViewController.order = order
            orderCoopNoPickerViewController.delegate = self
            
        }
    }

    func changedCoopNo() {
        guard let order = order else {
            return
        }
        coopNoButton.setTitle(order.coopNo ?? Constants.noCoopText, forState: .Normal)
        if order.coopNo == nil {
            ResetCoopCases()
        }
    }
    
    func initNotes() {
        for (index, cases) in Constants.coopCaseList.enumerate() {
            coopCasesControl.setTitle("\(cases)", forSegmentAtIndex: index)
        }
        notesTextField.text = order?.notes
        poNoTextField.text = order?.poNo
        guard order?.account.coopList.count > 0 else {
            HideCoop()
            return
        }
        coopNoButton.setTitle(order?.coopNo ?? "None", forState: .Normal)
        guard let coopCases = order?.coopCases else {
            coopCasesControl.selectedSegmentIndex = 0
            return
        }
        coopCasesControl.selectedSegmentIndex = Constants.coopCaseList.indexOf(coopCases) ?? 0
    }
    
    func HideCoop() {
        coopNoLabel.hidden = true
        coopNoButton.hidden = true
        coopCasesLabel.hidden = true
        coopCasesControl.hidden = true
    }
    
    func ResetCoopCases() {
        order?.coopCases = nil
        coopCasesControl.selectedSegmentIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
