//
//  ColumnSettings.swift
//  InventoryPortal
//
//  Created by administrator on 11/22/15.
//  Copyright © 2015 Polaner Selections. All rights reserved.
//

import Foundation

struct ColumnSettings {
    var name : String?
    var visible : Bool?
    var width: Double?
    var version: Int?
    
    init?(settingDict : [String : AnyObject]) {
        let name = settingDict["name"] as? String
        let visible = settingDict["visible"] as? Bool
        let width = settingDict["width"] as? Double
        let version = settingDict["version"] as? Int
        self.name = name
        self.visible = visible
        self.width = width
        self.version = version
    }
    
    static func generateColumnSettings(_ columnSettings: [[String : AnyObject]]?) -> [ColumnSettings]? {
        guard let columnSettings = columnSettings else {
            return nil
        }
        var columnSettingsArray = [ColumnSettings]()
        for columnSetting in columnSettings {
            guard let myColumnSettings = ColumnSettings(settingDict: columnSetting) else {
                return nil
            }
            columnSettingsArray.append(myColumnSettings)
        }
        return columnSettingsArray
    }
}
