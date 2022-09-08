//
//  CryptManager.swift
//  FB
//
//  Created by Valeria Karon on 8/3/22.
//

import Foundation
import CryptoSwift

public func crypt(message: String, key: String)->String {
    
    return message
}

public func decrypt(message: String, key: String)->String {
    return message
}

public func generateKey()->String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?"
    var s = ""
    for _ in 0 ..< 16{
        //Unicode.Scalar(value)!
        s.append(letters.randomElement()!)
    }
    return s
    //return "ZgPPU1hn8?gt"
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




func cryptTest() {
    let key = generateKey()//"bbC2H19lkVbQDfak" // length == 16
    let s = "hello привет"
    let enc = try! aesEncrypt2(s: s, key: key)
    //let dec = try! aesDecrypt2(cryptString: enc, key: key)

    print(s) // string to encrypt
    print("enc:\(enc)") //1nkk47zTcgJaYSf2Nkspt1BFO5VmVx2PdUtdz9NJHDg=
    //print("dec:\(dec)") // string to encrypt
    //print("\(s == dec)") // true

}

//extension String {
    /*
    func aesEncrypt(key: String) throws -> String {
        let encrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).encrypt([UInt8](self.data(using: .utf8)!))
        print("ENCODING DATA=[\(String(decoding: Data(encrypted), as: UTF8.self))]")
        return Data(encrypted).base64EncodedString()
    }

    func aesDecrypt(key: String) throws -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        let decrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).decrypt([UInt8](data))
        return String(bytes: decrypted, encoding: .utf8) ?? self
    }
    */
    
func aesEncrypt(s:String, key: String) throws -> String {
        
    let encrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).encrypt([UInt8](s.data(using: .utf8)!))
    //let data: Data = Data(encrypted)
    //let str: NSString = NSString(data: data, encoding: String.Encoding.utf16.rawValue) ?? "error"
    return Data(encrypted).base64EncodedString()
    }

func aesDecrypt(cryptString:String, key: String) throws -> String {
    guard let data = Data(base64Encoded: cryptString) else { return "" }
    let decrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).decrypt([UInt8](data))
    return String(bytes: decrypted, encoding: .utf8) ?? cryptString
}

func aesEncrypt2(s:String, key: String) throws -> NSString {
    let data1 = [UInt8](s.data(using: .utf8)!)
    let encrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).encrypt(data1)
    
    let data: Data = Data(encrypted)
    let str = NSString(data: data, encoding: String.Encoding.utf16BigEndian.rawValue) ?? "error"
    //let str2 = NSString(bytes: encrypted, length: encrypted.count, encoding: String.Encoding.unicode.rawValue) ?? "error"
    let str3 =  String(bytes: encrypted, encoding: String.Encoding.utf16BigEndian)!
    
    guard let data2 = str3.data(using: String.Encoding.utf16BigEndian) else { return "error1" }
    let arrData = [UInt8](data2)
    let decrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).decrypt([UInt8](data))
    let newS = String(bytes: decrypted, encoding: .utf8) ?? "error2"
    print("\(encrypted)")
    print("\(arrData)")
    return str//Data(encrypted).base64EncodedString()
    }

func aesDecrypt2(cryptString:NSString, key: String) throws -> String {
    guard let data = cryptString.data(using: String.Encoding.utf16.rawValue) else { return "error1" }
    let arrData = [UInt8](data)
    let decrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).decrypt([UInt8](data))
    return String(bytes: decrypted, encoding: .utf8) ?? "error2"
}


