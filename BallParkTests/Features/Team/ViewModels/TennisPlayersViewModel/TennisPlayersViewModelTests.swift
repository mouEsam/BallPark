//
//  TennisPlayersViewModelTest.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 05/06/2023.
//

import XCTest
import Combine
import CoreData
@testable import BallPark

class TennisPlayersViewModelTests: XCTestCase {
    
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var notificationCenter: NotificationCenter!
    private var viewModel: TennisPlayersViewModel!
    private let leagueIdentity = LeagueIdentity(leagueKey: 640, sportType: .football)
    
    override func setUp() {
        context = TestManagedObjectContextFactory().create()
        entity = NSEntityDescription.entity(forEntityName: "Team", in: context)
        
        notificationCenter = NotificationCenter.default
        viewModel = TennisPlayersViewModel(leagueIdentity: leagueIdentity,
                                           notificationCenter: notificationCenter)
    }
    
    func testLoadSuccess() {
        let event = MockLeagueEvent()
        event.firstSideResult = MockLeagueEventSide()
        event.firstSideResult.keyResult = 0
        event.secondSideResult = MockLeagueEventSide()
        event.secondSideResult.keyResult = 1
        let nextNotifications = LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                                     eventRangeType: .next,
                                                     state: .loaded(data: SourcedData.misc([event])))
        let liveNotifications = LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                                     eventRangeType: .live,
                                                     state: .loaded(data: SourcedData.misc([event])))
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.uiStatePublisher
            .collect(2)
            .sink { states in
                if case .initial = states[0],
                   case .loaded(let data) = states[1] {
                    XCTAssertEqual(data.data.count, 2)
                } else {
                    XCTFail()
                }
                expectation.fulfill()
            }
        
        viewModel.loadPlayers()
        notificationCenter.post(nextNotifications)
        notificationCenter.post(liveNotifications)
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testLoadFailure() {
        let error = TestError()
        let event = MockLeagueEvent()
        event.firstSideResult = MockLeagueEventSide()
        event.firstSideResult.keyResult = 0
        event.secondSideResult = MockLeagueEventSide()
        event.secondSideResult.keyResult = 1
        let nextNotifications = LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                                     eventRangeType: .next,
                                                     state: .loaded(data: SourcedData.misc([event])))
        let liveNotifications = LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                                     eventRangeType: .live,
                                                     state: .error(error: error))
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.uiStatePublisher
            .collect(2)
            .sink { states in
                if case .initial = states[0],
                   case .error(let errorResult) = states[1] {
                    XCTAssertIdentical(errorResult as? TestError, error)
                } else {
                    XCTFail()
                }
                expectation.fulfill()
            }
        
        viewModel.loadPlayers()
        notificationCenter.post(nextNotifications)
        notificationCenter.post(liveNotifications)
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testLoadLoading() {
        let event = MockLeagueEvent()
        event.firstSideResult = MockLeagueEventSide()
        event.firstSideResult.keyResult = 0
        event.secondSideResult = MockLeagueEventSide()
        event.secondSideResult.keyResult = 1
        let nextNotifications = LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                                     eventRangeType: .next,
                                                     state: .loaded(data: SourcedData.misc([event])))
        let liveNotifications = LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                                     eventRangeType: .live,
                                                     state: .loading)
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let cancellable = viewModel.uiStatePublisher
            .collect(2)
            .sink { states in
                if case .initial = states[0],
                   case .loading = states[1] {
                } else {
                    XCTFail()
                }
                expectation.fulfill()
            }
        
        viewModel.loadPlayers()
        notificationCenter.post(nextNotifications)
        notificationCenter.post(liveNotifications)
        
        self.wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
}

