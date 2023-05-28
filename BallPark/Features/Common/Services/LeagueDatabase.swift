//
//  LeagueDatabase.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import CoreData

protocol AnyLeagueDatabase: DynamicDatabase<League>, FavouritesDatabase {
    func getAllBySportType(_ sportType: SportType) -> Result<[League], Error>
}

class LeagueDatabase: AnyLeagueDatabase {
    typealias Entity = League
    
    private let context: NSManagedObjectContext
    private let notificationCenter: NotificationCenter
    
    init(context: NSManagedObjectContext, notificationCenter: NotificationCenter) {
        self.context = context
        self.notificationCenter = notificationCenter
    }
    
    private func fetchRequest() -> NSFetchRequest<League> {
        let request = NSFetchRequest<League>()
        request.entity = League.entity()
        return request
    }
    
    func getAllBySportType(_ sportType: SportType) -> Result<[League], Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sportTypeRaw == %@", sportType.rawValue)
        return context.tryFetch(fetchRequest)
    }
    
    func getById(_ id: Int64) -> Result<League?, Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", id)
        return context.tryFetch(fetchRequest).map(\.first)
    }
    
    func getAll() -> Result<[League], Error> {
        let fetchRequest = fetchRequest()
        return context.tryFetch(fetchRequest)
    }
    
    func delete(_ object: League) -> Result<Void, Error> {
        context.delete(object)
        return context.trySave()
    }

}

extension LeagueDatabase: DynamicDatabase {
    func commit() -> Result<Void, Error> {
        return context.trySaveIfNeeded()
    }
}


extension LeagueDatabase: FavouritesDatabase {
    func getAllFavourites() -> Result<[League], Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite.isFavourite == 1")
        return context.tryFetch(fetchRequest)
    }
    
    func addFavourite(_ object: League) -> Result<Void, Error> {
        return setFavourite(object, true)
    }
    
    func removeFavourite(_ object: League) -> Result<Void, Error> {
        return setFavourite(object, false)
    }
    
    private func setFavourite(_ object: League, _ isFavourite: Bool) -> Result<Void, Error> {
        if object.isFavourite == isFavourite { return .success(Void()) }
        
        let favourite = object.favourite ?? FavouriteLeague(context: context)
        favourite.isFavourite = isFavourite
        object.favourite = favourite
        
        let notification = LeagueFavouriteNotification(object)
        notificationCenter.post(notification)
        
        return context.trySaveIfNeeded()
    }
}

