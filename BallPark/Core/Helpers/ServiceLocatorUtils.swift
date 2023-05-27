//
//  ServiceLocatorUtils.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 27/05/2023.
//

import Foundation
import Swinject

extension Resolver {
    
    func require<Service>(_ serviceType: Service.Type) -> Service {
        return resolve(serviceType)!
    }
    
}
