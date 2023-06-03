//
//  MockConnectivity.swift
//  BallParkTests
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import Foundation
@testable import BallPark

class MockConnectivity: AnyConnectivity {
    
    var connectivity: (any AnyConnectivity)? = nil
    
    var result: Bool! = nil
    
    var isConnected: Bool {
        if let connectivity = connectivity {
            return connectivity.isConnected
        }
        return result
    }
    
}
