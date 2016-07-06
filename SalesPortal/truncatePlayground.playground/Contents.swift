//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let orderTotal = 4.999999
round(orderTotal*10000)/10000

extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

orderTotal.truncate(0)
