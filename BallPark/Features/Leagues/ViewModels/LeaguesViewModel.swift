//
//  LeaguesViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import Combine

import Swinject

protocol AnyLeaguesViewModelFactory {
    func create(for sportType: SportType) -> LeaguesViewModel
}

struct LeaguesViewModelFactory: AnyLeaguesViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create(for sportType: SportType) -> LeaguesViewModel {
        let model = LeaguesModel(remoteService: container.require((any AnyLeaguesRemoteService).self),
                                 database: container.require((any AnyLeagueDatabase).self),
                                 fetchCacheStrategy: container.require((any AnyDataFetchCacheStrategy).self))
        return LeaguesViewModel(sportType: sportType, model: model)
    }
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
        queue.async {
            self.uiState = .loading
            self.model.load(sportType: self.sportType) { result in
                self.uiState = result.toUiState()
            }
        }
    }
}
