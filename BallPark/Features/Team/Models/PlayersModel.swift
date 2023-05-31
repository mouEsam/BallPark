//
//  PlayersModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import Reachability

class PlayersModel {
    
    private let remoteService: PlayersRemoteService
    private let reachability: Reachability?
    private let playersDatabase: any AnyPlayerDatabase
    private let teamsDatabase: any AnyTeamDatabase
    
    init(remoteService: PlayersRemoteService,
         playersDatabase: some AnyPlayerDatabase,
         teamsDatabase: some AnyTeamDatabase,
         reachability: Reachability?) {
        self.remoteService = remoteService
        self.teamsDatabase = teamsDatabase
        self.playersDatabase = playersDatabase
        self.reachability = reachability
    }
    
    func load(teamIdentity: TeamIdentity, completion: @escaping (Result<SourcedData<[Player]>, Error>) -> Void) {
        if let reachability = self.reachability {
            if reachability.connection == .unavailable {
                completion(localLoad(teamIdentity).map({ .local($0) }))
                return
            }
        }
        remoteLoad(teamIdentity, completion: completion)
    }
    
    private func remoteLoad(_ teamIdentity: TeamIdentity, completion: @escaping (Result<SourcedData<[Player]>, Error>) -> Void) {
        remoteService.fetch(teamIdentity) { result in
            completion(result.flatMap { remotePlayers in
                return self.teamsDatabase.addPlayersToTeam(teamIdentity.teamKey, remotePlayers)
                    .flatMap { _ in
                        self.localLoad(teamIdentity).map { .remote($0) }
                    }.flatMapError { error in
                            .success(.remote(remotePlayers, error))
                    }
            }.flatMapError({ error in
                print(error)
                return self.localLoad(teamIdentity).flatMap { localTeams in
                        .success(.local(localTeams, error))
                }
            }))
        }
    }
    
    private func localLoad(_ teamIdentity: TeamIdentity) -> Result<[Player], Error> {
        return playersDatabase.getAllByTeam(teamIdentity.teamKey)
    }
}

