//
//  PlayersModelTests.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import XCTest
import CoreData
@testable import BallPark

class PlayersModelTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var connectivity: MockConnectivity!
    private var teamsDatabase: MockTeamDatabase!
    private var playersDatabase: MockPlayerDatabase!
    private var remoteService: MockPlayersRemoteService!
    private var model: PlayersModel!
    private let teamIdentity = TeamIdentity(teamKey: 640, sportType: .football)
    
    override func setUp() {
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "Player", in: context)
        connectivity = MockConnectivity()
        teamsDatabase = MockTeamDatabase()
        playersDatabase = MockPlayerDatabase()
        remoteService = MockPlayersRemoteService()
        model = PlayersModel(remoteService: remoteService,
                             playersDatabase: playersDatabase,
                             teamsDatabase: teamsDatabase,
                             fetchCacheStrategy: DataFetchCacheStrategy(connectivity: connectivity))
    }
    
    func testLoadConnectedSuccess() {
        let player = Player(entity: entity, insertInto: context)
        connectivity.result = true
        teamsDatabase.addPlayersToTeamResult = .success(Void())
        playersDatabase.getAllByTeamResult = .success([player])
        remoteService.result = .success([player])
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(teamIdentity: teamIdentity) { result in
            // Assert the result here
            if case .success(let resultPlayers) = result {
                XCTAssertTrue(!resultPlayers.data.isEmpty)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadNotConnectedSuccess() {
        let player = Player(entity: entity, insertInto: context)
        connectivity.result = false
        playersDatabase.getAllByTeamResult = .success([player])
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(teamIdentity: teamIdentity) { result in
            // Assert the result here
            if case .success(let resultPlayers) = result {
                XCTAssertTrue(!resultPlayers.data.isEmpty)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadConnectedErrorSuccess() {
        let player = Player(entity: entity, insertInto: context)
        connectivity.result = true
        playersDatabase.getAllByTeamResult = .success([player])
        remoteService.result = .failure(TestError())
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        model.load(teamIdentity: teamIdentity) { result in
            // Assert the result here
            if case .success(let resultPlayers) = result {
                XCTAssertTrue(!resultPlayers.data.isEmpty)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadConnectedErrorFailure() {
        let error = TestError()
        connectivity.result = true
        playersDatabase.getAllByTeamResult = .failure(error)
        remoteService.result = .failure(error)
        
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
    
    func testLoadNotConnectedErrorFailure() {
        let error = TestError()
        connectivity.result = false
        playersDatabase.getAllByTeamResult = .failure(error)
        
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
}

