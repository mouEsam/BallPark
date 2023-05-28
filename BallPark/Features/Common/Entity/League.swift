//
//  League.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import CoreData

enum SportType: String {
    case football
    case tennis
    case basketball
    case cricket
    
    var apiPath: String { rawValue }
    var uiImage: String { rawValue }
}

@objc(League)
public class League: NSManagedObject, Decodable {
        
    public override required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
              let sportType = decoder.userInfo[CodingUserInfoKey.sportType] as? SportType else {
            fatalError("Failed to decode League!")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.leagueKey = try container.decode(Int64.self, forKey: .leagueKey)
        self.leagueName = try container.decode(String.self, forKey: .leagueName)
        self.leagueLogo = try container.decodeIfPresent(String.self, forKey: .leagueLogo)
        self.leagueYear = try container.decodeIfPresent(String.self, forKey: .leagueYear)
        self.countryKey = try container.decodeIfPresent(Int64.self, forKey: .countryKey).toDecimal()
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        self.countryLogo = try container.decodeIfPresent(String.self, forKey: .countryLogo)
        self.sportTypeRaw = sportType.rawValue
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case leagueYear = "league_year"
        case countryKey = "country_key"
        case countryName = "country_name"
        case countryLogo = "country_logo"
    }
}

extension League {
    var isFavourite: Bool {
        favourite?.isFavourite ?? false
    }
    
    var sportType: SportType? {
        if let sportTypeRaw = sportTypeRaw {
            return SportType(rawValue: sportTypeRaw)
        }
        return nil
    }
    
    var identity: LeagueIdentity? {
        if let sportType = sportType {
            return LeagueIdentity(leagueKey: leagueKey, sportType: sportType)
        }
        return nil
    }
}

extension Optional<Int64> {
    func toDecimal() -> NSDecimalNumber? {
        guard let self = self else { return nil }
        return NSDecimalNumber(integerLiteral: Int(self))
    }
}
