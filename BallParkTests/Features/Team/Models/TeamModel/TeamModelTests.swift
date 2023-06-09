//
//  TeamModelTests.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import XCTest
import CoreData
@testable import BallPark

class TeamModelTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var favouriteEntity: NSEntityDescription!
    private var database: MockTeamDatabase!
    private var model: TeamModel!
    private let teamIdentity = TeamIdentity(teamKey: 640, sportType: .football)
    
    override func setUp() {
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "Team", in: context)
        favouriteEntity = NSEntityDescription.entity(forEntityName: "FavouriteTeam", in: context)
        database = MockTeamDatabase()
        model = TeamModel(database: database)
    }
    
    func testLoadSuccess() {
        let team = Team(entity: entity, insertInto: context)
        database.getByIdResult = .success(team)
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(teamIdentity: teamIdentity) { result in
            // Assert the result here
            if case .success(let resultTeam) = result {
                XCTAssertIdentical(team, resultTeam.data)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadNotFound() {
        database.getByIdResult = .success(nil)
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(teamIdentity: teamIdentity) { result in
            // Assert the result here
            if case .failure(let error) = result {
                XCTAssertTrue(error is NotFoundError)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadFailure() {
        let error = TestError()
        database.getByIdResult = .failure(error)
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(teamIdentity: teamIdentity) { result in
            // Assert the result here
            if case .failure(let errorResult) = result {
                XCTAssertIdentical(error, errorResult as? TestError)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddFavouriteSuccess() {
        let team = Team(entity: entity, insertInto: context)
        database.addFavouriteResult = .success(Void())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        model.toggleFavourite(team) { result in
            guard case .success(_) = result else { XCTFail(); return }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRemoveFavouriteSuccess() {
        let team = Team(entity: entity, insertInto: context)
        team.favourite = FavouriteTeam(entity: favouriteEntity, insertInto: context)
        team.favourite?.isFavourite = true
        database.removeFavouriteResult = .success(Void())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        model.toggleFavourite(team) { result in
            guard case .success(_) = result else { XCTFail(); return }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFavouriteFailure() {
        let team = Team(entity: entity, insertInto: context)
        let error = TestError()
        database.addFavouriteResult = .failure(error)
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        model.toggleFavourite(team) { result in
            guard case .failure(let errorResult) = result else { XCTFail(); return }
            XCTAssertIdentical(error, errorResult as? TestError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
