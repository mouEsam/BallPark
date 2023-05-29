//
//  JsonDecoder.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation

struct JsonDecoder: AnyDecoder {
    func decode<T: Decodable>(target: T.Type, data: Data, userInfo: [CodingUserInfoKey: Any]? = nil, dateFormatter: DateFormatter? = nil) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo = userInfo ?? [:]
        jsonDecoder.dateDecodingStrategy = dateFormatter.map { .formatted($0) } ?? jsonDecoder.dateDecodingStrategy
        return try jsonDecoder.decode(target, from: data)
    }
}
