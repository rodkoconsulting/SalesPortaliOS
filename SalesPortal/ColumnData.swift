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
let kFormat = "format"
let kAgg = "aggregate"
let kGroup = "groupLevel"
let kValue = "value"
let kManagerGroup = "groupLevelManager"

struct ColumnData {
    static let inventoryColumns: [[String : Any]] = [
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
    static let accountOrderInventoryColumns: [[String : Any]] = [
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
    static let sampleOrderInventoryColumns: [[String : Any]] = [
        [kName:"version", kValue: 2],
        [kName:"itemDescription", kHeader: "Description", kWidth: 300],
        [kName:"itemCode", kHeader: "Item"],
        [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false],
        [kName:"comment", kHeader: "Comment", kReadOnly: false],
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
    static let orderHeaderColumns: [[String : Any]] = [
        [kName:"itemDescription", kHeader: "Description", kWidth: 300],
        [kName:"itemCode", kHeader: "Item", kAgg: "Count"],
        [kName:"cases", kHeader: "Cases", kType: "Number", kReadOnly: false, kAgg: "Sum"],
        [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false, kAgg: "Sum"],
        [kName:"unitPrice", kHeader: "Price", kType: "Number"],
        [kName:"priceTotal", kHeader: "Total", kType: "Number", kFormat: "C", kAgg: "Sum"],
        [kName:"moboString", kHeader: "MOBOs", kType: "String"]
    ]
    static let sampleOrderHeaderColumns: [[String : Any]] = [
        [kName:"version", kValue: 2],
        [kName:"itemDescription", kHeader: "Description", kWidth: 300],
        [kName:"itemCode", kHeader: "Item", kAgg: "Count"],
        [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false, kAgg: "Sum"],
        [kName:"comment", kHeader: "Comment", kReadOnly: false]
    ]
    static let accountOrderHistoryColumns: [[String : Any]] = [
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
    static let sampleOrderHistoryColumns: [[String : Any]] = [
        [kName:"version", kValue: 3],
        [kName:"itemDescription", kHeader: "Description",  kWidth: 300],
        [kName:"itemCode" as AnyObject, kHeader: "Item" as AnyObject],
        [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false],
        [kName:"comment", kHeader: "Comment", kReadOnly: false],
        [kName:"lastQuantity", kHeader: "Last Qty", kType: "Number"],
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
    static let accountColumns: [[String : Any]] = [
        [kName:"version", kValue: 5],
        [kName:"statusString", kHeader: "Status"],
        [kName:"customerNo", kHeader: "Account #"],
        [kName:"customerName", kHeader: "Account Name", kWidth: 300],
        [kName:"buyer1", kHeader: "Wine Buyer 1"],
        [kName:"buyer1Email", kHeader: "Wine Buyer 1 Email"],
        [kName:"buyer1Phone", kHeader: "Wine Buyer 1 Phone"],
        [kName:"buyer2", kHeader: "Wine Buyer 2"],
        [kName:"buyer2Email", kHeader: "Wine Buyer 2 Email"],
        [kName:"buyer2Phone", kHeader: "Wine Buyer 2 Phone"],
        [kName:"buyer3", kHeader: "Wine Buyer 3"],
        [kName:"buyer3Email", kHeader: "Wine Buyer 3 Email"],
        [kName:"buyer3Phone", kHeader: "Wine Buyer 3 Phone"],
        [kName:"affil", kHeader: "Affiliations"],
        [kName:"coopString", kHeader: "Coops"],
        [kName:"rep", kHeader: "Rep", kWidth: 45, kManagerGroup: 0],
    ]
    static let orderListColumns: [[String : Any]] = [
        [kName:"version", kValue: 13],
        [kName:"customerName", kHeader: "Account", kWidth: 250, kGroup: 0, kManagerGroup: 3],
        [kName:"orderNo", kHeader: "Order #", kWidth: 60],
        [kName:"orderType", kHeader: "Type", kWidth: 35],
        [kName:"holdCode", kHeader: "Hold", kWidth: 45],    
        [kName:"orderDate", kHeader: "Order Date", kAlignment:"right", kWidth: 70, kType: "NumberDate"],
        [kName:"shipExpireDate", kHeader: "Ship/Exp Date", kAlignment:"right", kWidth: 90, kType: "NumberDate"],
        [kName:"boEta", kHeader: "BO ETA", kAlignment:"right", kWidth: 90, kType: "NumberDate"],
        [kName:"itemCode", kHeader: "Item", kWidth: 70],
        [kName:"itemDescription", kHeader: "Description", kWidth: 250],
        [kName:"price", kHeader: "Price", kType: "Number", kWidth: 50],
        [kName:"quantityMas", kHeader: "Qty", kType: "Number", kAgg: "Sum", kWidth: 50],
        [kName:"total", kHeader: "Total", kType: "Number", kAgg: "Sum", kWidth: 50],
        [kName:"comment", kHeader: "Item Comment"],
        [kName:"rep", kHeader: "Rep", kWidth: 45, kManagerGroup: 2],
        [kName:"territory", kHeader: "Territory", kWidth: 45, kManagerGroup: 1]
    ]
    static let sampleListColumns: [[String : Any]] = [
        [kName:"version", kValue: 4],
        [kName:"shipDate", kHeader: "Date", kAlignment:"right", kWidth: 70, kType: "NumberDate"],
        [kName:"itemCode", kHeader: "Item", kWidth: 70],
        [kName:"itemDescription", kHeader: "Description", kWidth: 250],
        [kName:"quantityBottle", kHeader: "Qty (b)", kType: "Number", kAgg: "Sum", kWidth: 50],
        [kName:"comment", kHeader: "Item Comment"],
        [kName:"country", kHeader: "Country"],
        [kName:"region", kHeader: "Region"],
        [kName:"appellation", kHeader: "Appellation"],
        [kName:"brand", kHeader: "Brand"],
        [kName:"masterVendor", kHeader: "Master Vendor"],
        [kName:"isFocus", kHeader:"Focus", kType:"StringBool"],
        [kName:"shipToName", kHeader:"Ship To"],
        [kName:"rep", kHeader: "Rep", kWidth: 45, kManagerGroup: 0]
    ]
    static let orderMoboColumns: [[String : Any]] = [
        [kName:"orderNo", kHeader: "Order #", kWidth: 60],
        [kName:"orderType", kHeader: "Type", kWidth: 33],
        [kName:"expirationDate", kHeader: "Exp Date", kAlignment:"right", kWidth: 75, kType: "NumberDate"],
        [kName:"customerName", kHeader: "Account", kWidth: 200],
        [kName:"itemCode", kHeader: "Item", kWidth: 80],
        [kName:"itemDescription", kHeader: "Description", kWidth: 300],
        [kName:"cases", kHeader: "Cases", kType: "Number", kReadOnly: false, kWidth: 40],
        [kName:"bottles", kHeader: "Bottles", kType: "Number", kReadOnly: false, kWidth: 50],
        [kName:"quantity", kHeader: "On MOBO", kType: "Number", kWidth: 70]
    ]
    static let orderSavedColumns: [[String : Any]] = [
        [kName:"saveTime", kHeader: "Save Date", kAlignment:"right", kWidth: 150, kType: "NumberDate", kFormat: "Time"],
        [kName:"shipDate", kHeader: "Ship Date", kAlignment:"right", kWidth: 75, kType: "NumberDate"],
        [kName:"customerName", kHeader: "Account", kWidth: 200],
        [kName:"orderType", kHeader: "Order Type"],
        [kName:"total", kHeader: "Quantity", kType: "Number", kWidth: 55],
        [kName:"price", kHeader: "Total", kType: "Number", kWidth: 70]
    ]
}
