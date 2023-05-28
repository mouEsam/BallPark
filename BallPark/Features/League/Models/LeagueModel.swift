//
//  LeagueModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

class LeagueModel {
    private let database: (any AnyLeagueDatabase)
    
    init(database: any AnyLeagueDatabase) {
        self.database = database
    }
    
    func load(leagueIdentity: LeagueIdentity,
              completion: @escaping (Result<SourcedData<League>, Error>) -> Void) {
        localLoad(leagueIdentity, completion: completion)
    }
    
    func toggleFavourite(_ league: League, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(toggleFavouriteImpl(league))
    }
    
    private func toggleFavouriteImpl(_ league: League) -> Result<Void, Error> {
        if league.isFavourite {
            return database.removeFavourite(league)
        } else {
            return database.addFavourite(league)
        }
    }
    
    private func localLoad(_ leagueIdentity: LeagueIdentity,
                            completion: @escaping (Result<SourcedData<League>, Error>) -> Void) {
        let result = database.getById(leagueIdentity.leagueKey)
        completion(result.flatMap({ league in
            if let league = league {
                return .success(.local(league))
            }
            return .failure(NotFoundError())
        }))
    }
}
