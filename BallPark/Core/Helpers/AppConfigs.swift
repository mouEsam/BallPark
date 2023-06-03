//
//  AppConfigs.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation

struct AppConfigs {
    private init() {}
    
    static let maxApiIntervalDays = 365
    static let baseUrl = URL(string: "https://apiv2.allsportsapi.com/")!
}
