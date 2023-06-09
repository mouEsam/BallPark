//
//  LeagueModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

class NextEventsModel: AnyLeagueEventsModel {
    
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
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let to = calendar.date(byAdding: .day, value: AppConfigs.maxApiIntervalDays, to: tomorrow)!
        
        remoteService.fetch(leagueIdentity, from: tomorrow, to: to) { result in
            completion(result.map { .remote($0) })
        }
    }
}

