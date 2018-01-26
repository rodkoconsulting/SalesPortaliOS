//
//  OrderNotesViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/14/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit

protocol isOrderNotesVc {
    func callChildDismiss()
    func callChildViewDidLoad()
    func callChildInitNotes()
}

class OrderNotesViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    weak var order: isOrderType?
    
    var maxLength: Int = 0; //implement in child
    
    func callChildDismiss() {
        //implement in child
    }
    
    func callChildViewDidLoad() {
        //implement in child
    }
    
    func callChildInitNotes() {
        //implement in child
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        guard let order = order else {
            performSegue(withIdentifier: "unwindToHeader", sender: self)
            return
        }
        order.notes = notesTextField.text
        callChildDismiss()
        performSegue(withIdentifier: "unwindToHeader", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextField.delegate = self
        callChildViewDidLoad()
        initNotes()
    }
    
    func initNotes() {
        notesTextField.text = order?.notes
        callChildInitNotes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount) {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= maxLength
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitVc()
    }
    
    func exitVc() {
        notesTextField.delegate = nil
    }
    
    
}
