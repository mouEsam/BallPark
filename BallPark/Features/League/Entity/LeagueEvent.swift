//
//  LeagueEvent.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

struct LeagueEvent: Decodable {
    
    let eventDetails: EventDetails
    let leagueDetails: LeagueDetails
    let homeTeam: MiniTeam
    let awayTeam: MiniTeam
    let sportType: SportType
    
    init(from decoder: Decoder) throws {
        self.eventDetails = try decoder.singleValueContainer().decode(EventDetails.self)
        self.leagueDetails = try decoder.singleValueContainer().decode(LeagueDetails.self)
        self.homeTeam = try MiniTeam(from: decoder, keys: MiniTeam.HomeCodingKeys.self)
        self.awayTeam = try MiniTeam(from: decoder, keys: MiniTeam.AwayCodingKeys.self)
        self.sportType = decoder.userInfo[CodingUserInfoKey.sportType] as! SportType
    }
    
    struct MiniTeam: Decodable {
        let key: Int64
        let name: String
        let logo: String?
        
        init(from decoder: Decoder, keys: HomeCodingKeys.Type) throws {
            let container = try decoder.container(keyedBy: keys.self)
            self.key = try [keys.key, keys.cricketKey, keys.tennisKey].map({ try container.decodeIfPresent(Int64.self, forKey: $0) }).compactMap{$0}.first!
            self.name = try [keys.name, keys.tennisName].map({ try container.decodeIfPresent(String.self, forKey: $0) }).compactMap{$0}.first!
            self.logo = try [keys.logo, keys.tennisLogo, keys.cricketLogo].map({ try container.decodeIfPresent(String.self, forKey: $0)?.nilIfBlank() }).compactMap{$0}.first!
        }
        
        init(from decoder: Decoder, keys: AwayCodingKeys.Type) throws {
            let container = try decoder.container(keyedBy: keys.self)
            self.key = try [keys.key, keys.cricketKey, keys.tennisKey].map({ try container.decodeIfPresent(Int64.self, forKey: $0) }).compactMap{$0}.first!
            self.name = try [keys.name, keys.tennisName].map({ try container.decodeIfPresent(String.self, forKey: $0) }).compactMap{$0}.first!
            self.logo = try [keys.logo, keys.tennisLogo, keys.cricketLogo].map({ try container.decodeIfPresent(String.self, forKey: $0)?.nilIfBlank() }).compactMap{$0}.first!
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
    
    struct EventDetails: Decodable {
        let eventKey: Int64
        let eventDate: Date
        let eventTime: Date
        let eventFinalResult: String?
        let eventStatus: String?
        let eventStadium: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.eventKey = try container.decode(Int64.self, forKey: .eventKey)
            self.eventDate = [
                try container.decodeIfPresent(Date.self, forKey: .eventDate),
                try container.decodeIfPresent(Date.self, forKey: .cricketEventDate),
            ].compactMap({ $0 }).first!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            self.eventTime = dateFormatter.date(from: try container.decode(String.self, forKey: .eventTime))!
            self.eventFinalResult = try {
                let result1 = try container.decodeIfPresent(String.self, forKey: .eventFinalResult)?.nilIfBlank()
                let result2 = [try container.decodeIfPresent(String.self, forKey: .eventHomeFinalResult)?.nilIfBlank(),
                               try container.decodeIfPresent(String.self, forKey: .eventAwayFinalResult)?.nilIfBlank()]
                                  .compactMap{$0}.joined(separator: "-")
                return [result1, result2].compactMap({ $0 }).first!
            }()
            self.eventStatus = try container.decodeIfPresent(String.self, forKey: .eventStatus)?.nilIfBlank()
            self.eventStadium = try container.decodeIfPresent(String.self, forKey: .eventStadium)?.nilIfBlank()
        }
        
        enum CodingKeys: String, CodingKey {
            case eventKey = "event_key"
            case eventDate = "event_date"
            case cricketEventDate = "event_date_start"
            case eventTime = "event_time"
            case eventFinalResult = "event_final_result"
            case eventHomeFinalResult = "event_home_final_result"
            case eventAwayFinalResult = "event_away_final_result"
            case eventStatus = "event_status"
            case eventStadium = "event_stadium"
        }
    }
    
    struct LeagueDetails: Decodable {
        let leagueRound: String?
        let leagueSeason: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.leagueRound = try container.decodeIfPresent(String.self, forKey: .leagueRound)?.nilIfBlank()
            self.leagueSeason = try container.decodeIfPresent(String.self, forKey: .leagueSeason)?.nilIfBlank()
        }
        
        enum CodingKeys: String, CodingKey {
            case leagueRound = "league_round"
            case leagueSeason = "league_season"
        }
    }
}
