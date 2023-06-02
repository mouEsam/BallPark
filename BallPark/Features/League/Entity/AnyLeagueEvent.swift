//
//  AnyLeagueEvent.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation

protocol AnyLeagueEvent: Decodable {
    associatedtype SideType: AnyLeagueEventSide
    
    var eventDetails: EventDetails { get }
    var leagueDetails: LeagueDetails { get }
    var sportType: SportType { get }
    var firstSide: SideType { get }
    var secondSide: SideType { get }
}

protocol AnyLeagueEventSide: Decodable {
    var key: Int64 { get }
    var name: String { get }
    var logo: String? { get }
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

