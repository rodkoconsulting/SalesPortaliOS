//
//  InvoiceList.swift
//  SalesPortal
//
//  Created by administrator on 11/29/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//
import Foundation

enum InvoiceListFilter: String {
    case Mtd = "MTD"
    case Ytd = "YTD"
    case OneYear = "1 YR"
    
    static let rawValues = [Mtd.rawValue, Ytd.rawValue, OneYear.rawValue]
    
}