//
//  PlaceDetailsController.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 02.05.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit

class PlaceDetailsController: UIViewController {
    
    var imagePassed = NSData()
    var labelname = String()
    var desctext = String()

    @IBOutlet weak var countryname: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var descripof: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photo.image = UIImage(data: imagePassed as Data, scale: 1.0)
        self.countryname.text = labelname
        self.descripof.text = desctext
        // Do any additional setup after loading the view.
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
