//
//  MockLeagueDatabase.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 06/06/2023.
//

import Foundation
@testable import BallPark

class MockLeagueDatabase: AnyLeagueDatabase {
    
    var database: (any AnyLeagueDatabase)? = nil
    
    var getAllBySportTypeResult: Result<[BallPark.League], Error>!
    var getByIdResult: Result<BallPark.League?, Error>!
    var getAllResult: Result<[BallPark.League], Error>!
    var deleteResult: Result<Void, Error>!
    var removeFavouriteResult: Result<Void, Error>!
    var addFavouriteResult: Result<Void, Error>!
    var getAllFavouritesResult: Result<[BallPark.League], Error>!
    var commitResult: Result<Void, Error>!
    var addPlayersToLeagueResult: Result<Void, Error>!
    var addTeamsToLeagueResult: Result<Void, Error>!
    
    func getAllBySportType(_ sportType: BallPark.SportType) -> Result<[BallPark.League], Error> {
        return database?.getAllBySportType(sportType) ?? getAllBySportTypeResult
    }
    
    func addTeamsToLeague(_ leagueKey: Int64, _ teams: [BallPark.Team]) -> Result<Void, Error> {
        return database?.addTeamsToLeague(leagueKey, teams) ?? addTeamsToLeagueResult
    }
    
    func addPlayersToLeague(_ leagueKey: Int64, _ players: [BallPark.Player]) -> Result<Void, Error> {
        return database?.addPlayersToLeague(leagueKey, players) ?? addPlayersToLeagueResult
    }
    
    func commit() -> Result<Void, Error> {
        return database?.commit() ?? commitResult
    }
    
    func getAllFavourites() -> Result<[BallPark.League], Error> {
        return database?.getAllFavourites() ?? getAllFavouritesResult
    }
    
    func addFavourite(_ object: BallPark.League) -> Result<Void, Error> {
        return database?.addFavourite(object) ?? addFavouriteResult
    }
    
    func removeFavourite(_ object: BallPark.League) -> Result<Void, Error> {
        return database?.removeFavourite(object) ?? removeFavouriteResult
    }
    
    func getById(_ id: Int64) -> Result<BallPark.League?, Error> {
        return database?.getById(id) ?? getByIdResult
    }
    
    func getAll() -> Result<[BallPark.League], Error> {
        return database?.getAll() ?? getAllResult
    }
    
    func delete(_ object: BallPark.League) -> Result<Void, Error> {
        return database?.delete(object) ?? deleteResult
    }
}
