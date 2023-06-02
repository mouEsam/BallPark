//
//  PlayersRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation
import CoreData

protocol AnyLeaguePlayersRemoteService  {
    func fetch(_ leagueIdentity: LeagueIdentity,
               completion: @escaping (Result<[Player], Error>) -> Void)
}

class LeaguePlayersRemoteService: AnyLeaguePlayersRemoteService  {
    
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
    
    func fetch(_ leagueIdentity: LeagueIdentity,
               completion: @escaping (Result<[Player], Error>) -> Void) {
        _ = fetchStrategy.fetch(Player.self,
                                url: leagueIdentity.sportType.apiPath,
                                query: ["met":"Players",
                                        "leagueId":"\(leagueIdentity.leagueKey)",
                                        "APIkey": environment.sportsApiKey],
                                userInfo: [.managedObjectContext: self.context,
                                           .sportType: leagueIdentity.sportType,
                                           .leagueKey: leagueIdentity.leagueKey],
                                completion: completion)
    }
}
