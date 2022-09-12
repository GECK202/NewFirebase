//
//  CryptManager.swift
//  FB
//
//  Created by Valeria Karon on 8/3/22.
//

import Foundation
import CryptoSwift

public func crypt(message: String, key: String)->String {
    if let cryptString = encryptAESBase64(message: message, key: key) {
        return cryptString
    }
    return message
}

public func decrypt(message: String, key: String)->String {
    if let decryptString = decryptAESBase64(message: message, key: key) {
        return decryptString
    }
    return ""
}

public func generateKey()->String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?"
    var s = ""
    for _ in 0 ..< 16{
        s.append(letters.randomElement()!)
    }
    return s
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



//*
func cryptTest() {
    let key = generateKey()//"bbC2H19lkVbQDfak" // length == 16
    let s = "hello привет"
    //let enc = try! aesEncrypt(s: s, key: key)
    //let dec = try! aesDecrypt(cryptString: enc, key: key)

    let enc = encryptAESBase64(message: s, key: key) ?? "error"
    let dec = decryptAESBase64(message: enc, key: key) ?? "error"
    
    print(s) // string to encrypt
    print("enc:\(enc)") //1nkk47zTcgJaYSf2Nkspt1BFO5VmVx2PdUtdz9NJHDg=
    print("dec:\(dec)") // string to encrypt
    print("\(s == dec)") // true

}
//*/
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
    let uKey = [UInt8](key.utf8)
    
    let aes = try AES(key: uKey, blockMode: ECB())
    let data1 = [UInt8](s.data(using: .utf8)!)
    let encrypted = try aes.encrypt(data1)
    
    //let encrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).encrypt([UInt8](s.data(using: .utf8)!))
    let data: Data = Data(encrypted)
    let e:String = data.base64EncodedString()
    let result = String(e)
    return e//Data(encrypted).base64EncodedString()
    }

func aesDecrypt(cryptString:String, key: String) throws -> String {
    guard let data = Data(base64Encoded: cryptString) else { return "" }
    let decrypted = try AES(key: [UInt8](key.utf8), blockMode: ECB()).decrypt([UInt8](data))
    return String(bytes: decrypted, encoding: .utf8) ?? cryptString
}

func encryptAESHex(message: String, key: String) -> String? {
     if let aes = try? AES(key: [UInt8](key.utf8), blockMode: ECB()),
         let encrypted = try? aes.encrypt(Array<UInt8>(message.utf8)) {
         return encrypted.toHexString()
     }
     return nil
 }

func decryptAESHex(message: String, key: String) -> String? {
     if let aes = try? AES(key: [UInt8](key.utf8), blockMode: ECB()),
         let decrypted = try? aes.decrypt(Array<UInt8>(hex: message)) {
         return String(data: Data(_: decrypted), encoding: .utf8)
     }
     return nil
 }

func encryptAESBase64(message: String, key: String) -> String? {
     if let aes = try? AES(key: [UInt8](key.utf8), blockMode: ECB()),
         let encrypted = try? aes.encrypt(Array<UInt8>(message.utf8)) {
         return encrypted.toBase64()
     }
     return nil
 }

func decryptAESBase64(message: String, key: String) -> String? {
     if let aes = try? AES(key: [UInt8](key.utf8), blockMode: ECB()),
         let decrypted = try? aes.decrypt(Array<UInt8>(base64: message)) {
         return String(data: Data(_: decrypted), encoding: .utf8)
     }
     return nil
 }

func encryptAESUtf8(message: String, key: String) -> String? {
    if let aes = try? AES(key: [UInt8](key.utf8), blockMode: ECB()),
       let encrypted = try? aes.encrypt(Array<UInt8>(message.utf8)) {
        let b64 = encrypted.toBase64()
        guard let data = Data(base64Encoded: b64) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    return nil
}

func decryptAESUtf8(message: String, key: String) -> String? {
    let b64 = Data(message.utf8).base64EncodedString()
    if let aes = try? AES(key: [UInt8](key.utf8), blockMode: ECB()),
       let decrypted = try? aes.decrypt(Array<UInt8>(base64: b64)) {
        return String(data: Data(_: decrypted), encoding: .utf8)
    }
    return nil
}


