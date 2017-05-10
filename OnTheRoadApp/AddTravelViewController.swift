//
//  AddTravelViewController.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 15.04.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

extension LocalNotification
{
    enum Identifier: String
    {
        case single, repeated, withActions
    }
    
    enum Action: String
    {
        case open, dismiss
    }
    
    enum Category: String
    {
        case general
    }
}

class AddTravelViewController: UIViewController, LocalNotificationCenterDelegate
{
    //local notification center
    let center = UNUserNotificationCenter.current()
    
    var imagePassed = NSData()
    var managedobject = NSManagedObjectContext()
    
    let df : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var countryname: UITextField!
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var descrip: UITextView!
    
    @IBAction func saveTravel(_ sender: Any)
    {
        let country = self.countryname.text
        let descript = self.descrip.text
        let start = startdate.date
        let travelItem = Travel(context: managedobject)
        if country != ""{
            travelItem.countryname = country
        }
        travelItem.image = imagePassed
        travelItem.startdate = start as NSDate?
        travelItem.shortdescrip = descript
        
        do {
            try self.managedobject.save()
            let destination = storyboard?.instantiateViewController(withIdentifier: "AllTravels")
            navigationController?.pushViewController(destination!, animated: true)
        } catch {
            print("Could not save data \(error.localizedDescription)")
        }
        
        let notification = LocalNotification(withIdentifier: LocalNotification.Identifier.single,
                                             deliverTo: center)
        
        notification.content.title = "Country notification"
        notification.content.body = "Country " + country! + " was insert into the List of Countries"
        notification.content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        notification.content.sound = UNNotificationSound.default()
        
        notification.schedule(in: 3, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        center.getNotificationSettings(completionHandler: check(allowedNotificationSettings:))
        center.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidLoad()
        
        let alertController = UIAlertController(title: "Disclaimer", message:
            "Here you can add another travel to your list! Just enter name, select dates and give a description!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func check(allowedNotificationSettings settings: UNNotificationSettings)
    {
        switch settings.authorizationStatus
        {
        case .notDetermined:
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: authorisationResponse(granted:error:))
        case .denied:
            let alert = UIAlertController(title: "Error", message: "Please Enable Local Notifications", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        case .authorized:
            break
        }
    }
    
    func authorisationResponse(granted: Bool, error: Error?)
    {
        guard !granted else { return }
        
        let alert: UIAlertController
        
        if let error = error
        {
            alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        }
        else
        {
            alert = UIAlertController(title: "Error", message: "Please Enable Local Notifications", preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: LocalNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, failedToSheduleNotificationForIdentifier identifier: String, withError error: Error)
    {
        fatalError(error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if let action = LocalNotification.Action(rawValue: response.actionIdentifier)
        {
            switch action
            {
            case .open:
                let alert = UIAlertController(title: "Notification", message: "Action has opened the app!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            case .dismiss:
                print("Action Dismiss")
            }
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // this happens only in foreground
        completionHandler( [.alert, .sound, .badge] )
    }
}
