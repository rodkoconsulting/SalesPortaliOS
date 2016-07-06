//
//  InitialViewController.swift
//  SalesPortal
//
//  Created by administrator on 6/13/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        SwiftSpinner.show("Loading...", animated: false) {
            _ in
            dispatch_async(dispatch_get_main_queue()) {
                //SwiftSpinner.hide()
                self.performSegueWithIdentifier("showMainTabBarController", sender: self)
            }
        }
    }
}
