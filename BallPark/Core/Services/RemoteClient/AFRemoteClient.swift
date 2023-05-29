//
//  AlamofireRemoteClient.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Alamofire

struct AFRemoteClient: RemoteClient {
    
    let baseUrl: URL
    
    func request(_ method: AnyHttpMethod,
                 path: String,
                 headers: [String: String]?,
                 queryParams: [String: Any]?,
                 completion: @escaping (Result<Data?, Error>) -> Void) -> Cancellable {
        let url = baseUrl.appending(component: path)
        let httpHeaders = headers == nil ? nil : HTTPHeaders(headers!)
        return AF.request(url,
                          method: HTTPMethod(rawValue: method.name),
                          parameters: queryParams,
                          headers: httpHeaders
        ) { urlRequest in
            
        }.response { response in
            completion(response.result.mapError({ error in
                return error as Error
            }))
        }
    }
}

extension HTTPMethod: AnyHttpMethod {
    var name: String { rawValue }
}

extension DataRequest: Cancellable {
    func cancel() {
        super.cancel()
    }
}
