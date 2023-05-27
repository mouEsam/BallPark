//
//  FavouriteLeaguesModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation

class FavouriteLeaguesModel: AnyLeaguesModel {
    
    private let favouriteLeagueDatabase: any FavouritesDatabase<League>
    
    init(database: any FavouritesDatabase<League>) {
        self.favouriteLeagueDatabase = database
    }
    
    func load(completion: @escaping (Result<SourcedData<[League]>, Error>) -> Void) {
        completion(favouriteLeagueDatabase.getAllFavourites().map { leagues in
                .local(leagues)
        })
    }
}
