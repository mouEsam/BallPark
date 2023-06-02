//
//  PreviousEventsModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

class LatestEventsModel: AnyLeagueEventsModel {
    
    private let calendar: Calendar
    private let remoteService: any AnyLeagueEventsRemoteService
    
    init(calendar: Calendar, remoteService: some AnyLeagueEventsRemoteService) {
        self.calendar = calendar
        self.remoteService = remoteService
    }
    
    func load<LeagueEvent: AnyLeagueEvent>(leagueIdentity: LeagueIdentity,
              completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void) {
        remoteLoad(leagueIdentity, completion: completion)
    }
    
    private func remoteLoad<LeagueEvent: AnyLeagueEvent>(_ leagueIdentity: LeagueIdentity,
                            completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void) {
        let today = calendar.startOfDay(for: Date())
        let from = calendar.date(byAdding: .day, value: -AppConfigs.maxApiIntervalDays, to: today)!
        
        remoteService.fetch(leagueIdentity, from: from, to: today) { result in
            completion(result.map { .remote($0) })
        }
    }
}
