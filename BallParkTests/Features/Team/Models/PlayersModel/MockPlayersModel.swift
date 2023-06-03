//
//  MockPlayersModel.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
@testable import BallPark

class MockPlayersModel: AnyPlayersModel {
    
    var model: (any AnyPlayersModel)? = nil
    
    var result: Result<BallPark.SourcedData<[BallPark.Player]>, Error>! = nil
    
    func load(teamIdentity: BallPark.TeamIdentity, completion: @escaping (Result<BallPark.SourcedData<[BallPark.Player]>, Error>) -> Void) {
        if let model = model {
            model.load(teamIdentity: teamIdentity, completion: completion)
        } else {
            completion(result)
        }
    }
}
