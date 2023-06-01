//
//  TeamsModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Reachability

class TeamsModel {
    
    private let remoteService: TeamsRemoteService
    private let fetchCacheStrategy: any AnyDataFetchCacheStrategy
    private let teamsDatabase: any AnyTeamDatabase
    private let leagueDatabase: any AnyLeagueDatabase
    
    init(remoteService: TeamsRemoteService,
         teamsDatabase: some AnyTeamDatabase,
         leagueDatabase: some AnyLeagueDatabase,
         fetchCacheStrategy: some AnyDataFetchCacheStrategy) {
        self.remoteService = remoteService
        self.teamsDatabase = teamsDatabase
        self.leagueDatabase = leagueDatabase
        self.fetchCacheStrategy = fetchCacheStrategy
    }
    
    func load(leagueIdentity: LeagueIdentity, completion: @escaping (Result<SourcedData<[Team]>, Error>) -> Void) {
        fetchCacheStrategy.fetch(remoteFetch: { self.remoteService.fetch(leagueIdentity, completion: $0) },
                                 localFetch: { $0(self.teamsDatabase.getAllByLeague(leagueIdentity.leagueKey)) },
                                 localCache: { self.leagueDatabase.addTeamsToLeague(leagueIdentity.leagueKey, $0) },
                                 completion: completion)
    }
}
