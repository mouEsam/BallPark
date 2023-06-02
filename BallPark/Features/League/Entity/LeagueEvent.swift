//
//  LeagueEvent.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

struct LeagueEvent: AnyLeagueEvent {
    
    let eventDetails: EventDetails
    let leagueDetails: LeagueDetails
    let homeTeam: MiniTeam
    let awayTeam: MiniTeam
    let sportType: SportType
    
    var firstSide: MiniTeam { homeTeam }
    var secondSide: MiniTeam { awayTeam }
    
    init(from decoder: Decoder) throws {
        self.eventDetails = try decoder.singleValueContainer().decode(EventDetails.self)
        self.leagueDetails = try decoder.singleValueContainer().decode(LeagueDetails.self)
        self.homeTeam = try MiniTeam.initHome(from: decoder)
        self.awayTeam = try MiniTeam.initAway(from: decoder)
        self.sportType = decoder.userInfo[CodingUserInfoKey.sportType] as! SportType
    }
    
    struct MiniTeam: AnyLeagueEventSide {
        let key: Int64
        let name: String
        let logo: String?
        
        init(key: Int64, name: String, logo: String?) {
            self.key = key
            self.name = name
            self.logo = logo
        }
    }
}

extension LeagueEvent.MiniTeam {
    static func initHome(from decoder: Decoder) throws -> Self {
        let container = try decoder.container(keyedBy: HomeCodingKeys.self)
        let key = try [.key, .cricketKey, .tennisKey].map({ try container.decodeIfPresent(Int64.self, forKey: $0) }).compactMap{$0}.first!
        let name = try [.name, .tennisName].map({ try container.decodeIfPresent(String.self, forKey: $0) }).compactMap{$0}.first!
        let logo = try [.logo, .tennisLogo, .cricketLogo].map({ try container.decodeIfPresent(String.self, forKey: $0)?.nilIfBlank() }).compactMap{$0}.first
        return LeagueEvent.MiniTeam(key: key, name: name, logo: logo)
    }
    
    static func initAway(from decoder: Decoder) throws -> Self {
        let container = try decoder.container(keyedBy: AwayCodingKeys.self)
        let key = try [.key, .cricketKey, .tennisKey].map({ try container.decodeIfPresent(Int64.self, forKey: $0) }).compactMap{$0}.first!
        let name = try [.name, .tennisName].map({ try container.decodeIfPresent(String.self, forKey: $0) }).compactMap{$0}.first!
        let logo = try [.logo, .tennisLogo, .cricketLogo].map({ try container.decodeIfPresent(String.self, forKey: $0)?.nilIfBlank() }).compactMap{$0}.first
        return LeagueEvent.MiniTeam(key: key, name: name, logo: logo)
    }
    
    enum HomeCodingKeys: String, CodingKey {
        case key = "home_team_key"
        case cricketKey = "event_home_team_key"
        case tennisKey = "event_first_team_key"
        case name = "event_home_team"
        case tennisName = "event_first_team"
        case logo = "home_team_logo"
        case tennisLogo = "event_first_team_logo"
        case cricketLogo = "event_home_team_logo"
    }
    
    enum AwayCodingKeys: String, CodingKey {
        case key = "away_team_key"
        case cricketKey = "event_away_team_key"
        case tennisKey = "event_second_team_key"
        case name = "event_away_team"
        case tennisName = "event_second_team"
        case logo = "away_team_logo"
        case tennisLogo = "event_second_team_logo"
        case cricketLogo = "event_away_team_logo"
    }
}
