//
//  AnyPlayersViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation
import Swinject
import Combine

protocol AnyPlayersViewModel {
    var uiStatePublisher: Published<UIState<[any AnyPlayer]>>.Publisher { get }
    
    var sectionTitleKey: String { get }
    var emptyMessageKey: String { get }
    
    func loadPlayers()
}

protocol AnyTeamsViewModelFactory {
    func create(for leagueIdentity: LeagueIdentity) -> any AnyPlayersViewModel
}

struct TeamsViewModelFactory: AnyTeamsViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for leagueIdentity: LeagueIdentity) -> any AnyPlayersViewModel {
        let model = container.require((any AnyLeaguePlayersModelFactory).self).create(for: leagueIdentity.sportType)
        return TeamsViewModel(leagueIdentity: leagueIdentity, model: model)
        
        switch leagueIdentity.sportType {
            case .tennis:
                return TennisPlayersViewModel(leagueIdentity: leagueIdentity,
                                              notificationCenter: container.require((any AnyNotificationCenter).self))
            default:
                let model = container.require((any AnyLeaguePlayersModelFactory).self).create(for: leagueIdentity.sportType)
                return TeamsViewModel(leagueIdentity: leagueIdentity, model: model)
        }
    }
}

