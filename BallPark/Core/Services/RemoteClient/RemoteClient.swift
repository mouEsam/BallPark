//
//  RemoteClient.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation

protocol AnyHttpMethod {
    var name: String { get }
}

extension String: AnyHttpMethod {
    var name: String { self }
}

struct HttpMethod: AnyHttpMethod {
    let name: String
}

extension HttpMethod {
    static let get: HttpMethod = HttpMethod(name: "GET")
}

protocol Cancellable {
    func cancel()
}

protocol RemoteClient {
    func request(_ method: AnyHttpMethod,
                 path: String,
                 headers: [String: String]?,
                 queryParams: [String: Any]?,
                 completion: @escaping (Result<Data?, Error>) -> Void) -> Cancellable
}

extension RemoteClient {
    func request(_ method: AnyHttpMethod,
                 path: String,
                 headers: [String: String]? = nil,
                 queryParams: [String: Any]? = nil,
                 completion: @escaping (Result<Data?, Error>) -> Void) -> Cancellable {
        return request(method, path: path, headers: headers, queryParams: queryParams, completion: completion)
    }
}
