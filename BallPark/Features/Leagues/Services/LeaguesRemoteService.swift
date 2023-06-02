//
//  LeagueRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import CoreData

//  https://apiv2.allsportsapi.com/football/?&met=Leagues&APIkey=161cc5f55f286fc875232e256163ad6dfc437500b39b885b4a745fdd79326354

protocol AnyLeaguesRemoteService {
    func fetch(_ sportType: SportType, completion: @escaping (Result<[League], Error>) -> Void)
}

class LeaguesRemoteService: AnyLeaguesRemoteService {
    
    private let environment: any AnyEnvironmentProvider
    private let fetchStrategy: any AnyRemoteListFetchStrategy
    private let context: NSManagedObjectContext
    
    init(fetchStrategy: some AnyRemoteListFetchStrategy,
         context: NSManagedObjectContext,
         environment: some AnyEnvironmentProvider) {
        self.fetchStrategy = fetchStrategy
        self.context = context
        self.environment = environment
    }
    
    func fetch(_ sportType: SportType, completion: @escaping (Result<[League], Error>) -> Void) {
        _ = fetchStrategy.fetch(League.self,
                                url: sportType.apiPath,
                                query: ["met":"Leagues",
                                        "APIkey": environment.sportsApiKey],
                                userInfo: [.managedObjectContext: self.context,
                                           .sportType: sportType],
                                completion: completion)
    }
}
