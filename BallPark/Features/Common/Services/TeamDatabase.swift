//
//  TeamDatabase.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import CoreData

protocol AnyTeamDatabase: DynamicDatabase<Team>, FavouritesDatabase {
    func getAllByLeague(_ leagueKey: Int64) -> Result<[Team], Error>
}

class TeamDatabase: AnyTeamDatabase {
    typealias Entity = Team
    
    private let context: NSManagedObjectContext
    private let notificationCenter: NotificationCenter
    
    init(context: NSManagedObjectContext, notificationCenter: NotificationCenter) {
        self.context = context
        self.notificationCenter = notificationCenter
    }
    
    private func fetchRequest() -> NSFetchRequest<Team> {
        let request = NSFetchRequest<Team>()
        request.entity = Team.entity()
        return request
    }
    
    func getAllByLeague(_ leagueKey: Int64) -> Result<[Team], Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "league.key == %d", leagueKey)
        return context.tryFetch(fetchRequest)
    }
    
    func getById(_ id: Int64) -> Result<Team?, Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %d", id)
        return context.tryFetch(fetchRequest).map(\.first)
    }
    
    func getAll() -> Result<[Team], Error> {
        let fetchRequest = fetchRequest()
        return context.tryFetch(fetchRequest)
    }
    
    func delete(_ object: Team) -> Result<Void, Error> {
        context.delete(object)
        return context.trySave()
    }

}

extension TeamDatabase: DynamicDatabase {
    func commit() -> Result<Void, Error> {
        return context.trySaveIfNeeded()
    }
}


extension TeamDatabase: FavouritesDatabase {
    func getAllFavourites() -> Result<[Team], Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite.isFavourite == 1")
        return context.tryFetch(fetchRequest)
    }
    
    func addFavourite(_ object: Team) -> Result<Void, Error> {
        return setFavourite(object, true)
    }
    
    func removeFavourite(_ object: Team) -> Result<Void, Error> {
        return setFavourite(object, false)
    }
    
    private func setFavourite(_ object: Team, _ isFavourite: Bool) -> Result<Void, Error> {
        if object.isFavourite == isFavourite { return .success(Void()) }
        
        let favourite = object.favourite ?? FavouriteTeam(context: context)
        favourite.isFavourite = isFavourite
        object.favourite = favourite
        
        let notification = TeamFavouriteNotification(object)
        notificationCenter.post(notification)
        
        return context.trySaveIfNeeded()
    }
}

