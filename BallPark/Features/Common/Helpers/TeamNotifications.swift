//
//  TeamNotifications.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation


struct TeamFavouriteNotification: AppNotification {
    static var rawName: String = "TeamFavouriteNotification"
    
    let team: Team
    
    init(_ team: Team) {
        self.team = team
    }
}
