//
//  OrderNotesViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/14/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit
import XuniInputKit

let kSHIPTOTAG = 0
let kCOOPTAG = 1

class AccountOrderNotesViewController: OrderNotesViewController, XuniDropDownDelegate, XuniComboBoxDelegate, isOrderNotesVc {


    @IBOutlet weak var poNoTextField: UITextField!
    @IBOutlet weak var coopNoComboBox: XuniComboBox!
    @IBOutlet weak var coopNoLabel: UILabel!
    @IBOutlet weak var shipToComboBox: XuniComboBox!
    @IBOutlet weak var shipToLabel: UILabel!
    
    override func callChildDismiss() {
        guard let accountOrder = order as? AccountOrder else {
            return
        }
        accountOrder.poNo = poNoTextField.text
    }
    
    override func callChildViewDidLoad() {
        navigationBar.title = order?.account?.customerName
    }
    
    func coopIndexChanged(index: Int) {
        guard let accountOrder = order as? AccountOrder,
            let coopList = accountOrder.account?.coopList else {
            return
        }
        guard index != 0 else {
            accountOrder.coopNo = "None"
            accountOrder.coopCases = 0
            return
        }
        accountOrder.coopNo = coopList[index - 1]
        accountOrder.coopCases = 5
    }
    
    func shipToIndexChanged(index: Int) {
        guard let accountOrder = order as? AccountOrder,
            let shipToList = accountOrder.shipToList else {
            return
        }
        accountOrder.shipTo = shipToList[index]
    }
    
    func selectedIndexChanged(_ sender: XuniComboBox!) {
        let selectedIndex = Int(sender.selectedIndex)
        switch (sender.tag) {
            case kCOOPTAG:
                coopIndexChanged(index: selectedIndex)
            case kSHIPTOTAG:
                shipToIndexChanged(index: selectedIndex)
            default:
                return
        }
    }
    
    override func callChildInitNotes() {
        guard let accountOrder = order as? AccountOrder else {
            return
        }
        poNoTextField.text = accountOrder.poNo
        initCoopNo()
        initShipTo()

    }
    
    func initShipTo() {
        var index : Int? = nil
        var selectedIndex: UInt = 0
        guard let shipToList = order?.shipToList as? [AccountOrderAddress],
            let shipTo = order?.shipTo as? AccountOrderAddress else {
            HideShipTo()
            return
        }
        index = shipToList.index(of: shipTo)
        if let index = index {
            selectedIndex = UInt(shipToList.startIndex.distance(to: index))
        }
        let rowCount = shipToList.count > 4 ? 4 : shipToList.count;
        shipToComboBox.delegate = self
        shipToComboBox.tag = kSHIPTOTAG
        shipToComboBox.headerBorderColor = UIColor.black
        shipToComboBox.backgroundColor = UIColor.white
        shipToComboBox.buttonColor = UIColor.black
        shipToComboBox.displayMemberPath = "name"
        shipToComboBox.isEditable = false
        shipToComboBox.textFont = GridSettings.smallFont
        shipToComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        shipToComboBox.itemsSource = ComboData.addressData(shipToList)
        shipToComboBox.selectedIndex = selectedIndex
        shipToComboBox.dropDownHeight = Double(rowCount * Constants.ComboCellHeight)
    }
    
    func initCoopNo() {
        var index : Int? = nil
        var selectedIndex: UInt = 0
        
        guard (order?.orderType == .Standard && (order?.account?.coopList.count ?? 0) > 0 ) else {
            HideCoop()
            return
        }
        let accountOrder = order as? AccountOrder
        if let coopNo = accountOrder?.coopNo {
            index = accountOrder?.account?.coopList.index(of: coopNo)
        }
        if let index = index {
            selectedIndex = UInt(accountOrder?.account?.coopList.startIndex.distance(to: index + 1) ?? 0)
        }
        coopNoComboBox.delegate = self
        coopNoComboBox.tag = kCOOPTAG
        coopNoComboBox.headerBorderColor = UIColor.black
        coopNoComboBox.buttonColor = UIColor.black
        coopNoComboBox.displayMemberPath = "name"
        coopNoComboBox.isEditable = false
        coopNoComboBox.dropDownBehavior = XuniDropDownBehavior.headerTap
        coopNoComboBox.itemsSource = ComboData.coopNoData(accountOrder?.account?.coopList)
        coopNoComboBox.selectedIndex = selectedIndex
        coopNoComboBox.dropDownHeight = Double(coopNoComboBox.itemsSource.count * Constants.ComboCellHeight)
    }
    
    func HideCoop() {
        coopNoLabel.isHidden = true
        coopNoComboBox.isHidden = true
    }
    
    func HideShipTo() {
        shipToLabel.isHidden = true
        shipToComboBox.isHidden = true
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
        if coopNoComboBox != nil && coopNoComboBox.itemsSource != nil {
            coopNoComboBox.selectedItem = nil
            coopNoComboBox.itemsSource.removeAllObjects()
            coopNoComboBox.collectionView.removeAllObjects()
            coopNoComboBox.delegate = nil
        }
        if shipToComboBox != nil && shipToComboBox.itemsSource != nil {
            shipToComboBox.selectedItem = nil
            shipToComboBox.itemsSource.removeAllObjects()
            shipToComboBox.collectionView.removeAllObjects()
            shipToComboBox.delegate = nil
        }
        coopNoComboBox = nil
        shipToComboBox = nil
    }
}
