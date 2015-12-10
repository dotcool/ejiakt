//: Playground - noun: a place where people can play

import Cocoa

var temp = "Hello, playground android"
print(temp)
var good = temp.stringByReplacingOccurrencesOfString("android", withString: "java")
if(good != temp){
    print(1, terminator: "")
}
good = temp.stringByReplacingOccurrencesOfString("Android", withString: "java")
print(temp)
print(good, terminator: "")
