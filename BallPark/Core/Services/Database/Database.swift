//
//  Database.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import CoreData

protocol Database<Entity> {
    associatedtype Entity: Identifiable
    
    func getById(_ id: Int64) -> Result<Entity?, Error>
    
    func getAll() -> Result<[Entity], Error>
    
    func delete(_ object: Entity) -> Result<Void, Error>
}

protocol FavouritesDatabase<Entity>: Database {
    
    func getAllFavourites() -> Result<[Entity], Error>
    
    func addFavourite(_ object: Entity) -> Result<Void, Error>
    
    func removeFavourite(_ object: Entity) -> Result<Void, Error>
}

protocol DynamicDatabase<Entity>: Database {
    func commit() -> Result<Void, Error>
}
