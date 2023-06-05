//
//  TeamViewModelTest.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import XCTest
import Combine
import CoreData
@testable import BallPark

class TeamViewModelTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var favouriteEntity: NSEntityDescription!
    private var model: MockTeamModel!
    private var viewModel: TeamViewModel!
    private let teamIdentity = TeamIdentity(teamKey: 640, sportType: .football)
    
    override func setUp() {
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "Team", in: context)
        favouriteEntity = NSEntityDescription.entity(forEntityName: "FavouriteTeam", in: context)
        
        model = MockTeamModel()
        viewModel = TeamViewModel(teamIdentity: teamIdentity, model: model)
    }
    
    
    func testLoadSuccess() {
        let team = Team(entity: entity, insertInto: context)
        model.loadResult = .success(.misc(team))
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .sink { states in
                if case .initial = states[0],
                   case .loading = states[1],
                   case .loaded(let data) = states[2] {
                    print(data.data.isFavourite)
                    XCTAssertIdentical(team, data.data)
                } else {
                    XCTFail()
                }
                expectation.fulfill()
            }
        
        viewModel.loadTeam()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testLoadFailure() {
        model.loadResult = .failure(NotFoundError())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .sink { states in
                if case .initial = states[0],
                   case .loading = states[1],
                   case .error(let errorResult) = states[2] {
                    XCTAssertTrue(errorResult is NotFoundError)
                } else {
                    XCTFail()
                }
                expectation.fulfill()
            }
        
        viewModel.loadTeam()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testAddToFavouriteSuccess() {
        let team = Team(entity: entity, insertInto: context)
        model.loadResult = .success(.misc(team))
        model.toggleFavouriteResult = .success(Void())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .flatMap { states in
                return self.viewModel.$isFavourite.collect(2)
            }.flatMap { states in
                XCTAssertNil(states[0])
                XCTAssertTrue(states[1] == false)
                team.favourite = FavouriteTeam(entity: self.favouriteEntity,
                                               insertInto: self.context)
                team.favourite?.isFavourite = true
                self.viewModel.toggleFavourite()
                return self.viewModel.$isFavourite.first()
            }.sink { state in
                XCTAssertTrue(state == true)
                expectation.fulfill()
            }
        
        viewModel.loadTeam()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testremoteFromFavouriteSuccess() {
        let team = Team(entity: entity, insertInto: context)
        let favouriteTeam = FavouriteTeam(entity: favouriteEntity,
                                          insertInto: context)
        team.favourite = favouriteTeam
        favouriteTeam.isFavourite = true
        
        model.loadResult = .success(.misc(team))
        model.toggleFavouriteResult = .success(Void())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .flatMap { states in
                return self.viewModel.$isFavourite.collect(2)
            }.flatMap { states in
                XCTAssertNil(states[0])
                XCTAssertTrue(states[1] == true)
                favouriteTeam.isFavourite = false
                self.viewModel.toggleFavourite()
                return self.viewModel.$isFavourite.first()
            }.sink { state in
                XCTAssertTrue(state == false)
                expectation.fulfill()
            }
        
        viewModel.loadTeam()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
}
