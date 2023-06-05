//
//  LeagueViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import Combine
import Swinject

protocol AnyLeagueViewModelFactory {
    func create(for leagueIdentity: LeagueIdentity) -> LeagueViewModel
}

struct LeagueViewModelFactory: AnyLeagueViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for leagueIdentity: LeagueIdentity) -> LeagueViewModel {
        return LeagueViewModel(leagueIdentity: leagueIdentity,
                               model: LeagueModel(database: container.require((any AnyLeagueDatabase).self)),
                               notificationCenter: container.require((any AnyNotificationCenter).self))
    }
}

class LeagueViewModel {
    
    @Published private(set) var isFavourite: Bool? = nil
    @Published private(set) var uiState: UIState<League> = .initial
    
    private let leagueIdentity: LeagueIdentity
    private let model: any AnyLeagueModel
    private let notificationCenter: any AnyNotificationCenter
    private let queue: DispatchQueue = DispatchQueue(label: "laegue", attributes: .concurrent)
    
    private var started: Bool = false
    
    init(leagueIdentity: LeagueIdentity,
         model: some AnyLeagueModel,
         notificationCenter: some AnyNotificationCenter) {
        self.leagueIdentity = leagueIdentity
        self.model = model
        self.notificationCenter = notificationCenter
    }
    
    func loadLeague() {
        queue.async {
            self.uiState = .loading
            self.model.load(leagueIdentity: self.leagueIdentity) { result in
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
