//
//  NotificationRouter.swift
//  AutoSportWorld
//
//  Created by Кирилл Володин on 18.12.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let eventsCallback = Notification.Name("eventsCallback")
    static let eventsInitCallback = Notification.Name("eventsInitCallback")
    static let eventsCallbackError = Notification.Name("eventsCallbackError")
}
