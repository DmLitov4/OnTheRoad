//
//  AddTravelViewController.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 15.04.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit
import CoreData

class AddTravelViewController: UIViewController {

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
    
    @IBAction func saveTravel(_ sender: Any) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
