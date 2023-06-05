//
//  LeagueViewModelTest.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import XCTest
import Combine
import CoreData
@testable import BallPark

class LeagueViewModelTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var favouriteEntity: NSEntityDescription!
    private var notificationCenter: NotificationCenter!
    private var model: MockLeagueModel!
    private var viewModel: LeagueViewModel!
    private let leagueIdentity = LeagueIdentity(leagueKey: 640, sportType: .football)
    
    override func setUp() {
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "League", in: context)
        favouriteEntity = NSEntityDescription.entity(forEntityName: "FavouriteLeague", in: context)
        
        notificationCenter = NotificationCenter.default
        
        model = MockLeagueModel()
        viewModel = LeagueViewModel(leagueIdentity: leagueIdentity,
                                    model: model,
                                    notificationCenter: notificationCenter)
    }
    
    
    func testLoadSuccess() {
        let league = League(entity: entity, insertInto: context)
        model.loadResult = .success(.misc(league))
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .sink { states in
                if case .initial = states[0],
                   case .loading = states[1],
                   case .loaded(let data) = states[2] {
                    print(data.data.isFavourite)
                    XCTAssertIdentical(league, data.data)
                } else {
                    XCTFail()
                }
                expectation.fulfill()
            }
        
        viewModel.loadLeague()
        
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
        
        viewModel.loadLeague()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testAddToFavouriteSuccess() {
        let league = League(entity: entity, insertInto: context)
        model.loadResult = .success(.misc(league))
        model.toggleFavouriteResult = .success(Void())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .flatMap { states in
                return self.viewModel.$isFavourite.collect(2)
            }.flatMap { states in
                XCTAssertNil(states[0])
                XCTAssertTrue(states[1] == false)
                league.favourite = FavouriteLeague(entity: self.favouriteEntity,
                                               insertInto: self.context)
                league.favourite?.isFavourite = true
                self.viewModel.toggleFavourite()
                return self.viewModel.$isFavourite.first()
            }.sink { state in
                XCTAssertTrue(state == true)
                expectation.fulfill()
            }
        
        viewModel.loadLeague()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testremoteFromFavouriteSuccess() {
        let league = League(entity: entity, insertInto: context)
        let favouriteLeague = FavouriteLeague(entity: favouriteEntity,
                                          insertInto: context)
        league.favourite = favouriteLeague
        favouriteLeague.isFavourite = true
        
        model.loadResult = .success(.misc(league))
        model.toggleFavouriteResult = .success(Void())
        
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.$uiState
            .collect(3)
            .flatMap { states in
                return self.viewModel.$isFavourite.collect(2)
            }.flatMap { states in
                XCTAssertNil(states[0])
                XCTAssertTrue(states[1] == true)
                favouriteLeague.isFavourite = false
                self.viewModel.toggleFavourite()
                return self.viewModel.$isFavourite.first()
            }.sink { state in
                XCTAssertTrue(state == false)
                expectation.fulfill()
            }
        
        viewModel.loadLeague()
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    
}
