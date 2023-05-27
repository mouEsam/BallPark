//
//  LeaguesModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Reachability

protocol AnyLeaguesModel {
    func load(completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void)
}

class LeaguesModel: AnyLeaguesModel {
    
    private let sportType: SportType
    private let remoteService: LeagueRemoteService
    private let reachability: Reachability?
    private let leaguesDatabase: any AnyLeagueDatabase
    
    init(sportType: SportType,
         remoteService: LeagueRemoteService,
         database: any AnyLeagueDatabase,
         reachability: Reachability?) {
        self.sportType = sportType
        self.remoteService = remoteService
        self.leaguesDatabase = database
        self.reachability = reachability
    }
    
    func load(completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void) {
        if let reachability = self.reachability {
            if reachability.connection == .unavailable {
                completion(localLoad().map({ .local($0) }))
                return
            }
        }
        remoteLoad(completion: completion)
    }
    
    private func remoteLoad(completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void) {
        remoteService.fetch(sportType) { result in
            completion(result.flatMap { remoteLeagues in
                return self.leaguesDatabase.commit().flatMap { _ in
                    self.localLoad().map { .remote($0) }
                }.flatMapError { error in
                        .success(.remote(remoteLeagues, error))
                }
            }.flatMapError({ error in
                self.localLoad().flatMap { remoteLeagues in
                        .success(.local(remoteLeagues, error))
                }
            }))
        }
    }
    
    private func localLoad() -> Result<[League], Error> {
        return leaguesDatabase.getAllBySportType(self.sportType)
    }
}
