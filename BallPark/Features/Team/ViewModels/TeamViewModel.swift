//
//  TeamViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Combine
import Swinject

protocol AnyTeamViewModelFactory {
    func create(for teamIdentity: TeamIdentity) -> TeamViewModel
}

struct TeamViewModelFactory: AnyTeamViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for teamIdentity: TeamIdentity) -> TeamViewModel {
        return TeamViewModel(teamIdentity: teamIdentity,
                                  model: TeamModel(database: container.require((any AnyTeamDatabase).self)))
    }
}

class TeamViewModel {
    
    @Published private(set) var isFavourite: Bool? = nil
    @Published private(set) var uiState: UIState<Team> = .initial
    
    private let teamIdentity: TeamIdentity
    private let model: any AnyTeamModel
    private let queue: DispatchQueue = DispatchQueue(label: "team", attributes: .concurrent)
    
    private var started: Bool = false
    
    init(teamIdentity: TeamIdentity,
         model: some AnyTeamModel) {
        self.teamIdentity = teamIdentity
        self.model = model
    }
    
    func loadTeam() {
        queue.async {
            self.uiState = .loading
            self.model.load(teamIdentity: self.teamIdentity) { result in
                self.uiState = result.toUiState()
                self.updateFavouriteState()
            }
        }
    }
    
    @objc func toggleFavourite() {
        if case .loaded(let data) = uiState {
            model.toggleFavourite(data.data) { _ in
                self.updateFavouriteState()
            }
        }
    }
    
    func updateFavouriteState() {
        if case .loaded(let data) = uiState {
            self.isFavourite = data.data.isFavourite
        }
    }
}
