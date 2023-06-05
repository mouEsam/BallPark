//
//  LeagueModelTests.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import XCTest
import CoreData
@testable import BallPark

class LeagueModelTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var database: MockLeagueDatabase!
    private var model: LeagueModel!
    private let leagueIdentity = LeagueIdentity(leagueKey: 640, sportType: .football)
    
    override func setUp() {
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "League", in: context)
        database = MockLeagueDatabase()
        model = LeagueModel(database: database)
    }
    
    func testLoadSuccess() {
        let league = League(entity: entity, insertInto: context)
        database.getByIdResult = .success(league)
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(leagueIdentity: leagueIdentity) { result in
            // Assert the result here
            if case .success(let resultLeague) = result {
                XCTAssertIdentical(league, resultLeague.data)
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
        model.load(leagueIdentity: leagueIdentity) { result in
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
        model.load(leagueIdentity: leagueIdentity) { result in
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
}
