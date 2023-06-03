//
//  PlayersRemoteServiceTests.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 03/06/2023.
//

import XCTest
import CoreData
@testable import BallPark

class PlayersRemoteServiceTests: XCTestCase {
    
    private var decoder: MockDecoder!
    private var client: MockRemoteClient!
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var remoteService: PlayersRemoteService!
    private let teamIdentity = TeamIdentity(teamKey: 640, sportType: .football)
    
    override func setUp() {
        // Create a managed object context for testing
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "Player", in: context)
        
        decoder = MockDecoder()
        client = MockRemoteClient()
        
        // Create an instance of the PlayersRemoteService with mock objects
        remoteService = PlayersRemoteService(fetchStrategy: RemoteListFetchStrategy(remoteClient: client, decoder: decoder),
                                                 context: context,
                                                 environment: EnviromentProvider())
    }
    
    func testFetchSuccess() {
        client.result = .success(Data())
        decoder.result = ListResponse<Player>(success: 1, result: [Player(entity: entity, insertInto: context)])
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        remoteService.fetch(teamIdentity) { result in
            // Assert the result here
            if case .success(let list) = result {
                XCTAssertFalse(list.isEmpty)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchFailure() {
        let expectedError = TestError()
        client.result = .failure(expectedError)
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        remoteService.fetch(teamIdentity) { result in
            // Assert the result here
            if case .failure(let error) = result {
                XCTAssertIdentical(expectedError, error as? TestError)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDecodeLocalSuccess() throws {
        let bundle = Bundle(for: type(of: self))
        client.result = .success(try Data(contentsOf: bundle.url(forResource: "PlayersResponse", withExtension: "json")!))
        decoder.decoder = JsonDecoder()
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        remoteService.fetch(teamIdentity) { result in
            // Assert the result here
            if case .success(let list) = result {
                XCTAssertFalse(list.isEmpty)
            } else {
                XCTFail()
            }
            // Fulfill the expectation to indicate that the completion closure has been called
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, or timeout after a specified time interval
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDecodeRemoteSuccess() {
        client.client = AFRemoteClient(baseUrl: AppConfigs.baseUrl)
        decoder.decoder = JsonDecoder()
        
        // Create an expectation for the completion closure
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        // Call the fetch method and assert the result
        remoteService.fetch(teamIdentity) { result in
            // Assert the result here
            if case .success(let list) = result {
                XCTAssertFalse(list.isEmpty)
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
