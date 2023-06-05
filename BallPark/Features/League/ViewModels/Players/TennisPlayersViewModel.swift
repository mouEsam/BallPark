//
//  TennisPlayersViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation
import Combine
import Swinject

class TennisPlayersViewModel: AnyPlayersViewModel {
    
    @Published private(set) var uiState: UIState<[any AnyPlayer]> = .initial
    var uiStatePublisher: Published<UIState<[any AnyPlayer]>>.Publisher { $uiState }
    
    private let leagueIdentity: LeagueIdentity
    private let notificationCenter: any AnyNotificationCenter
    
    private var cancellable: AnyCancellable?
    
    var sectionTitleKey: String { "Players" }
    var emptyMessageKey: String { "No players found" }
    
    init(leagueIdentity: LeagueIdentity,
         notificationCenter: some AnyNotificationCenter) {
        self.leagueIdentity = leagueIdentity
        self.notificationCenter = notificationCenter
    }
    
    func loadPlayers() {
        cancellable?.cancel()
        let publisher = notificationCenter.publisher(for: LeagueEventsNotification.name)
            .compactMap { $0.object as? LeagueEventsNotification }
            .filter { $0.leagueIdentity == self.leagueIdentity }
        
        let first = publisher.filter { $0.eventRangeType == .next }.map(\.state)
        let second = publisher.filter { $0.eventRangeType == .latest || $0.eventRangeType == .live }.map(\.state)

        cancellable = first.combineLatest(second) { [$0, $1] }.compactMap{ states in
            states.combine { (data: [[any AnyLeagueEvent]]) in
                let dataList = data.flatMap{ $0 }.map{ [$0.firstSide, $0.secondSide] }
                    .flatMap { $0 }.compactMap { $0 as? AnyPlayer }.map { ($0.key, $0) }
                let dictValues = Dictionary(dataList, uniquingKeysWith: { first, _ in first }).values
                return Array(dictValues)
            }
        }.sink { (state: UIState<[any AnyPlayer]>) in
            self.uiState = state
        }
    }
}
