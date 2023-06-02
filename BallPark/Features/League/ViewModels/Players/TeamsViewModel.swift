//
//  TeamsViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Combine
import Swinject

class TeamsViewModel: AnyPlayersViewModel {
    
    @Published private(set) var uiState: UIState<[any AnyPlayer]> = .initial
    var uiStatePublisher: Published<UIState<[any AnyPlayer]>>.Publisher { $uiState }
    
    private let leagueIdentity: LeagueIdentity
    private let model: any AnyLeaguePlayersModel
    private let queue: DispatchQueue = DispatchQueue(label: "teams", attributes: .concurrent)
    
    var sectionTitleKey: String { model.sectionTitleKey }
    var emptyMessageKey: String { model.emptyMessageKey }
    
    init(leagueIdentity: LeagueIdentity,
         model: some AnyLeaguePlayersModel) {
        self.leagueIdentity = leagueIdentity
        self.model = model
    }
    
    func loadPlayers() {
        queue.async {
            self.uiState = .loading
            self.loadLeagues(self.model)
        }
    }
    
    private func loadLeagues<Model: AnyLeaguePlayersModel>(_ model: Model) {
        model.load(leagueIdentity: self.leagueIdentity) { result in
            self.uiState = result.toUiState()
        }
    }
}
