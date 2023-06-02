//
//  RemoteListFetchStrategy.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 01/06/2023.
//

import Foundation

struct RemoteListFetchStrategy: AnyRemoteListFetchStrategy {
    
    private let remoteClient: any RemoteClient
    private let decoder: any AnyDecoder
    
    init(remoteClient: some RemoteClient,
         decoder: some AnyDecoder) {
        self.remoteClient = remoteClient
        self.decoder = decoder
    }
    
    func fetch<T: Decodable>(_ type: T.Type,
                             url: String,
                             query: [String: Any?],
                             userInfo: [CodingUserInfoKey: Any],
                             dateFormatter: DateFormatter? = nil,
                             completion: @escaping (Result<[T], Error>) -> Void) -> any Cancellable {
        return remoteClient.request(HttpMethod.get,
                                    path: url,
                                    queryParams: query.compactMapValues { $0 }) { result in
            if case let .failure(error) = result {
                completion(.failure(error))
            } else if case let .success(data) = result, let data = data {
                do {
                    print(String(data: data, encoding: .utf8))
                    let response = try self.decoder.decode(target: ListResponse<T>.self,
                                                           data: data,
                                                           userInfo: userInfo,
                                                           dateFormatter: dateFormatter)
                    completion(.success(response.result ?? []))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }
    }
}
