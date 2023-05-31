//
//  LeagueEvent.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

protocol MiniTeam {
    var key: Int64 { get }
    var name: String { get }
    var logo: String? { get }
}

struct LeagueEvent: Decodable {
    
    let eventDetails: EventDetails
    let leagueDetails: LeagueDetails
    let homeTeam: HomeTeam
    let awayTeam: AwayTeam
    let sportType: SportType
    
    init(from decoder: Decoder) throws {
        self.eventDetails = try decoder.singleValueContainer().decode(EventDetails.self)
        self.leagueDetails = try decoder.singleValueContainer().decode(LeagueDetails.self)
        self.homeTeam = try decoder.singleValueContainer().decode(HomeTeam.self)
        self.awayTeam = try decoder.singleValueContainer().decode(AwayTeam.self)
        self.sportType = decoder.userInfo[CodingUserInfoKey.sportType] as! SportType
    }
    
    struct HomeTeam: MiniTeam, Decodable {
        let key: Int64
        let name: String
        let logo: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.key = try container.decode(Int64.self, forKey: CodingKeys.key)
            self.name = try container.decode(String.self, forKey: CodingKeys.name)
            self.logo = try container.decodeIfPresent(String.self, forKey: CodingKeys.logo)?.nilIfBlank()
        }
        
        enum CodingKeys: String, CodingKey {
            case key = "home_team_key"
            case name = "event_home_team"
            case logo = "home_team_logo"
        }
    }
    
    struct AwayTeam: MiniTeam, Decodable {
        let key: Int64
        let name: String
        let logo: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.key = try container.decode(Int64.self, forKey: CodingKeys.key)
            self.name = try container.decode(String.self, forKey: CodingKeys.name)
            self.logo = try container.decodeIfPresent(String.self, forKey: CodingKeys.logo)?.nilIfBlank()
        }
        
        enum CodingKeys: String, CodingKey {
            case key = "away_team_key"
            case name = "event_away_team"
            case logo = "away_team_logo"
        }
    }
    
    struct EventDetails: Decodable {
        let eventKey: Int64
        let eventDate: Date
        let eventTime: Date
        let eventHalftimeResult: String?
        let eventFinalResult: String?
        let eventStatus: String?
        let eventStadium: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.eventKey = try container.decode(Int64.self, forKey: CodingKeys.eventKey)
            self.eventDate = try container.decode(Date.self, forKey: CodingKeys.eventDate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            self.eventTime = dateFormatter.date(from: try container.decode(String.self, forKey: CodingKeys.eventTime))!
            self.eventHalftimeResult = try container.decodeIfPresent(String.self, forKey: CodingKeys.eventHalftimeResult)?.nilIfBlank()
            self.eventFinalResult = try container.decodeIfPresent(String.self, forKey: CodingKeys.eventFinalResult)?.nilIfBlank()
            self.eventStatus = try container.decodeIfPresent(String.self, forKey: CodingKeys.eventStatus)?.nilIfBlank()
            self.eventStadium = try container.decodeIfPresent(String.self, forKey: CodingKeys.eventStadium)?.nilIfBlank()
        }
        
        enum CodingKeys: String, CodingKey {
            case eventKey = "event_key"
            case eventDate = "event_date"
            case eventTime = "event_time"
            case eventHalftimeResult = "event_halftime_result"
            case eventFinalResult = "event_final_result"
            case eventStatus = "event_status"
            case eventStadium = "event_stadium"
        }
    }
    
    struct LeagueDetails: Decodable {
        let leagueRound: String?
        let leagueSeason: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.leagueRound = try container.decodeIfPresent(String.self, forKey: CodingKeys.leagueRound)?.nilIfBlank()
            self.leagueSeason = try container.decodeIfPresent(String.self, forKey: CodingKeys.leagueSeason)?.nilIfBlank()
        }
        
        enum CodingKeys: String, CodingKey {
            case leagueRound = "league_round"
            case leagueSeason = "league_season"
        }
    }
}
