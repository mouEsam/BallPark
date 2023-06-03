//
//  MockRemoteClient.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
@testable import BallPark

class MockRemoteClient: RemoteClient {
    
    var result: Result<Data?, Error>! = nil
    
    var client: (any RemoteClient)?
    
    func request(_ method: AnyHttpMethod,
                 path: String,
                 headers: [String: String]?,
                 queryParams: [String: Any]?,
                 completion: @escaping (Result<Data?, Error>) -> Void) -> Cancellable {
        if let client = client {
            return client.request(method,
                                  path: path,
                                  headers: headers,
                                  queryParams: queryParams,
                                  completion: completion)
        } else {
            completion(result)
            return MockCancellabel()
        }
    }
}


struct MockCancellabel: Cancellable {
    func cancel() {}
}
