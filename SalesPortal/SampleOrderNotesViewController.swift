//
//  OrderNotesViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/14/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit

class SampleOrderNotesViewController: OrderNotesViewController, isOrderNotesVc  {
    
    override func callChildViewDidLoad() {
        navigationBar.title = "Sample Notes"
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        maxLength = 30
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    override func callChildDismiss() {

    }

    override func callChildInitNotes() {
    
    }
}
