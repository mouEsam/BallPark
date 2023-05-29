//
//  TeamViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Combine

class TeamViewModel {
    
    @Published private(set) var isFavourite: Bool? = nil
    @Published private(set) var uiState: UIState<Team> = .initial
    
    private let teamIdentity: TeamIdentity
    private let model: TeamModel
    private let notificationCenter: NotificationCenter
    private let queue: DispatchQueue = DispatchQueue(label: "team", attributes: .concurrent)
    
    private var started: Bool = false
    
    init(teamIdentity: TeamIdentity,
         model: TeamModel,
         notificationCenter: NotificationCenter) {
        self.teamIdentity = teamIdentity
        self.model = model
        self.notificationCenter = notificationCenter
    }
    
    func loadTeam() {
        queue.async {
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
