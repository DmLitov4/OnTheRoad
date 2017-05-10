//
//  LocalNotificationEnum.swift
//  OnTheRoadApp
//
//  Created by Michael on 10.05.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//  Class which extends User notification Class
//  take from moodle


import Foundation
import UserNotifications

extension LocalNotification
{
    convenience init<T:RawRepresentable>(withIdentifier identifier: T, deliverTo center: UNUserNotificationCenter = UNUserNotificationCenter.current()) where T.RawValue == String
    {
        self.init(withIdentifier: identifier.rawValue, deliverTo: center)
    }
}

extension UNNotificationAction
{
    convenience init<T:RawRepresentable>(identifier: T, title: String, options: UNNotificationActionOptions) where T.RawValue == String
    {
        self.init(identifier: identifier.rawValue, title: title, options: options)
    }
}

extension UNNotificationCategory
{
    convenience init<T:RawRepresentable>(identifier: T, actions: [UNNotificationAction], intentIdentifiers: [String], options: UNNotificationCategoryOptions) where T.RawValue == String
    {
        self.init(identifier: identifier.rawValue, actions: actions, intentIdentifiers:intentIdentifiers, options: options)
    }
}

