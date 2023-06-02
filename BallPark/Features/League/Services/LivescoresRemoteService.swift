//
//  LivescoresRemoteService.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation
import CoreData

protocol AnyLivescoresRemoteService {
    func fetch<LeagueEvent: AnyLeagueEvent>(_ leagueIdentity: LeagueIdentity,
               completion: @escaping (Result<[LeagueEvent], Error>) -> Void)
}

class LivescoresRemoteService: AnyLivescoresRemoteService {
    
    private let fetchStrategy: any AnyRemoteListFetchStrategy
    private let environment: any AnyEnvironmentProvider
    private let context: NSManagedObjectContext
    private let timezone: TimeZone
    private let dateFormatter = DateFormatter()
    
    
    init(fetchStrategy: some AnyRemoteListFetchStrategy,
         context: NSManagedObjectContext,
         environment: some AnyEnvironmentProvider,
         timezone: TimeZone) {
        self.fetchStrategy = fetchStrategy
        self.context = context
        self.environment = environment
        self.timezone = timezone
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
    }
    
    func fetch<LeagueEvent: AnyLeagueEvent>(_ leagueIdentity: LeagueIdentity,
               completion: @escaping (Result<[LeagueEvent], Error>) -> Void) {
        _ = fetchStrategy.fetch(LeagueEvent.self,
                               url: leagueIdentity.sportType.apiPath,
                               query: ["met":"Livescore",
                                       "leagueId":"\(leagueIdentity.leagueKey)",
                                       "timezone": timezone.identifier,
                                       "APIkey": environment.sportsApiKey],
                               userInfo: [.managedObjectContext: self.context,
                                          .sportType: leagueIdentity.sportType],
                               dateFormatter: dateFormatter,
                               completion: completion)
    }
}
