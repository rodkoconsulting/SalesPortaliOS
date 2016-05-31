//
//  Constants.swift
//  InventoryPortal
//
//  Created by administrator on 4/18/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation
import XuniFlexGridKit

struct Constants {
    static let databasePath = NSURL(fileURLWithPath:NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]).URLByAppendingPathComponent("polPortal11.db").absoluteString
    static let hourCutoff = 16
    static let minuteCutoff = 10
    static let defaultSelectionMode = FlexSelectionMode.CellRange
    static let mailSubject = "iOS InventoryPortal Excel file"
    static let mailBody = "Attached is the Excel data export from the iOS InventoryPortal."
    static let mailAttachmentFile = "InventoryPortalExport.csv"
    static let timeSyncDefault = "2000-01-01 00:00:00.000"
    static let stateValues = ["NY", "NJ"]
    static let boolList = ["True", "False"]
}