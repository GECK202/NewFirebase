//
//  CryptManager.swift
//  FB
//
//  Created by Valeria Karon on 8/3/22.
//

import Foundation

public func crypt(message: String, key: String)->String {
    return message
}

public func decrypt(message: String, key: String)->String {
    return message
}

public func generateKey()->String {
    return "ZgPPU1hn8?gt"
}

public func getCurTime()->String {
    let someDate = Date()
    // convert Date to TimeInterval (typealias for Double)
    let timeInterval = someDate.timeIntervalSince1970
    // convert to Integer
    let myInt = Int(timeInterval * 1000)
    
    print("DATE TO STRING DATE:\(someDate) TIME INTEVAL\(timeInterval) INT \(myInt)")
    
    return String(myInt)
}

public func getDate(from timeString: String)->Date {
    let myInt = Int(timeString)
    let timeInterval = (Double(myInt ?? 0) / 1000.0) as TimeInterval
    let someDate = Date(timeIntervalSince1970: timeInterval)
    
    print("DATE FROM STRING DATE:\(someDate) TIME INTEVAL\(timeInterval) INT \(myInt ?? 0) TIMESTRING \(timeString)")
    return someDate
}
