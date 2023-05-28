//
//  LeaguesViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Combine

protocol AnyLeaguesViewModel {
    var uiStatePublisher: Published<UIState<[League]>>.Publisher { get }
    
    func loadLeagues()
}

class LeaguesViewModel: AnyLeaguesViewModel {
    
    @Published private(set) var uiState: UIState<[League]> = .initial
    var uiStatePublisher: Published<UIState<[League]>>.Publisher { $uiState }
    
    private let sportType: SportType
    private let model: LeaguesModel
    private let queue: DispatchQueue = DispatchQueue(label: "leagues", attributes: .concurrent)
    
    init(sportType: SportType,
         model: LeaguesModel) {
        self.sportType = sportType
        self.model = model
    }
    
    func loadLeagues() {
        uiState = .loading
        queue.async {
            self.model.load(sportType: self.sportType) { result in
                self.uiState = result.toUiState()
            }
        }
    }
}
