//
//  LeagueNotifications.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

struct LeagueFavouriteNotification: AppNotification {
    static var rawName: String = "LeagueFavouriteNotification"
    
    let league: League
    
    init(_ league: League) {
        self.league = league
    }
}
