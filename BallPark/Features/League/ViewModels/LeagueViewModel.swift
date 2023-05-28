//
//  LeagueViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import Combine

class LeagueViewModel {
    
    @Published private(set) var isFavourite: Bool? = nil
    @Published private(set) var uiState: UIState<League> = .initial
    
    private let leagueIdentity: LeagueIdentity
    private let model: LeagueModel
    private let notificationCenter: NotificationCenter
    private let queue: DispatchQueue = DispatchQueue(label: "laegue", attributes: .concurrent)
    
    private var started: Bool = false
    
    init(leagueIdentity: LeagueIdentity,
         model: LeagueModel,
         notificationCenter: NotificationCenter) {
        self.leagueIdentity = leagueIdentity
        self.model = model
        self.notificationCenter = notificationCenter
    }
    
    func loadLeague() {
        queue.async {
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
