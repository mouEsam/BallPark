//
//  PlayersViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//


import Foundation
import Combine
import Swinject

protocol AnyPlayersViewModelFactory {
    func create(for teamIdentity: TeamIdentity) -> PlayersViewModel
}

struct PlayersViewModelFactory: AnyPlayersViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for teamIdentity: TeamIdentity) -> PlayersViewModel {
        return PlayersViewModel(teamIdentity: teamIdentity,
                                model: PlayersModel(remoteService: container.require((any AnyPlayersRemoteService).self),
                                                    playersDatabase: container.require((any AnyPlayerDatabase).self),
                                                    teamsDatabase: container.require((any AnyTeamDatabase).self),
                                                    fetchCacheStrategy: container.require((any AnyDataFetchCacheStrategy).self)))
    }
}

class PlayersViewModel {
    
    @Published private(set) var isFavourite: Bool? = nil
    @Published private(set) var uiState: UIState<[Player]> = .initial
    
    private let teamIdentity: TeamIdentity
    private let model: PlayersModel
    private let queue: DispatchQueue = DispatchQueue(label: "team", attributes: .concurrent)
    
    private var started: Bool = false
    
    init(teamIdentity: TeamIdentity,
         model: PlayersModel) {
        self.teamIdentity = teamIdentity
        self.model = model
    }
    
    func loadPlayers() {
        queue.async {
            self.uiState = .loading
            self.model.load(teamIdentity: self.teamIdentity) { result in
                self.uiState = result.toUiState()
            }
        }
    }
}
