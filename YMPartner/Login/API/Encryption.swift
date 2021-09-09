//
//  Encryption.swift
//  YMSupport
//
//  Created by Kauntey Suryawanshi on 20/04/21.
//

import Foundation
import CryptoSwift

struct Encryption {
    let key: String

    func encrypt(_ value: String) throws -> String {
        let decodedData = Data(base64Encoded: key)!

        let key: [UInt8] = Array(decodedData.bytes) as [UInt8]
        let iv: [UInt8] = [UInt8](repeating: 0, count: 16)

        let aes = try AES(key: key, blockMode: CBC(iv: iv) , padding: .pkcs5)
        let encryptedBytes = try aes.encrypt(value.bytes)
        let encryptedData = Data(encryptedBytes)
        return encryptedData.base64EncodedString()
//        return ""
    }
}
