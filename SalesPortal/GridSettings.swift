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
    static let colorDefault = UIColor.white
    static let colorFocus = UIColor(red: 152/255.0, green: 251/255.0, blue: 152/255.0, alpha: 1.0)
    static let colorSelected = UIColor(red: 137/255.0, green: 196/255.0, blue: 244/255.0, alpha: 1.0)
    static let colorCod = UIColor(red: 255/255.0, green: 255/255.0, blue: 102/255.0, alpha: 1.0)
    static let colorInactive = UIColor(red: 255/255.0, green: 178/255.0, blue: 102/255.0, alpha: 1.0)
    static let colorExpired = UIColor(red: 255/255.0, green: 178/255.0, blue: 102/255.0, alpha: 1.0)
    static let colorPastDue = UIColor(red: 255/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
    static let colorMoboHasExpired = UIColor(red: 255/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
    static let colorMoboWillExpire = UIColor(red: 255/255.0, green: 255/255.0, blue: 102/255.0, alpha: 1.0)
    static let textColorSelected = UIColor.white
    static let alternatingRowBackgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
    static let gridLinesVisibility = GridLinesVisibility.vertical
    static let defaultSelectionMode = GridSelectionMode.cellRange
    static let selectionTextColor = UIColor.black
    static let defaultFont = UIFont(name: "HelveticaNeue-Thin", size:15)
    static let smallFont = UIFont(name: "HelveticaNeue-Thin", size:12)
    static let columnHeaderFont = UIFont(name: "HelveticaNeue", size:13)
    static let selectionModes = [GridSelectionMode.rowRange, GridSelectionMode.cellRange]
}
