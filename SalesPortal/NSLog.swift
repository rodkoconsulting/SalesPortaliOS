//
//  NSLog.swift
//  SalesPortal
//
//  Created by Andrew Rodko on 9/16/17.
//  Copyright © 2017 Polaner Selections. All rights reserved.
//

import Foundation

public func NSLog(_ format: String, _ args: CVarArg...) {
    let message = String(format: format, arguments:args)
    print(message);
    TFLogv(message, getVaList([]))
}
