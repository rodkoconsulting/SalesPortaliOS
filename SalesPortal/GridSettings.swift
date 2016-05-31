//
//  GridSettings.swift
//  InventoryPortal
//
//  Created by administrator on 10/16/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation
import UIKit
import XuniFlexGridKit


struct GridSettings {
    static let colorRestricted = UIColor(red: 255/255.0, green: 255/255.0, blue: 102/255.0, alpha: 1.0)
    static let colorDefault = UIColor.whiteColor()
    static let colorFocus = UIColor(red: 152/255.0, green: 251/255.0, blue: 152/255.0, alpha: 1.0)
    static let colorSelected = UIColor(red: 137/255.0, green: 196/255.0, blue: 244/255.0, alpha: 1.0)
    static let textColorSelected = UIColor.whiteColor()
    static let alternatingRowBackgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
    static let gridLinesVisibility = FlexGridLinesVisibility.Vertical
    static let defaultSelectionMode = FlexSelectionMode.CellRange
    static let selectionTextColor = UIColor.blackColor()
    static let defaultFont = UIFont(name: "HelveticaNeue-Thin", size:15)
    static let columnHeaderFont = UIFont(name: "HelveticaNeue", size:13)
    static let selectionModes = [FlexSelectionMode.RowRange, FlexSelectionMode.CellRange]
}