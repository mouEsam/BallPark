//
//  MockAnyPlayer.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 05/06/2023.
//

import Foundation
@testable import BallPark

class MockLeagueEventSide: AnyLeagueEventSide, Decodable {
    
    var keyResult: Int64!
    var nameResult: String!
    var logoResult: String!
    var sportTypeResult: BallPark.SportType!
    
    required init(from decoder: Decoder) throws {}
    
    init() {}
    
}

extension MockLeagueEventSide {
    var key: Int64 { keyResult }
    var name: String? { nameResult }
    var logo: String? { logoResult }
}

extension MockLeagueEventSide: AnyPlayer {
    var sportType: SportType? { sportTypeResult }
}
