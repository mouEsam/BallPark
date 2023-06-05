//
//  TennisEvent.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation

struct TennisEvent: AnyLeagueEvent {
    
    let eventDetails: EventDetails
    let leagueDetails: LeagueDetails
    let firstSide: MiniPlayer
    let secondSide: MiniPlayer
    let sportType: SportType
    
    init(from decoder: Decoder) throws {
        self.eventDetails = try decoder.singleValueContainer().decode(EventDetails.self)
        self.leagueDetails = try decoder.singleValueContainer().decode(LeagueDetails.self)
        self.firstSide = try MiniPlayer.initFirst(from: decoder)
        self.secondSide = try MiniPlayer.initSecond(from: decoder)
        self.sportType = decoder.userInfo[CodingUserInfoKey.sportType] as! SportType
    }
    
    struct MiniPlayer: AnyLeagueEventSide, AnyPlayer {
        let key: Int64
        let name: String?
        let logo: String?
        let sportType: SportType?
        
        init(key: Int64, name: String?, logo: String?, sportType: SportType) {
            self.key = key
            self.name = name
            self.logo = logo
            self.sportType = sportType
        }
    }
}

extension TennisEvent.MiniPlayer {
    static func initFirst(from decoder: Decoder) throws -> Self {
        let container = try decoder.container(keyedBy: FirstCodingKeys.self)
        let key = try container.decode(Int64.self, forKey: .key)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let logo = try container.decodeIfPresent(String.self, forKey: .logo)?.nilIfBlank()
        let sportType = decoder.userInfo[CodingUserInfoKey.sportType] as! SportType
        return Self.init(key: key, name: name, logo: logo, sportType: sportType)
    }
    
    static func initSecond(from decoder: Decoder) throws -> Self {
        let container = try decoder.container(keyedBy: SecondCodingKeys.self)
        let key = try container.decode(Int64.self, forKey: .key)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let logo = try container.decodeIfPresent(String.self, forKey: .logo)?.nilIfBlank()
        let sportType = decoder.userInfo[CodingUserInfoKey.sportType] as! SportType
        return Self.init(key: key, name: name, logo: logo, sportType: sportType)
    }
    
    enum FirstCodingKeys: String, CodingKey {
        case key = "first_player_key"
        case name = "event_first_player"
        case logo = "event_first_player_logo"
    }
    
    enum SecondCodingKeys: String, CodingKey {
        case key = "second_player_key"
        case name = "event_second_player"
        case logo = "event_second_player_logo"
    }
}
