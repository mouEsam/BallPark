//
//  TennisEvents.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation

struct LeagueEventsNotification: AppNotification {
    static var rawName: String = "LeagueEventsNotification"

    let leagueIdentity: LeagueIdentity
    let eventRangeType: EventsRangeType
    let state: UIState<[any AnyLeagueEvent]>
    
    init(leagueIdentity: LeagueIdentity,
         eventRangeType: EventsRangeType,
         state: UIState<[any AnyLeagueEvent]>) {
        self.leagueIdentity = leagueIdentity
        self.eventRangeType = eventRangeType
        self.state = state
    }
}
