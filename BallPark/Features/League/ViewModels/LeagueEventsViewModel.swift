//
//  NextEventsViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import Combine

class LeagueEventsViewModel {
    
    @Published private(set) var uiState: UIState<[LeagueEvent]> = .initial
    
    private let leagueIdentity: LeagueIdentity
    private let model: any AnyLeagueEventsModel
    private let queue: DispatchQueue = DispatchQueue(label: "nextEvents", attributes: .concurrent)
    
    init(leagueIdentity: LeagueIdentity,
         model: some AnyLeagueEventsModel) {
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
