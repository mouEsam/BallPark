//
//  TennisModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation

class LeaguePlayersModel: AnyLeaguePlayersModel {
   
   private let remoteService: any AnyLeaguePlayersRemoteService
   private let fetchCacheStrategy: any AnyDataFetchCacheStrategy
   private let playersDatabase: any AnyPlayerDatabase
   private let leagueDatabase: any AnyLeagueDatabase
   
   var sectionTitleKey: String { "Players" }
   var emptyMessageKey: String { "No players found" }
    
   init(remoteService: some AnyLeaguePlayersRemoteService,
        playersDatabase: some AnyPlayerDatabase,
        leagueDatabase: some AnyLeagueDatabase,
        fetchCacheStrategy: some AnyDataFetchCacheStrategy) {
       self.remoteService = remoteService
       self.playersDatabase = playersDatabase
       self.leagueDatabase = leagueDatabase
       self.fetchCacheStrategy = fetchCacheStrategy
   }
   
   func load(leagueIdentity: LeagueIdentity, completion: @escaping (Result<SourcedData<[Player]>, Error>) -> Void) {
       fetchCacheStrategy.fetch([Player].self,
                                remoteFetch: { self.remoteService.fetch(leagueIdentity, completion: $0) },
                                localFetch: { $0(self.playersDatabase.getAllByLeague(leagueIdentity.leagueKey)) },
                                localCache: { self.leagueDatabase.addPlayersToLeague(leagueIdentity.leagueKey, $0) },
                                completion: completion)
   }
}
