//
//  Notifications.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 28/05/2023.
//

import Foundation

protocol AppNotification {
    static var rawName: String { get }
}

extension AppNotification {
    static var name: Notification.Name { Notification.Name(Self.rawName) }
    
    func toNotification() -> Notification {
        return Notification(name: Self.name, object: self)
    }
    
    func post(_ center: NotificationCenter) {
        center.post(toNotification())
    }
}

extension NotificationCenter {
    func post(_ notification: some AppNotification) {
        post(notification.toNotification())
    }
}
