//
//  ColumnData.swift
//  InventoryPortal
//
//  Created by administrator on 9/25/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation
import UIKit

let kName = "binding"
let kHeader = "header"
let kWidth = "width"
let kMinWidth = "minwidth"
let kMultiline = "isMultiline"
let kAlignment = "alignment"
let kColor = "color"
let kType = "type"
let kSort = "sort"
let kSortAcsend = "defaultSort"
let kReadOnly = "readonly"


struct ColumnData {
    let inventoryColumns: [[String:AnyObject]]
    let orderInventoryColumns: [[String:AnyObject]]
    let orderHeaderColumns: [[String:AnyObject]]
    let orderHistoryColumns: [[String:AnyObject]]
    let accountColumns: [[String:AnyObject]]
        
    init () {
        inventoryColumns = [
            [kName:"itemDescription", kHeader: "Description", kWidth: 300],
            [kName:"itemCode", kHeader: "Item"],
            [kName:"quantityAvailable", kHeader: "Avail", kType: "Number"],
            [kName:"priceCase", kHeader: "Price (c)", kType: "Number"],
            [kName:"priceBottle", kHeader: "Price (b)", kType: "Number"],
            [kName:"discountCase", kHeader: "Discount (c)", kType: "Number"],
            [kName:"discountBottle", kHeader: "Discount (b)", kType: "Number"],
            [kName:"discountList", kHeader: "Discounts", kWidth: 100],
            [kName:"quantityOnHand", kHeader: "On Hand", kType: "Number"],
            [kName:"onSo", kHeader: "On SO", kType: "Number"],
            [kName:"onMo", kHeader: "On MO", kType: "Number"],
            [kName:"onBo", kHeader: "On BO", kType: "Number"],
            [kName:"onPo", kHeader: "On PO", kAlignment:"right", kWidth: 60, kType: "Number"],
            [kName:"poEta", kHeader: "PO ETA", kAlignment:"right", kWidth: 80, kType: "NumberDate", kSort: "poEtaSort"],
            [kName:"poDate", kHeader: "PO Date", kAlignment:"right", kWidth: 80, kType: "NumberDate", kSort: "poDateSort"],
            [kName:"restrictedList", kHeader: "Restrictions", kWidth: 100],
            [kName:"brand", kHeader: "Brand"],
            [kName:"masterVendor", kHeader: "Master Vendor"],
            [kName:"vintage", kHeader: "Vintage"],
            [kName:"size", kHeader: "Size"],
            [kName:"closure", kHeader: "Closure"],
            [kName:"type", kHeader: "Type"],
            [kName:"varietal", kHeader: "Varietal"],
            [kName:"organic", kHeader: "Organic"],
            [kName:"biodynamic", kHeader: "Biodynamic"],
            [kName:"country", kHeader: "Country"],
            [kName:"region", kHeader: "Region"],
            [kName:"appellation", kHeader: "Appellation"],
            [kName:"focus", kHeader:"Focus", kType:"StringBool"],
            [kName:"upc", kHeader:"UPC"],
            [kName:"scoreList", kHeader:"Scores", kAlignment:"right", kWidth: 200]
            ]
        orderInventoryColumns = [
            [kName:"itemDescription", kHeader: "Description", kWidth: 300],
            [kName:"itemCode", kHeader: "Item"],
            [kName:"cases", kHeader: "Cases", kType: "Number", kReadOnly: false],
            [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false],
            [kName:"quantityAvailable", kHeader: "Avail", kType: "Number"],
            [kName:"priceCase", kHeader: "Price (c)", kType: "Number"],
            [kName:"priceBottle", kHeader: "Price (b)", kType: "Number"],
            [kName:"discountCase", kHeader: "Discount (c)", kType: "Number"],
            [kName:"discountBottle", kHeader: "Discount (b)", kType: "Number"],
            [kName:"discountList", kHeader: "Discounts", kWidth: 100],
            [kName:"quantityOnHand", kHeader: "On Hand", kType: "Number"],
            [kName:"onSo", kHeader: "On SO", kType: "Number"],
            [kName:"onMo", kHeader: "On MO", kType: "Number"],
            [kName:"onBo", kHeader: "On BO", kType: "Number"],
            [kName:"onPo", kHeader: "On PO", kAlignment:"right", kWidth: 60, kType: "Number"],
            [kName:"poEta", kHeader: "PO ETA", kAlignment:"right", kWidth: 80, kType: "NumberDate", kSort: "poEtaSort"],
            [kName:"poDate", kHeader: "PO Date", kAlignment:"right", kWidth: 80, kType: "NumberDate", kSort: "poDateSort"],
            [kName:"restrictedList", kHeader: "Restrictions", kWidth: 100],
            [kName:"brand", kHeader: "Brand"],
            [kName:"masterVendor", kHeader: "Master Vendor"],
            [kName:"vintage", kHeader: "Vintage"],
            [kName:"size", kHeader: "Size"],
            [kName:"closure", kHeader: "Closure"],
            [kName:"type", kHeader: "Type"],
            [kName:"varietal", kHeader: "Varietal"],
            [kName:"organic", kHeader: "Organic"],
            [kName:"biodynamic", kHeader: "Biodynamic"],
            [kName:"country", kHeader: "Country"],
            [kName:"region", kHeader: "Region"],
            [kName:"appellation", kHeader: "Appellation"],
            [kName:"focus", kHeader:"Focus", kType:"StringBool"],
            [kName:"upc", kHeader:"UPC"],
            [kName:"scoreList", kHeader:"Scores", kAlignment:"right", kWidth: 200]
        ]
        orderHeaderColumns = [
            [kName:"itemDescription", kHeader: "Description", kWidth: 300],
            [kName:"itemCode", kHeader: "Item"],
            [kName:"cases", kHeader: "Cases", kType: "Number", kReadOnly: false],
            [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false],
            [kName:"unitPrice", kHeader: "Price", kType: "Number"],
            [kName:"discountList", kHeader: "Discounts", kWidth: 100],
            [kName:"priceTotal", kHeader: "Total", kType: "Number"]
        ]
        orderHistoryColumns = [
            [kName:"itemDescription", kHeader: "Description", kWidth: 300],
            [kName:"itemCode", kHeader: "Item"],
            [kName:"cases", kHeader: "Cases", kType: "Number", kReadOnly: false],
            [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false],
            [kName:"lastQuantity", kHeader: "Last Qty", kType: "Number"],
            [kName:"lastPrice", kHeader: "Last Price", kType: "Number"],
            [kName:"lastDate", kHeader: "Last Date", kType: "NumberDate", kSortAcsend: false],
            [kName:"quantityAvailable", kHeader: "Avail", kType: "Number"],
            [kName:"priceCase", kHeader: "Price (c)", kType: "Number"],
            [kName:"priceBottle", kHeader: "Price (b)", kType: "Number"],
            [kName:"discountCase", kHeader: "Discount (c)", kType: "Number"],
            [kName:"discountBottle", kHeader: "Discount (b)", kType: "Number"],
            [kName:"discountList", kHeader: "Discounts", kWidth: 100],
            [kName:"quantityOnHand", kHeader: "On Hand", kType: "Number"],
            [kName:"onSo", kHeader: "On SO", kType: "Number"],
            [kName:"onMo", kHeader: "On MO", kType: "Number"],
            [kName:"onBo", kHeader: "On BO", kType: "Number"],
            [kName:"onPo", kHeader: "On PO", kAlignment:"right", kWidth: 60, kType: "Number"],
            [kName:"poEta", kHeader: "PO ETA", kAlignment:"right", kWidth: 80, kType: "NumberDate", kSort: "poEtaSort"],
            [kName:"poDate", kHeader: "PO Date", kAlignment:"right", kWidth: 80, kType: "NumberDate", kSort: "poDateSort"],
            [kName:"restrictedList", kHeader: "Restrictions", kWidth: 100],
            [kName:"brand", kHeader: "Brand"],
            [kName:"masterVendor", kHeader: "Master Vendor"],
            [kName:"vintage", kHeader: "Vintage"],
            [kName:"size", kHeader: "Size"],
            [kName:"closure", kHeader: "Closure"],
            [kName:"type", kHeader: "Type"],
            [kName:"varietal", kHeader: "Varietal"],
            [kName:"organic", kHeader: "Organic"],
            [kName:"biodynamic", kHeader: "Biodynamic"],
            [kName:"country", kHeader: "Country"],
            [kName:"region", kHeader: "Region"],
            [kName:"appellation", kHeader: "Appellation"],
            [kName:"focus", kHeader:"Focus", kType:"StringBool"],
            [kName:"upc", kHeader:"UPC"],
            [kName:"scoreList", kHeader:"Scores", kAlignment:"right", kWidth: 200]
        ]
        accountColumns = [
            [kName:"customerNo", kHeader: "Account #"],
            [kName:"customerName", kHeader: "Account Name", kWidth: 300],
            [kName:"coopString", kHeader: "Coops"]
        ]
    }
}
