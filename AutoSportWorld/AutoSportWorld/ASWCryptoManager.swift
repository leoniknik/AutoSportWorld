//
//  ASWCryptoManager.swift
//  AutoSportWorld
//
//  Created by Aleksander Evtuhov on 25.03.2018.
//  Copyright © 2018 Кирилл Володин. All rights reserved.
//

import Foundation
import CryptoSwift

class ASWCryptoManager{
    private static var _iv:String?
    private static var iv:String{
        get{
            if let vector = _iv {
                return vector
            }else{
                _iv = uint8ArrayToString(AES.randomIV(AES.blockSize))
                return _iv!
            }
        }
    }
    private static var secretKey:String = "A60EF3A71A2199F22B21A4332A9FE35BE9B2A4C4726FDDA0176CCDE08FB1CEC3"
    
    static func uint8ArrayToString(_ array:Array<UInt8>)->String{
        if let string = String(bytes: array, encoding: String.Encoding.utf8){
            return string
        }else{
            return ""
        }
    }
    
    static func testHMAC(){
        let key:Array<UInt8> = "key".bytes
        let bytes = "hello привет 123".bytes
        let res = try! HMAC(key: key, variant: .sha256).authenticate(bytes)
        let resHEX = res.toHexString().lowercased()
        var b = resHEX == "A60EF3A71A2199F22B21A4332A9FE35BE9B2A4C4726FDDA0176CCDE08FB1CEC3".lowercased()
        print(b)
    }
    
    static func getHMAC(data:Data)->Array<UInt8>{
        do {
            return try HMAC(key: secretKey, variant: .sha256).authenticate(data.bytes)
        } catch {
            return Array<UInt8>()
        }
    }
    
    static func getHMAC(str:String)->Array<UInt8>{
        do {
            return try HMAC(key: secretKey, variant: .sha256).authenticate(str.bytes)
        } catch {
            return Array<UInt8>()
        }
    }
    
    static func getHMAC(array: Array<UInt8>)->Array<UInt8>{
        do {
            return try HMAC(key: secretKey, variant: .sha256).authenticate(array)
        } catch {
            return Array<UInt8>()
        }
    }
}
