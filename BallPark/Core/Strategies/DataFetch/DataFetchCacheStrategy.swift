//
//  DataFetchCacheStrategy.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 01/06/2023.
//

import Foundation
import Reachability

class DataFetchCacheStrategy: AnyDataFetchCacheStrategy {
    
    private let reachability: Reachability?
    
    init(reachability: Reachability?) {
        self.reachability = reachability
    }
    
    func fetch<T: Decodable>(_ type: T.Type,
                             remoteFetch: @escaping (@escaping Completion<T>) -> Void,
                             localFetch: @escaping (@escaping Completion<T>) -> Void,
                             localCache: @escaping (T) -> Result<Void, Error>,
                             completion: @escaping (FetchResult<T>) -> Void) {
        if let reachability = self.reachability {
            if reachability.connection == .unavailable {
                localFetch { localResult in
                    completion(localResult.map { .local($0) })
                }
                return
            }
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
