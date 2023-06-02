//
//  AnyLeaguesViewModel.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation

protocol AnyLeaguesViewModel {
    var uiStatePublisher: Published<UIState<[League]>>.Publisher { get }
    
    func loadLeagues()
}
