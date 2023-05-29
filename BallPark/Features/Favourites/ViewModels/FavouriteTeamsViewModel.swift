//
//  FavouriteTeamsViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 29/05/2023.
//

import Foundation
import Combine

class FavouriteTeamsViewModel {
    
    @Published private(set) var uiState: UIState<[Team]> = .initial
    var uiStatePublisher: Published<UIState<[Team]>>.Publisher { $uiState }
    
    private let model: FavouriteTeamsModel
    private let notificationCenter: NotificationCenter
    private let queue: DispatchQueue = DispatchQueue(label: "favouriteTeams", attributes: .concurrent)
    private var started: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: FavouriteTeamsModel, notificationCenter: NotificationCenter) {
        self.model = model
        self.notificationCenter = notificationCenter
    }
    
    func loadTeams() {
        uiState = .loading
        queue.async {
            self.loadTeamsImpl()
        }
    }
    
    private func loadTeamsImpl() {
        model.load { result in
            self.uiState = result.toUiState()
            self.startListening()
        }
    }
    
    private func startListening() {
        if (!started) {
            started = true
            notificationCenter
                .publisher(for: TeamFavouriteNotification.name)
                .receive(on: queue)
                .sink { notification in
                    self.loadTeamsImpl()
                }.store(in: &cancellables)
        }
    }
}

