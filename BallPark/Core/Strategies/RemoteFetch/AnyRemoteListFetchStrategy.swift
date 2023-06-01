//
//  RemoteListFetchStrategy.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 01/06/2023.
//

import Foundation

protocol AnyRemoteListFetchStrategy {
    func fetch<T: Decodable>(_ type: T.Type,
                             url: String,
                             query: [String: Any?],
                             userInfo: [CodingUserInfoKey: Any],
                             dateFormatter: DateFormatter?,
                             completion: @escaping (Result<[T], Error>) -> Void) -> any Cancellable
}

extension AnyRemoteListFetchStrategy {
    func fetch<T: Decodable>(_ type: T.Type,
                             url: String,
                             query: [String: Any?],
                             userInfo: [CodingUserInfoKey: Any],
                             completion: @escaping (Result<[T], Error>) -> Void) -> any Cancellable {
        fetch(type,
              url: url,
              query: query,
              userInfo: userInfo,
              dateFormatter: nil,
              completion: completion)
    }
}
