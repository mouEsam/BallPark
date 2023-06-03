//
//  MockPlayersRemoteService.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
@testable import BallPark

class MockPlayersRemoteService: AnyPlayersRemoteService {
    
    var result: Result<[BallPark.Player], Error>? = nil
    var service: (any AnyPlayersRemoteService)? = nil
    
    func fetch(_ teamIdentity: BallPark.TeamIdentity, completion: @escaping (Result<[BallPark.Player], Error>) -> Void) {
        if let service = service {
            service.fetch(teamIdentity, completion: completion)
        } else {
            completion(result!)
        }
    }
}
