//
//  ReachabilityConnectivity.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import Foundation
import Reachability

class ReachabilityConnectivity: AnyConnectivity {
    
    private let reachability: Reachability?
    
    var isConnected: Bool {
        reachability?.connection != .unavailable
    }
    
    init(reachability: Reachability?) {
        self.reachability = reachability
    }
}
