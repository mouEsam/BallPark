//
//  JsonDecoder.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation

struct JsonDecoder: AnyDecoder {
    func decode<T: Decodable>(target: T.Type, data: Data, userInfo: [CodingUserInfoKey: Any]? = nil) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.userInfo = userInfo ?? [:]
        return try jsonDecoder.decode(target, from: data)
    }
}
