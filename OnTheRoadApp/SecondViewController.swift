//
//  SecondViewController.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 04.04.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getVideo(videoCode: "ioYqFtr2D0Q")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVideo(videoCode: String){
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        myWebView.loadRequest(URLRequest(url: url!))
    }

}

