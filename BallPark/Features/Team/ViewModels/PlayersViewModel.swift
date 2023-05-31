//
//  PlayersViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//


import Foundation
import Combine

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
            self.model.load(teamIdentity: self.teamIdentity) { result in
                self.uiState = result.toUiState()
            }
        }
    }
}
