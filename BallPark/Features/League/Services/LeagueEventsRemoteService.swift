//
//  RemoteLeagueService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import CoreData

class LeagueEventsRemoteService {
    
    private let environment: any AnyEnvironmentProvider
    private let remoteClient: any RemoteClient
    private let decoder: any AnyDecoder
    private let context: NSManagedObjectContext
    private let dateFormatter = DateFormatter()
    
    
    init(remoteClient: some RemoteClient,
         decoder: some AnyDecoder,
         context: NSManagedObjectContext,
         environment: some AnyEnvironmentProvider) {
        self.remoteClient = remoteClient
        self.decoder = decoder
        self.context = context
        self.environment = environment
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func fetch(_ leagueIdentity: LeagueIdentity,
               from: Date? = nil,
               to: Date? = nil,
               completion: @escaping (Result<[LeagueEvent], Error>) -> Void) {
        let query = ["met":"Fixtures",
                     "leagueId":"\(leagueIdentity.leagueKey)",
                     "from": from.flatMap(dateFormatter.string(from:)),
                     "to": to.flatMap(dateFormatter.string(from:)),
                     "APIkey": environment.sportsApiKey].compactMapValues { $0 }
        _ = remoteClient.request(HttpMethod.get,
                                 path: leagueIdentity.sportType.apiPath,
                                 queryParams: query) { result in
            if case let .failure(error) = result {
                completion(.failure(error))
            } else if case let .success(data) = result, let data = data {
                do {
                    let response = try self.decoder.decode(target: ListResponse<LeagueEvent>.self,
                                                           data: data,
                                                           userInfo: [.managedObjectContext: self.context,
                                                                      .sportType: leagueIdentity.sportType],
                                                           dateFormatter: self.dateFormatter)
                    completion(.success(response.result ?? []))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
