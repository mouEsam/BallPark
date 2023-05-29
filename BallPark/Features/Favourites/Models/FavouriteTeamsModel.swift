//
//  FavouriteTeamsModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation

class FavouriteTeamsModel {
    
    private let favouriteTeamDatabase: any FavouritesDatabase<Team>
    
    init(database: some FavouritesDatabase<Team>) {
        self.favouriteTeamDatabase = database
    }
    
    func load(completion: @escaping (Result<SourcedData<[Team]>, Error>) -> Void) {
        completion(favouriteTeamDatabase.getAllFavourites().map { teams in
                .local(teams)
        })
    }
}

