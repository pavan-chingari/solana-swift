//
//  Data+Extensions.swift
//  p2p_wallet
//
//  Created by Chung Tran on 10/26/20.
//

import Foundation

public extension Data {
    var decodedLength: Int {
        var len = 0
        var size = 0
        var bytes = self
        while true {
            guard let elem = bytes.first else {break}
            bytes = bytes.dropFirst()
            len = len | ((Int(elem) & 0x7f) << (size * 7))
            size += 1
            if Int16(elem) & 0x80 == 0 {
                break
            }
        }
        return len
    }
    
    mutating func decodeLength() throws -> Int {
        var len = 0
        var size = 0
        while true {
            guard let elem = bytes.first else { break }
            try popFirst()
            len = len | ((Int(elem) & 0x7f) << (size * 7))
            size += 1
            if Int16(elem) & 0x80 == 0 {
                break
            }
        }
        return len
    }
    
    static func encodeLength(_ len: Int) -> Data {
        encodeLength(UInt(len))
    }
    
    private static func encodeLength(_ len: UInt) -> Data {
        var rem_len = len
        var bytes = Data()
        while true {
            var elem = rem_len & 0x7f
            rem_len = rem_len >> 7
            if rem_len == 0 {
                bytes.append(UInt8(elem))
                break
            } else {
                elem = elem | 0x80
                bytes.append(UInt8(elem))
            }
        }
        return bytes
    }
}

extension Encodable {
    var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self) else {return nil}
        return String(data: data, encoding: .utf8)
    }
}
