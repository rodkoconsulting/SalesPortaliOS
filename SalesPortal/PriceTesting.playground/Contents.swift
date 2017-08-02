//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let priceString = "385.08"

let priceStripped = priceString.stringByReplacingOccurrencesOfString(" ", withString: "")
let priceArray = priceStripped.characters.split {$0 == ","}.map { String($0) }

let price = priceArray[0]

var tupleArray:[(price: Double, unit: Int)] = []
for priceBreak in priceArray {
    let breakArray: [String]
    breakArray = priceBreak.containsString("/") ? priceBreak.characters.split{ $0 == "/" }.map { String($0) } : [priceBreak, "1"]
    let priceWrapped: Double? = Double(breakArray[0])
    let unitWrapped: Int?
    unitWrapped = Int(breakArray[1])
    if let price = priceWrapped, let unit = unitWrapped {
        tupleArray.append((price, unit))
    }
}

let tupleprice = tupleArray

