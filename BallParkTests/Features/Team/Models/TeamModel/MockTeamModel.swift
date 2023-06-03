//
//  MockTeamModel.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
@testable import BallPark

class MockTeamModel: AnyTeamModel {
    
    var model: (any AnyTeamModel)? = nil
    
    var loadResult: Result<BallPark.SourcedData<BallPark.Team>, Error>! = nil
    var toggleFavouriteResult: Result<Void, Error>! = nil
    
    func load(teamIdentity: BallPark.TeamIdentity, completion: @escaping (Result<BallPark.SourcedData<BallPark.Team>, Error>) -> Void) {
        if let model = model {
            model.load(teamIdentity: teamIdentity, completion: completion)
        } else {
            completion(loadResult)
        }
    }
    
    func toggleFavourite(_ team: BallPark.Team, completion: @escaping (Result<Void, Error>) -> Void) {
        if let model = model {
            model.toggleFavourite(team, completion: completion)
        } else {
            completion(toggleFavouriteResult)
        }
    }
}
