//
//  AnyPlayersModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation
import Swinject

protocol AnyLeaguePlayersModel {
    associatedtype PlayerType: AnyPlayer
    
    var sectionTitleKey: String { get }
    var emptyMessageKey: String { get }
    
    func load(leagueIdentity: LeagueIdentity, completion: @escaping (Result<SourcedData<[PlayerType]>, Error>) -> Void)
}

protocol AnyLeaguePlayersModelFactory {
    func create(for sportType: SportType) -> any AnyLeaguePlayersModel
}

struct LeaguePlayersModelFactory: AnyLeaguePlayersModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for sportType: SportType) -> any AnyLeaguePlayersModel {
        switch sportType {
        case .tennis:
            return LeaguePlayersModel(remoteService: container.require((any AnyLeaguePlayersRemoteService).self),
                                       playersDatabase: container.require((any AnyPlayerDatabase).self),
                                       leagueDatabase: container.require((any AnyLeagueDatabase).self),
                                       fetchCacheStrategy: container.require((any AnyDataFetchCacheStrategy).self))
        default:
            return TeamsModel(remoteService: container.require((any AnyTeamsRemoteService).self),
                               teamsDatabase: container.require((any AnyTeamDatabase).self),
                               leagueDatabase: container.require((any AnyLeagueDatabase).self),
                               fetchCacheStrategy: container.require((any AnyDataFetchCacheStrategy).self))
        }
    }
}
