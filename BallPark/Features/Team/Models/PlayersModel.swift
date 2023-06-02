//
//  PlayersModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import Reachability

class PlayersModel {
    
    private let remoteService: any AnyPlayersRemoteService
    private let fetchCacheStrategy: any AnyDataFetchCacheStrategy
    private let playersDatabase: any AnyPlayerDatabase
    private let teamsDatabase: any AnyTeamDatabase
    
    init(remoteService: some AnyPlayersRemoteService,
         playersDatabase: some AnyPlayerDatabase,
         teamsDatabase: some AnyTeamDatabase,
         fetchCacheStrategy: some AnyDataFetchCacheStrategy) {
        self.remoteService = remoteService
        self.teamsDatabase = teamsDatabase
        self.playersDatabase = playersDatabase
        self.fetchCacheStrategy = fetchCacheStrategy
    }
    
    func load(teamIdentity: TeamIdentity, completion: @escaping (Result<SourcedData<[Player]>, Error>) -> Void) {
        fetchCacheStrategy.fetch([Player].self,
                                 remoteFetch: { self.remoteService.fetch(teamIdentity, completion: $0) },
                                 localFetch: { $0(self.playersDatabase.getAllByTeam(teamIdentity.teamKey)) },
                                 localCache: { self.teamsDatabase.addPlayersToTeam(teamIdentity.teamKey, $0) },
                                 completion: completion)
    }
}
