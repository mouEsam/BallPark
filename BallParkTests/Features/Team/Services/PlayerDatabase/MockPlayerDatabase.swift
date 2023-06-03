//
//  MockPlayerDatabase.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import Foundation
@testable import BallPark

class MockPlayerDatabase: AnyPlayerDatabase {
    
    var database: (any AnyPlayerDatabase)? = nil
    
    var getAllByTeamResult: Result<[BallPark.Player], Error>! = nil
    var getAllByLeagueResult: Result<[BallPark.Player], Error>! = nil
    var commitResult: Result<Void, Error>! = nil
    var getByIdResult: Result<BallPark.Player?, Error>! = nil
    var getAllResult: Result<[BallPark.Player], Error>! = nil
    var deleteResult: Result<Void, Error>! = nil
    
    func getAllByTeam(_ teamKey: Int64) -> Result<[BallPark.Player], Error> {
        if let database = database {
            return database.getAllByTeam(teamKey)
        }
        return getAllByTeamResult
    }
    
    func getAllByLeague(_ leagueKey: Int64) -> Result<[BallPark.Player], Error> {
        if let database = database {
            return database.getAllByLeague(leagueKey)
        }
        return getAllByLeagueResult
    }
    
    func commit() -> Result<Void, Error> {
        if let database = database {
            return database.commit()
        }
        return commitResult
    }
    
    func getById(_ id: Int64) -> Result<BallPark.Player?, Error> {
        if let database = database {
            return database.getById(id)
        }
        return getByIdResult
    }
    
    func getAll() -> Result<[BallPark.Player], Error> {
        if let database = database {
            return database.getAll()
        }
        return getAllResult
    }
    
    func delete(_ object: BallPark.Player) -> Result<Void, Error> {
        if let database = database {
            return database.delete(object)
        }
        return deleteResult
    }
}
