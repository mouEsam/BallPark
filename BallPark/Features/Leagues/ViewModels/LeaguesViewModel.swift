//
//  LeaguesViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Combine

class LeaguesViewModel {
    
    @Published private(set) var uiState: UIState<[League]> = .initial
    private let model: any AnyLeaguesModel
    private let queue: DispatchQueue = DispatchQueue(label: "leagues", attributes: .concurrent)
    
    init(model: any AnyLeaguesModel) {
        self.model = model
    }
    
    func loadLeagues() {
        uiState = .loading
        queue.async {
            self.model.load { result in
                self.uiState = result.toUiState()
            }
        }
    }
}
