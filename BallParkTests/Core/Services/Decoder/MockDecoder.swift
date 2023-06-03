//
//  MockDecoder.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
@testable import BallPark

class MockDecoder: AnyDecoder {
    
    var result: Any? = nil
    
    var decoder: (any AnyDecoder)? = nil
    
    func decode<T: Decodable>(target: T.Type, data: Data, userInfo: [CodingUserInfoKey: Any]? = nil, dateFormatter: DateFormatter? = nil) throws -> T {
        if let decoder = decoder {
            return try decoder.decode(target: target,
                                      data: data,
                                      userInfo: userInfo,
                                      dateFormatter: dateFormatter)
        }
        return result as! T
    }
}
