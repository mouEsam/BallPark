//
//  NextEventsViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import Combine
import Swinject

protocol AnyLeagueEventsViewModelFactory {
    func create(for leagueIdentity: LeagueIdentity,
                withRange eventRangeType: EventsRangeType) -> LeagueEventsViewModel
}

struct LeagueEventsViewModelFactory: AnyLeagueEventsViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for leagueIdentity: LeagueIdentity,
                withRange eventsRangeType: EventsRangeType) -> LeagueEventsViewModel {
        return LeagueEventsViewModel(eventsRangeType: eventsRangeType,
                                     leagueIdentity: leagueIdentity,
                                     model: container.require((any AnyLeagueEventsModelFactory).self).create(for: eventsRangeType),
                                     notificationCenter: container.require((any AnyNotificationCenter).self))
    }
}

class LeagueEventsViewModel {
    
    @Published private(set) var uiState: UIState<[any AnyLeagueEvent]> = .initial {
        didSet {
            LeagueEventsNotification(leagueIdentity: leagueIdentity,
                                     eventRangeType: eventsRangeType,
                                     state: uiState).post(notificationCenter)
        }
    }
    
    private let eventsRangeType: EventsRangeType
    private let leagueIdentity: LeagueIdentity
    private let model: any AnyLeagueEventsModel
    private let notificationCenter: any AnyNotificationCenter
    private let queue: DispatchQueue = DispatchQueue(label: "nextEvents", attributes: .concurrent)
    
    init(eventsRangeType: EventsRangeType,
         leagueIdentity: LeagueIdentity,
         model: some AnyLeagueEventsModel,
         notificationCenter: some AnyNotificationCenter) {
        self.eventsRangeType = eventsRangeType
        self.leagueIdentity = leagueIdentity
        self.model = model
        self.notificationCenter = notificationCenter
    }
    
    func loadLeagues() {
        queue.async {
            self.uiState = .loading
            switch self.leagueIdentity.sportType {
                case .tennis:
                    self.loadLeaguesImpl(TennisEvent.self)
                    break
                default:
                    self.loadLeaguesImpl(LeagueEvent.self)
            }
        }
    }
    
    private func loadLeaguesImpl<LeagueEvent: AnyLeagueEvent>(_ type: LeagueEvent.Type) {
        model.load(leagueIdentity: self.leagueIdentity) { (result: Result<SourcedData<[LeagueEvent]>, Error>) in
            self.uiState = result.toUiState()
        }
    }
}
