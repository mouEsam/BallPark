//
//  TeamsRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import CoreData

//  https://apiv2.allsportsapi.com/football/?&met=Teams&leagueId=207&APIkey=161cc5f55f286fc875232e256163ad6dfc437500b39b885b4a745fdd79326354

class TeamsRemoteService {
    
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
               completion: @escaping (Result<[Team], Error>) -> Void) {
        _ = fetchStrategy.fetch(Team.self,
                                url: leagueIdentity.sportType.apiPath,
                                query: ["met":"Teams",
                                        "leagueId":"\(leagueIdentity.leagueKey)",
                                        "APIkey": environment.sportsApiKey],
                                userInfo: [.managedObjectContext: self.context,
                                           .leagueKey: leagueIdentity.leagueKey],
                                completion: completion)
    }
}
