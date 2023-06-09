//
//  LeaguesModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Reachability

class LeaguesModel {

    private let remoteService: any AnyLeaguesRemoteService
    private let fetchCacheStrategy: any AnyDataFetchCacheStrategy
    private let leaguesDatabase: any AnyLeagueDatabase
    
    init(remoteService: some AnyLeaguesRemoteService,
         database: some AnyLeagueDatabase,
         fetchCacheStrategy: some AnyDataFetchCacheStrategy) {
        self.remoteService = remoteService
        self.leaguesDatabase = database
        self.fetchCacheStrategy = fetchCacheStrategy
    }
    
    func load(sportType: SportType, completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void) {
        fetchCacheStrategy.fetch([League].self,
                                 remoteFetch: { self.remoteService.fetch(sportType, completion: $0) },
                                 localFetch: { $0(self.leaguesDatabase.getAllBySportType(sportType)) },
                                 localCache: { _ in self.leaguesDatabase.commit() },
                                 completion: completion)
    }
}
