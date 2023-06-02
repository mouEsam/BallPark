//
//  FavouriteLeaguesViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation
import Combine
import Swinject

protocol AnyFavouriteLeaguesViewModelFactory {
    func create() -> FavouriteLeaguesViewModel
}

struct FavouriteLeaguesViewModelFactory: AnyFavouriteLeaguesViewModelFactory {
    private let container: any Resolver
    
    init(resolver: any Resolver) {
        self.container = resolver
    }
    
    func create() -> FavouriteLeaguesViewModel {
        return FavouriteLeaguesViewModel(model: FavouriteLeaguesModel(database: container.require((any FavouritesDatabase<League>).self)),
                                         notificationCenter: container.require(NotificationCenter.self))
    }
}

class FavouriteLeaguesViewModel: AnyLeaguesViewModel {
    
    @Published private(set) var uiState: UIState<[League]> = .initial
    var uiStatePublisher: Published<UIState<[League]>>.Publisher { $uiState }
    
    private let model: FavouriteLeaguesModel
    private let notificationCenter: NotificationCenter
    private let queue: DispatchQueue = DispatchQueue(label: "favouriteLeagues", attributes: .concurrent)
    private var started: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: FavouriteLeaguesModel, notificationCenter: NotificationCenter) {
        self.model = model
        self.notificationCenter = notificationCenter
    }
    
    func loadLeagues() {
        queue.async {
            self.uiState = .loading
            self.loadLeaguesImpl()
        }
    }
    
    private func loadLeaguesImpl() {
        model.load { result in
            self.uiState = result.toUiState()
            self.startListening()
        }
    }
    
    private func startListening() {
        if (!started) {
            started = true
            notificationCenter
                .publisher(for: LeagueFavouriteNotification.name)
                .receive(on: queue)
                .sink { notification in
                    self.loadLeaguesImpl()
                }.store(in: &cancellables)
        }
    }
}
