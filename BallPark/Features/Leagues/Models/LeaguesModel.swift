//
//  LeaguesModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Reachability

class LeaguesModel {

    private let remoteService: LeaguesRemoteService
    private let reachability: Reachability?
    private let leaguesDatabase: any AnyLeagueDatabase
    
    init(remoteService: LeaguesRemoteService,
         database: some AnyLeagueDatabase,
         reachability: Reachability?) {
        self.remoteService = remoteService
        self.leaguesDatabase = database
        self.reachability = reachability
    }
    
    func load(sportType: SportType, completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void) {
        if let reachability = self.reachability {
            if reachability.connection == .unavailable {
                completion(localLoad(sportType).map({ .local($0) }))
                return
            }
        }
        remoteLoad(sportType, completion: completion)
    }
    
    private func remoteLoad(_ sportType: SportType, completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void) {
        remoteService.fetch(sportType) { result in
            completion(result.flatMap { remoteLeagues in
                return self.leaguesDatabase.commit().flatMap { _ in
                    self.localLoad(sportType).map { .remote($0) }
                }.flatMapError { error in
                        .success(.remote(remoteLeagues, error))
                }
            }.flatMapError({ error in
                self.localLoad(sportType).flatMap { remoteLeagues in
                        .success(.local(remoteLeagues, error))
                }
            }))
        }
    }
    
    private func localLoad(_ sportType: SportType) -> Result<[League], Error> {
        return leaguesDatabase.getAllBySportType(sportType)
    }
}
