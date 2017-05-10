//
//  LocalNotification.swift
//  OnTheRoadApp
//
//  Created by Michael on 10.05.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//
// This class which creates the LocalNotifications
// Take from Moodle

import Foundation
import CoreLocation
import UserNotifications
import UserNotificationsUI

protocol LocalNotificationCenterDelegate: UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, failedToSheduleNotificationForIdentifier identifier: String, withError error: Error)
}

class LocalNotification
{
    let center: UNUserNotificationCenter
    let identifier: String
    
    var content = UNMutableNotificationContent()
    private var trigger: UNNotificationTrigger?
    
    init(withIdentifier identifier: String, deliverTo center: UNUserNotificationCenter = UNUserNotificationCenter.current())
    {
        self.identifier = identifier
        self.center = center
    }
    
    func schedule(in timeInterval: TimeInterval, repeats: Bool)
    {
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        send()
    }
    
    func schedule(forDateMatching date: DateComponents, repeats: Bool)
    {
        trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        send()
    }
    
    func schedule(forLocation location: CLLocation, inRadius radius: Double, repeats: Bool)
    {
        let region = CLCircularRegion(center: location.coordinate, radius: radius, identifier: identifier + "TriggerLocation")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        send()
    }
    
    private func send()
    {
        let request = UNNotificationRequest(identifier:identifier, content: content, trigger: trigger)
        
        center.add(request)
        {
            error in
            guard let error = error else {return}
            if let delegate = self.center.delegate as? LocalNotificationCenterDelegate
            {
                delegate.userNotificationCenter(self.center, failedToSheduleNotificationForIdentifier: self.identifier, withError: error)
            }
        }
    }
}
