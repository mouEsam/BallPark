//
//  LivescoresModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation

class LivescoresModel: AnyLeagueEventsModel {
    
    private let calendar: Calendar
    private let remoteService: any AnyLivescoresRemoteService
    
    init(calendar: Calendar, remoteService: some AnyLivescoresRemoteService) {
        self.calendar = calendar
        self.remoteService = remoteService
    }
    
    func load<LeagueEvent: AnyLeagueEvent>(leagueIdentity: LeagueIdentity,
              completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void) {
        remoteLoad(leagueIdentity, completion: completion)
    }
    
    private func remoteLoad<LeagueEvent: AnyLeagueEvent>(_ leagueIdentity: LeagueIdentity,
                            completion: @escaping (Result<SourcedData<[LeagueEvent]>, Error>) -> Void) {
        remoteService.fetch(leagueIdentity) { result in
            completion(result.map { .remote($0) })
        }
    }
}
