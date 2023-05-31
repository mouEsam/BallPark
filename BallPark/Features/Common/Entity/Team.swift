//
//  Team.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import CoreData

@objc(Team)
public class Team: NSManagedObject, Decodable {
    
    public override required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError("Failed to decode Player!")
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.key = try container.decode(Int64.self, forKey: .key)
        self.name = try container.decode(String.self, forKey: .name)
        self.logo = try container.decodeIfPresent(String.self, forKey: .logo)?.nilIfBlank()
    }
    
    private enum CodingKeys: String, CodingKey {
        case key = "team_key"
        case name = "team_name"
        case logo = "team_logo"
        case players = "players"
    }
}
extension Team {
    var isFavourite: Bool {
        favourite?.isFavourite ?? false
    }
    
    var sportType: SportType? { league?.sportType }
    
    var identity: TeamIdentity? {
        sportType.map { TeamIdentity(teamKey: key, sportType: $0) }
    }
}
