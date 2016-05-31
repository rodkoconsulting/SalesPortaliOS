//
//  MainTabBarController.swift
//  SalesPortal
//
//  Created by administrator on 5/27/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var inventory: NSMutableArray? = [Inventory(queryResult: nil, poDict: nil)]
    var inventoryDataSettings: InventoryDataSettings = InventoryDataSettings()
    
    var account: NSMutableArray? = [Account(queryResult: nil)]
    
    override func viewDidLoad() {
        SwiftSpinner.show("Loading", animated: false) {
               _ in
        super.viewDidLoad()
        }
    }
    
}
