//
//  LeagueRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import CoreData

class LeaguesRemoteService {
    
    private let environment: any AnyEnvironmentProvider
    private let remoteClient: any RemoteClient
    private let decoder: any AnyDecoder
    private let context: NSManagedObjectContext
    
    init(remoteClient: some RemoteClient, decoder: some AnyDecoder, context: NSManagedObjectContext, environment: some AnyEnvironmentProvider) {
        self.remoteClient = remoteClient
        self.decoder = decoder
        self.context = context
        self.environment = environment
    }
    
    func fetch(_ sportType: SportType, completion: @escaping (Result<[League], Error>) -> Void) {
        _ = remoteClient.request(HttpMethod.get,
                                 path: sportType.apiPath,
                                 queryParams: ["met":"Leagues", "APIkey": environment.sportsApiKey]) { result in
            if case let .failure(error) = result {
                completion(.failure(error))
            } else if case let .success(data) = result, let data = data {
                do {
                    let response = try self.decoder.decode(target: ListResponse<League>.self,
                                                           data: data,
                                                           userInfo: [.managedObjectContext: self.context, .sportType: sportType])
                    completion(.success(response.result ?? []))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
