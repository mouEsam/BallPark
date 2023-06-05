//
//  MockLeagueEvent.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 05/06/2023.
//

import Foundation
@testable import BallPark

class MockLeagueEvent: AnyLeagueEvent {
    var eventDetailsResult: BallPark.EventDetails!
    var leagueDetailsResult: BallPark.LeagueDetails!
    var sportTypeResult: BallPark.SportType!
    var firstSideResult: MockLeagueEventSide!
    var secondSideResult: MockLeagueEventSide!
    
    required init(from decoder: Decoder) throws {}
    
    init() {}
}

extension MockLeagueEvent {
    var eventDetails: BallPark.EventDetails { eventDetailsResult }
    var leagueDetails: BallPark.LeagueDetails  { leagueDetailsResult }
    var sportType: BallPark.SportType  { sportTypeResult }
    var firstSide: MockLeagueEventSide  { firstSideResult }
    var secondSide: MockLeagueEventSide  { secondSideResult }
}
