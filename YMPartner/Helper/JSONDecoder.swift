//
//  JSONDecoder.swift
//  YMSupport
//
//  Created by Kauntey Suryawanshi on 19/05/21.
//

import Foundation

class YMJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .custom { decoder in
            if let stringDate = try? decoder.singleValueContainer().decode(String.self) {
                let form = ISO8601DateFormatter()
                form.formatOptions.insert(.withFractionalSeconds)
                return form.date(from: stringDate) ?? Date()
            } else if let data = try? decoder.singleValueContainer().decode(Int.self) {
                return Date(timeIntervalSince1970: Double(data / 1000))
            }
            return Date()
        }
    }
}
