//
//  Player.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import CoreData

@objc(Player)
public class Player: NSManagedObject, Decodable {
        
    public override required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
              let sportType = decoder.userInfo[CodingUserInfoKey.sportType] as? SportType else {
            fatalError("Failed to decode Player!")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.key = try container.decode(Int64.self, forKey: .key)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.age = try container.decodeIfPresent(String.self, forKey: .age)
        self.matchPlayed = try container.decodeIfPresent(String.self, forKey: .matchPlayed)
        self.goals = try container.decodeIfPresent(String.self, forKey: .goals)
        self.yellowCards = try container.decodeIfPresent(String.self, forKey: .yellowCards)
        self.redCards = try container.decodeIfPresent(String.self, forKey: .redCards)
        self.image = [try container.decodeIfPresent(String.self, forKey: .image)?.nilIfBlank(),
                      try container.decodeIfPresent(String.self, forKey: .logo)?.nilIfBlank()].compactMap{$0}.first
        self.sportTypeRaw = sportType.rawValue
    }
    
    private enum CodingKeys: String, CodingKey {
        case key = "player_key"
        case name = "player_name"
        case number = "player_number"
        case country = "player_country"
        case type = "player_type"
        case age = "player_age"
        case matchPlayed = "player_match_played"
        case goals = "player_goals"
        case yellowCards = "player_yellow_cards"
        case redCards = "player_red_cards"
        case image = "player_image"
        case logo = "player_logo"
    }
}

extension Player {
    var sportType: SportType? {
        if let sportTypeRaw = sportTypeRaw {
            return SportType(rawValue: sportTypeRaw)
        }
        return nil
    }
}
