//
//  PreviousEventsModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

class LatestEventsModel: AnyLeagueEventsModel {
    
    private let calendar: Calendar
    private let remoteService: LeagueEventsRemoteService
    
    init(calendar: Calendar, remoteService: LeagueEventsRemoteService) {
        self.calendar = calendar
        self.remoteService = remoteService
    }
    
    func load(leagueIdentity: LeagueIdentity,
              completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void) {
        remoteLoad(leagueIdentity, completion: completion)
    }
    
    private func remoteLoad(_ leagueIdentity: LeagueIdentity,
                            completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void) {
        let today = calendar.startOfDay(for: Date())
        remoteService.fetch(leagueIdentity, to: today) { result in
            completion(result.map { .remote($0) })
        }
    }
}
