//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var a = [1,2,3,4,5]

// Check if it contains the number '6'
a.contains(6)
if a.contains(6) {
    print("Yes, it does contain number 6")
}
else {
    print("No, it doesn't")
}

var b = ["test" : "test"]

var array = [[String : String]]()
array.append(b)

array.contains({$0 == b})

