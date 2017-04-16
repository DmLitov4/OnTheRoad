//
//  ListViewController.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 09.04.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit
import Social
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let df : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBAction func addMoreTravel(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareToTwitter(_ sender: Any) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)) {
            var indexPath: NSIndexPath!
            
            var travname = ""
            var travstart = ""
            var travend = ""
            var travdescrip = ""
            
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? ListTableViewCell {
                        indexPath = listTableView.indexPath(for: cell) as NSIndexPath!
                        print(indexPath.row)
                        travname = travels[indexPath.row].countryname!
                        //travend = travels[indexPath.row].enddate!
                        if (travels[indexPath.row].startdate != nil){
                            travstart = df.string(from: travels[indexPath.row].startdate as! Date)
                        } else {
                            travstart = "Date was not found"
                        }
                        travdescrip = travels[indexPath.row].shortdescrip!
                    }
                }
            }
            
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            socialController?.setInitialText("Country: " + travname + "\n" + "Description: " + travdescrip + "\n" + "Start date: " + travstart + "\n" + "(send from OnTheRoad iOS app)")
            let img = travels[indexPath.row].image!
            socialController?.add(UIImage(data: img as Data))
            
            //socialController.addURL(someNSURLInstance)
            
            self.present(socialController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareToFacebook(_ sender: Any) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)) {
            var indexPath: NSIndexPath!
            
            var travname = ""
            var travstart = ""
            var travend = ""
            var travdescrip = ""
        
            if let button = sender as? UIButton {
                if let superview = button.superview {
                    if let cell = superview.superview as? ListTableViewCell {
                        indexPath = listTableView.indexPath(for: cell) as NSIndexPath!
                        print(indexPath.row)
                        travname = travels[indexPath.row].countryname!
                        //travend = travels[indexPath.row].enddate!
                        if (travels[indexPath.row].startdate != nil){
                            travstart = df.string(from: travels[indexPath.row].startdate as! Date)
                        } else {
                            travstart = "Date was not found"
                        }
                        travdescrip = travels[indexPath.row].shortdescrip!
                    }
                }
            }
            
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                        socialController?.setInitialText("Country: " + travname + "\n" + "Description: " + travdescrip + "\n" + "Start date: " + travstart + "\n" + "(send from OnTheRoad iOS app)")
                        let img = travels[indexPath.row].image!
                        socialController?.add(UIImage(data: img as Data))
                        
                        //socialController.addURL(someNSURLInstance)
            
            self.present(socialController!, animated: true, completion: nil)
        }
        
    }
    
    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet weak var listTableView: UITableView!
    
    var travels = [Travel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData(){
        let travelRequest:NSFetchRequest<Travel> = Travel.fetchRequest()
        do {
            travels = try managedObjectContext.fetch(travelRequest)
            self.listTableView.reloadData()
        } catch {
            print("Could not save data \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let trav = travels[indexPath.row]
            managedObjectContext.delete(trav)
            travels.remove(at: indexPath.row)
            //ToDo: delete from CoreData
            self.listTableView.deleteRows(at: [indexPath], with: .automatic)
            //self.listTableView.reloadData()
            do {
                try self.managedObjectContext.save()
                //self.loadData()
            } catch {
                print("Could not delete data \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        
        let travelItem = travels[indexPath.row]
        
        if let travelImage = UIImage(data: travelItem.image as! Data){
            cell.travelImage.image = travelImage
        }
        
        cell.travelName.text = travelItem.countryname
        if (travelItem.startdate != nil){
            cell.travelDate.text = df.string(from: travelItem.startdate as! Date)
        }
        else{
            cell.travelDate.text = "Date was not found"
        }
        return cell
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.createTravelItem(with: image)
            })
        }
    }
    
    func createTravelItem(with image: UIImage){
        let travelimage = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        let destination = storyboard?.instantiateViewController(withIdentifier: "AddNewTravel") as! AddTravelViewController
        destination.imagePassed = travelimage
        destination.managedobject = managedObjectContext
        
        navigationController?.pushViewController(destination, animated: true)

        /*let inputAlert = UIAlertController(title: "New travel", message: "Enter country, small description and dates", preferredStyle: .alert)
        inputAlert.addTextField{(textField:UITextField) in
            textField.placeholder = "Country"
        }
        inputAlert.addTextField{(textField:UITextField) in
            textField.placeholder = "Start date"
        }
        inputAlert.addTextField{(textField:UITextField) in
            textField.placeholder = "End date"
        }
        inputAlert.addTextField{(textField:UITextField) in
            textField.placeholder = "Short description"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            
            let personTextField = inputAlert.textFields?.first
            let startTextField = inputAlert.textFields?[1]
            let lastTextField = inputAlert.textFields?[2]
            let presentTextField = inputAlert.textFields?.last
            
            if personTextField?.text != "" && presentTextField?.text != ""{
                travelItem.countryname = personTextField?.text
                let startd = self.df.date(from: (startTextField?.text)!)
                travelItem.startdate = startd as NSDate?
                travelItem.shortdescrip = presentTextField?.text
                let dateFormatter = DateFormatter()
                // Sets date format required to read date from variable `dateString `
                dateFormatter.dateFormat = "yyyy-MM-dd"
                // Reads date form variable `dateString `
                //let enddate = dateFormatter.date(from: (lastTextField?.text)!)
                travelItem.enddate = lastTextField?.text!
                do {
                    try self.managedObjectContext.save()
                    self.loadData()
                } catch {
                    print("Could not save data \(error.localizedDescription)")
                }
            }
            
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
        */
    }
    
}
