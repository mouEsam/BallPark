//
//  AnyDataFetchCacheStrategy.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 01/06/2023.
//

import Foundation

protocol AnyDataFetchCacheStrategy {
    typealias FetchResult<T> = Result<SourcedData<T>, Error>
    typealias Completion<T> = (Result<T, Error>) -> Void
    
    func fetch<T: Decodable>(
        _ type: T.Type,
        remoteFetch: @escaping (@escaping Completion<T>) -> Void,
        localFetch: @escaping (@escaping Completion<T>) -> Void,
        localCache: @escaping (T) -> Result<Void, Error>,
        completion: @escaping (FetchResult<T>) -> Void
    )
}
