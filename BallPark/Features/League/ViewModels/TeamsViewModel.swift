//
//  TeamsViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Combine

class TeamsViewModel {
    
    @Published private(set) var uiState: UIState<[Team]> = .initial
    
    private let leagueIdentity: LeagueIdentity
    private let model: TeamsModel
    private let queue: DispatchQueue = DispatchQueue(label: "teams", attributes: .concurrent)
    
    init(leagueIdentity: LeagueIdentity,
         model: TeamsModel) {
        self.leagueIdentity = leagueIdentity
        self.model = model
    }
    
    func loadLeagues() {
        uiState = .loading
        queue.async {
            self.model.load(leagueIdentity: self.leagueIdentity) { result in
                self.uiState = result.toUiState()
            }
        }
    }
}
