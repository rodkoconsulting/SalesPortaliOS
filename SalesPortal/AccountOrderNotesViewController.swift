//
//  OrderNotesViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/14/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class AccountOrderNotesViewController: OrderNotesViewController, XuniDropDownDelegate, XuniComboBoxDelegate, isOrderNotesVc {


    @IBOutlet weak var poNoTextField: UITextField!
    @IBOutlet weak var coopNoComboBox: XuniComboBox!
    @IBOutlet weak var coopNoLabel: UILabel!
    
    override func callChildDismiss() {
        guard let accountOrder = order as? AccountOrder else {
            return
        }
        accountOrder.poNo = poNoTextField.text
    }
    
    override func callChildViewDidLoad() {
        navigationBar.title = order?.account?.customerName
    }
    
    func selectedIndexChanged(_ sender: XuniComboBox!) {
        guard let accountOrder = order as? AccountOrder,
              let coopList = accountOrder.account?.coopList else {
            return
        }
        let selectedIndex = Int(sender.selectedIndex)
        guard selectedIndex != 0 else {
            accountOrder.coopNo = "None"
            accountOrder.coopCases = 0
            return
        }
        accountOrder.coopNo = coopList[selectedIndex - 1]
        accountOrder.coopCases = 5
    }
    
    override func callChildInitNotes() {
        guard let accountOrder = order as? AccountOrder else {
            return
        }
        poNoTextField.text = accountOrder.poNo
        guard order?.account?.coopList.count > 0 else {
            HideCoop()
            return
        }
        initCoopNo()

    }
    
    func initCoopNo() {
        var index : Int? = nil
        var selectedIndex: UInt = 0
        guard let accountOrder = order as? AccountOrder else {
            return
        }
        guard let coopList = accountOrder.account?.coopList else {
            coopNoComboBox.isHidden = true
            return
        }
        if let coopNo = accountOrder.coopNo {
            index = accountOrder.account?.coopList.index(of: coopNo)
        }
        if let index = index {
            selectedIndex = UInt(accountOrder.account?.coopList.startIndex.distance(to: index + 1) ?? 0)
        }
        coopNoComboBox.delegate = self
        coopNoComboBox.headerBorderColor = UIColor.black
        coopNoComboBox.buttonColor = UIColor.black
        coopNoComboBox.displayMemberPath = "name"
        coopNoComboBox.isEditable = false
        coopNoComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        coopNoComboBox.itemsSource = ComboData.coopNoData(coopList)
        coopNoComboBox.selectedIndex = selectedIndex
        coopNoComboBox.dropDownHeight = Double(coopNoComboBox.itemsSource.count * Constants.ComboCellHeight)
    }
    
    func HideCoop() {
        coopNoLabel.isHidden = true
        coopNoComboBox.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitVc()
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        maxLength = 150
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    override func exitVc() {
        super.exitVc()
        guard coopNoComboBox != nil else {
            return
        }
        guard coopNoComboBox.itemsSource != nil else {
            coopNoComboBox = nil
            return
        }
        coopNoComboBox.selectedItem = nil
        coopNoComboBox.itemsSource.removeAllObjects()
        coopNoComboBox.collectionView.removeAllObjects()
        coopNoComboBox.delegate = nil
        coopNoComboBox = nil
        
    }
}
