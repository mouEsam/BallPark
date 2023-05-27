//
//  Decoder.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation

protocol AnyDecoder {
    func decode<T: Decodable>(target: T.Type, data: Data, userInfo: [CodingUserInfoKey: Any]?) throws -> T
}

extension AnyDecoder {
    func decode<T: Decodable>(target: T.Type, data: Data, userInfo: [CodingUserInfoKey: Any]? = nil) throws -> T {
        return try decode(target: T.self, data: data, userInfo: userInfo)
    }
}
