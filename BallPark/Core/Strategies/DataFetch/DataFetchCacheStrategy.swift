//
//  DataFetchCacheStrategy.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 01/06/2023.
//

import Foundation
import Reachability

class DataFetchCacheStrategy: AnyDataFetchCacheStrategy {
    
    private let connectivity: any AnyConnectivity
    
    init(connectivity: some AnyConnectivity) {
        self.connectivity = connectivity
    }
    
    func fetch<T: Decodable>(_ type: T.Type,
                             remoteFetch: @escaping (@escaping Completion<T>) -> Void,
                             localFetch: @escaping (@escaping Completion<T>) -> Void,
                             localCache: @escaping (T) -> Result<Void, Error>,
                             completion: @escaping (FetchResult<T>) -> Void) {
        if !connectivity.isConnected {
            localFetch { localResult in
                completion(localResult.map { .local($0) })
            }
            return
        }
        remoteFetch { remoteResult in
            if case .success(let remoteData) = remoteResult {
                let cacheResult = localCache(remoteData)
                if case .success(_) = cacheResult {
                    localFetch { localResult in
                        completion(localResult.map { .remote($0) })
                    }
                } else if case .failure(let error) = cacheResult {
                    completion(.success(.remote(remoteData, error)))
                }
            } else if case .failure(let error) = remoteResult {
                localFetch { localResult in
                    completion(localResult.map { .local($0, error) })
                }
            }
        }
    }
}
