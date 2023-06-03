//
//  LeagueModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Reachability

protocol AnyTeamModel {
    func load(teamIdentity: TeamIdentity,
              completion: @escaping (Result<SourcedData<Team>, Error>) -> Void)
    
    func toggleFavourite(_ team: Team, completion: @escaping (Result<Void, Error>) -> Void)
}

class TeamModel: AnyTeamModel {
    private let database: (any AnyTeamDatabase)
    
    init(database: any AnyTeamDatabase) {
        self.database = database
    }
    
    func load(teamIdentity: TeamIdentity,
              completion: @escaping (Result<SourcedData<Team>, Error>) -> Void) {
        localLoad(teamIdentity, completion: completion)
    }
    
    func toggleFavourite(_ team: Team, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(toggleFavouriteImpl(team))
    }
    
    private func toggleFavouriteImpl(_ team: Team) -> Result<Void, Error> {
        if team.isFavourite {
            return database.removeFavourite(team)
        } else {
            return database.addFavourite(team)
        }
    }
    
    private func localLoad(_ teamIdentity: TeamIdentity,
                            completion: @escaping (Result<SourcedData<Team>, Error>) -> Void) {
        let result = database.getById(teamIdentity.teamKey)
        completion(result.flatMap({ team in
            if let team = team {
                return .success(.local(team))
            }
            return .failure(NotFoundError())
        }))
    }
}
