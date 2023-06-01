//
//  RemoteLeagueService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

//  https://apiv2.allsportsapi.com/football/?&met=Fixtures&leagueId=207&from=2021-05-18&to=2021-05-18&APIkey=161cc5f55f286fc875232e256163ad6dfc437500b39b885b4a745fdd79326354

import Foundation
import CoreData

class LeagueEventsRemoteService {
    
    private let fetchStrategy: any AnyRemoteListFetchStrategy
    private let environment: any AnyEnvironmentProvider
    private let context: NSManagedObjectContext
    private let dateFormatter = DateFormatter()
    
    
    init(fetchStrategy: some AnyRemoteListFetchStrategy,
         context: NSManagedObjectContext,
         environment: some AnyEnvironmentProvider) {
        self.fetchStrategy = fetchStrategy
        self.context = context
        self.environment = environment
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    
    func fetch(_ leagueIdentity: LeagueIdentity,
               from: Date,
               to: Date,
               completion: @escaping (Result<[LeagueEvent], Error>) -> Void) {
        _ = fetchStrategy.fetch(LeagueEvent.self,
                               url: leagueIdentity.sportType.apiPath,
                               query: ["met":"Fixtures",
                                       "leagueId":"\(leagueIdentity.leagueKey)",
                                       "from": dateFormatter.string(from: from),
                                       "to": dateFormatter.string(from: to),
                                       "APIkey": environment.sportsApiKey],
                               userInfo: [.managedObjectContext: self.context,
                                          .sportType: leagueIdentity.sportType],
                               dateFormatter: dateFormatter,
                               completion: completion)
    }
}
