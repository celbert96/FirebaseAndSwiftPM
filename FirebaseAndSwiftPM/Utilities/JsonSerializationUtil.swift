//
//  JsonSerializationUtil.swift
//  FirebaseAndSwiftPM
//
//  Created by Christopher Elbert on 4/5/22.
//

import Foundation

enum JsonSerializationError: Error {
    case encodeFailed
    case decodeFailed
}

class JsonSerializationUtil {
    static func encodeObjectAsJSON<T: Codable>(obj: T) throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(obj)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw JsonSerializationError.encodeFailed
        }
        
        return jsonString
    }
}

