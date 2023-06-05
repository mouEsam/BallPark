//
//  MockLeagueModel.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 06/06/2023.
//

import Foundation
@testable import BallPark

class MockLeagueModel: AnyLeagueModel {
    
    var model: AnyLeagueModel? = nil
    
    var loadResult: Result<SourcedData<League>, Error>!
    var toggleFavouriteResult: Result<Void, Error>!
    
    func load(leagueIdentity: LeagueIdentity,
              completion: @escaping (Result<SourcedData<League>, Error>) -> Void) {
        if let model = model {
            model.load(leagueIdentity: leagueIdentity, completion: completion)
        } else {
            return completion(loadResult)
        }
    }
    
    func toggleFavourite(_ league: League, completion: @escaping (Result<Void, Error>) -> Void) {
        if let model = model {
            model.toggleFavourite(league, completion: completion)
        } else {
            return completion(toggleFavouriteResult)
        }
    }
}
