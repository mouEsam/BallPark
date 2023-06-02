//
//  PlayerDatabase.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import CoreData

protocol AnyPlayerDatabase: DynamicDatabase<Player> {
    func getAllByTeam(_ teamKey: Int64) -> Result<[Player], Error>
    func getAllByLeague(_ leagueKey: Int64) -> Result<[Player], Error>
}

class PlayerDatabase: AnyPlayerDatabase {
    typealias Entity = Player
    
    private let context: NSManagedObjectContext
    private let notificationCenter: NotificationCenter
    
    init(context: NSManagedObjectContext, notificationCenter: NotificationCenter) {
        self.context = context
        self.notificationCenter = notificationCenter
    }
    
    private func fetchRequest() -> NSFetchRequest<Player> {
        let request = NSFetchRequest<Player>()
        request.entity = Player.entity()
        return request
    }
    
    func getAllByTeam(_ teamKey: Int64) -> Result<[Player], Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "team.key == %d", teamKey)
        return context.tryFetch(fetchRequest)
    }
    
    func getAllByLeague(_ leagueKey: Int64) -> Result<[Player], Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "league.key == %d", leagueKey)
        return context.tryFetch(fetchRequest)
    }
    
    func getById(_ id: Int64) -> Result<Player?, Error> {
        let fetchRequest = fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %d", id)
        return context.tryFetch(fetchRequest).map(\.first)
    }
    
    func getAll() -> Result<[Player], Error> {
        let fetchRequest = fetchRequest()
        return context.tryFetch(fetchRequest)
    }
    
    func delete(_ object: Player) -> Result<Void, Error> {
        context.delete(object)
        return context.trySave()
    }

}

extension PlayerDatabase: DynamicDatabase {
    func commit() -> Result<Void, Error> {
        return context.trySaveIfNeeded()
    }
}
