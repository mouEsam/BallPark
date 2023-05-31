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
    private let reachability: Reachability?
    private let teamsDatabase: any AnyTeamDatabase
    private let leagueDatabase: any AnyLeagueDatabase
    
    init(remoteService: TeamsRemoteService,
         teamsDatabase: some AnyTeamDatabase,
         leagueDatabase: some AnyLeagueDatabase,
         reachability: Reachability?) {
        self.remoteService = remoteService
        self.teamsDatabase = teamsDatabase
        self.leagueDatabase = leagueDatabase
        self.reachability = reachability
    }
    
    func load(leagueIdentity: LeagueIdentity, completion: @escaping (Result<SourcedData<[Team]>, Error>) -> Void) {
        if let reachability = self.reachability {
            if reachability.connection == .unavailable {
                completion(localLoad(leagueIdentity).map({ .local($0) }))
                return
            }
        }
        remoteLoad(leagueIdentity, completion: completion)
    }
    
    private func remoteLoad(_ leagueIdentity: LeagueIdentity, completion: @escaping (Result<SourcedData<[Team]>, Error>) -> Void) {
        remoteService.fetch(leagueIdentity) { result in
            completion(result.flatMap { remoteTeams in
                return self.leagueDatabase.addTeamsToLeague(leagueIdentity.leagueKey, remoteTeams)
                    .flatMap { _ in
                        self.localLoad(leagueIdentity).map { .remote($0) }
                    }.flatMapError { error in
                            .success(.remote(remoteTeams, error))
                    }
            }.flatMapError({ error in
                self.localLoad(leagueIdentity).flatMap { localTeams in
                        .success(.local(localTeams, error))
                }
            }))
        }
    }
    
    private func localLoad(_ leagueIdentity: LeagueIdentity) -> Result<[Team], Error> {
        return teamsDatabase.getAllByLeague(leagueIdentity.leagueKey)
    }
}
