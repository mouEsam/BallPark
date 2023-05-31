//
//  PlayersRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import CoreData

// https://apiv2.allsportsapi.com/basketball/?&met=Players&teamId=640&APIkey=161cc5f55f286fc875232e256163ad6dfc437500b39b885b4a745fdd79326354

class PlayersRemoteService {
    
    private let environment: any AnyEnvironmentProvider
    private let remoteClient: any RemoteClient
    private let decoder: any AnyDecoder
    private let context: NSManagedObjectContext
    
    init(remoteClient: some RemoteClient,
         decoder: some AnyDecoder,
         context: NSManagedObjectContext,
         environment: some AnyEnvironmentProvider) {
        self.remoteClient = remoteClient
        self.decoder = decoder
        self.context = context
        self.environment = environment
    }
    
    func fetch(_ teamIdentity: TeamIdentity,
               completion: @escaping (Result<[Player], Error>) -> Void) {
        print(teamIdentity)
        let query = ["met":"Players",
                     "teamId":"\(teamIdentity.teamKey)",
                     "APIkey": environment.sportsApiKey].compactMapValues { $0 }
        _ = remoteClient.request(HttpMethod.get,
                                 path: teamIdentity.sportType.apiPath,
                                 queryParams: query) { result in
            if case let .failure(error) = result {
                completion(.failure(error))
            } else if case let .success(data) = result, let data = data {
                do {
                    let response = try self.decoder.decode(target: ListResponse<Player>.self,
                                                           data: data,
                                                           userInfo: [.managedObjectContext: self.context,
                                                                      .leagueKey: teamIdentity.teamKey])
                    completion(.success(response.result ?? []))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
