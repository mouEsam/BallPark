//
//  AnyPlayer.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 02/06/2023.
//

import Foundation

protocol AnyPlayer {
    var key: Int64 { get }
    var name: String? { get }
    var logo: String? { get }
    var sportType: SportType? { get }
}

extension Player: AnyPlayer {
    var logo: String? { image }
}

extension Team: AnyPlayer {}
