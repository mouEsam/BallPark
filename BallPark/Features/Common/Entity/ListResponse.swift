//
//  LeaguesResponse.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation

struct ListResponse<T: Decodable>: Decodable {
    let success: Int
    let result: [T]?
}
