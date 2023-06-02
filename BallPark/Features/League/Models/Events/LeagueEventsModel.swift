//
//  LeagueEventsModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import Swinject

protocol AnyLeagueEventsModel {
    func load<LeagueEvent: AnyLeagueEvent>(leagueIdentity: LeagueIdentity,
                                           completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void)
}

enum EventsRangeType {
    case next
    case latest
    case live
}

protocol AnyLeagueEventsModelFactory {
    func create(for rangeType: EventsRangeType) -> any AnyLeagueEventsModel
}

struct LeagueEventsModelFactory: AnyLeagueEventsModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for rangeType: EventsRangeType) -> any AnyLeagueEventsModel {
        switch rangeType {
            case .next:
                return NextEventsModel(calendar: container.require(Calendar.self),
                                       remoteService: container.require((any AnyLeagueEventsRemoteService).self))
            case .latest:
                return LatestEventsModel(calendar: container.require(Calendar.self),
                                         remoteService: container.require((any AnyLeagueEventsRemoteService).self))
            case .live:
                return LivescoresModel(calendar: container.require(Calendar.self),
                                       remoteService: container.require((any AnyLivescoresRemoteService).self))
        }
    }
}
