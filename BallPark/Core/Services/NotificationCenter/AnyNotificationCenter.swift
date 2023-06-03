//
//  AnyNotificationCenter.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 04/06/2023.
//

import Foundation
import Combine

protocol AnyNotificationCenter {
    func post(_ notification: Notification)
    func publisher(for name: Notification.Name, object: AnyObject?) -> NotificationCenter.Publisher
}

extension AnyNotificationCenter {
    public func publisher(for name: Notification.Name, object: AnyObject? = nil) -> NotificationCenter.Publisher {
        publisher(for: name, object: object)
    }
}
