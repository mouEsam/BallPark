//
//  MockTeamDatabase.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import Foundation
@testable import BallPark

class MockTeamDatabase: AnyTeamDatabase {
    
    var database: (any AnyTeamDatabase)? = nil
    var getAllByLeagueResult: Result<[BallPark.Team], Error>! = nil
    var addPlayersToTeamResult: Result<Void, Error>! = nil
    var commitResult: Result<Void, Error>! = nil
    var getAllFavouritesResult: Result<[BallPark.Team], Error>! = nil
    var addFavouriteResult: Result<Void, Error>! = nil
    var removeFavouriteResult: Result<Void, Error>! = nil
    var getByIdResult: Result<BallPark.Team?, Error>! = nil
    var getAllResult: Result<[BallPark.Team], Error>! = nil
    var deleteResult: Result<Void, Error>! = nil
    
    func getAllByLeague(_ leagueKey: Int64) -> Result<[BallPark.Team], Error> {
        if let database = database {
            return database.getAllByLeague(leagueKey)
        } else {
            return getAllByLeagueResult
        }
    }
    
    func addPlayersToTeam(_ teamKey: Int64, _ players: [BallPark.Player]) -> Result<Void, Error> {
        if let database = database {
            return database.addPlayersToTeam(teamKey, players)
        } else {
            return addPlayersToTeamResult
        }
    }
    
    func commit() -> Result<Void, Error> {
        if let database = database {
            return database.commit()
        } else {
            return commitResult
        }
    }
    
    func getAllFavourites() -> Result<[BallPark.Team], Error> {
        if let database = database {
            return database.getAllFavourites()
        } else {
            return getAllFavouritesResult
        }
    }
    
    func addFavourite(_ object: BallPark.Team) -> Result<Void, Error> {
        if let database = database {
            return database.addFavourite(object)
        } else {
            return addFavouriteResult
        }
    }
    
    func removeFavourite(_ object: BallPark.Team) -> Result<Void, Error> {
        if let database = database {
            return database.removeFavourite(object)
        } else {
            return removeFavouriteResult
        }
    }
    
    func getById(_ id: Int64) -> Result<BallPark.Team?, Error> {
        if let database = database {
            return database.getById(id)
        } else {
            return getByIdResult
        }
    }
    
    func getAll() -> Result<[BallPark.Team], Error> {
        if let database = database {
            return database.getAll()
        } else {
            return getAllResult
        }
    }
    
    func delete(_ object: BallPark.Team) -> Result<Void, Error> {
        if let database = database {
            return database.delete(object)
        } else {
            return deleteResult
        }
    }
}
