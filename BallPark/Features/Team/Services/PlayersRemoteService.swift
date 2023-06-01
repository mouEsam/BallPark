//
//  PlayersRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import CoreData

// https://apiv2.allsportsapi.com/football/?&met=Players&teamId=640&APIkey=161cc5f55f286fc875232e256163ad6dfc437500b39b885b4a745fdd79326354

class PlayersRemoteService {
    
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
    
    func fetch(_ teamIdentity: TeamIdentity,
               completion: @escaping (Result<[Player], Error>) -> Void) {
        _ = fetchStrategy.fetch(Player.self,
                                url: teamIdentity.sportType.apiPath,
                                query: ["met":"Players",
                                        "teamId":"\(teamIdentity.teamKey)",
                                        "APIkey": environment.sportsApiKey],
                                userInfo: [.managedObjectContext: self.context,
                                           .leagueKey: teamIdentity.teamKey],
                                completion: completion)
    }
}
