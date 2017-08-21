//
//  moboList.swift
//  SalesPortal
//
//  Created by administrator on 7/13/16.
//  Copyright © 2016 Polaner Selections. All rights reserved.
//

import Foundation


protocol MoboListDelegate: class {
    func updateOrderMobo(moboList: MoboList)
}

class MoboList :  OrderList {
    
    weak var delegate: MoboListDelegate?
    
    var isGridUpdate: Bool = true
    var isReversal: Bool = false
    
    var cases: Int {
        didSet {
            guard !isReversal else {
                return
            }
            if isOverSold  {
                isReversal = true
                cases = oldValue
                isReversal = false
                return
            }
            if cases < 0 {
                isReversal = true
                cases = 0
                isReversal = false
                return
            }
            if isGridUpdate {
                delegate?.updateOrderMobo(moboList: self)
            }
        }
    }
    
    var bottles: Int {
        didSet {
            guard !isReversal else {
                return
            }
            if bottlesExceedCase || isOverSold  {
                isReversal = true
                bottles = oldValue
                isReversal = false
                return
            }
            if bottles < 0 {
                isReversal = true
                bottles = 0
                isReversal = false
                return
            }
            if isGridUpdate {
                delegate?.updateOrderMobo(moboList: self)
            }
        }
    }
    
    var bottlesExceedCase: Bool {
        return (bottles > uomInt - 1)
    }
    
    var orderBottleTotal: Int {
        return cases * uomInt + bottles
    }
    
    lazy var moboBottleTotal: Int = {
        [unowned self] in
        return Int((self.quantity * Double(self.uomInt)).roundedBottles())
    }()
    
    lazy var moboCases: Int = {
        [unowned self] in
        return Int(self.quantity.truncate(0))
    }()
    
    lazy var moboBottles: Int = {
        [unowned self] in
        return Int(((self.quantity - Double(self.moboCases)) * Double(self.uomInt)).roundedBottles())
    }()
    
    var moboBottleAvailable: Int {
        return moboBottleTotal - orderBottleTotal
    }
    
    override init(queryResult: FMResultSet?) {
        self.cases = 0
        self.bottles = 0
        super.init(queryResult: queryResult)
    }
    
    var isOverSold : Bool {
        let orderBottleTotal = self.orderBottleTotal
        let moboBottleTotal = self.moboBottleTotal
        return orderBottleTotal > moboBottleTotal
    }
    
    func shipAll() {
        cases = moboCases
        bottles = moboBottles
    }
    
    func deleteAll() {
        cases = 0
        bottles = 0
    }
    
    func depleteBottles(_ quantity: Int) {
        let cases = Int(Double(quantity / uomInt).truncate(0))
        let bottles = quantity - (cases * uomInt)
        self.cases += cases
        self.bottles += bottles
    }

}
