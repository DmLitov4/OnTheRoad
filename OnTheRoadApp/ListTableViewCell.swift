//
//  ListTableViewCell.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 09.04.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var travelImage: UIImageView!
    
    @IBOutlet weak var travelName: UILabel!
    
    @IBOutlet weak var travelDate: UILabel!
    
    @IBOutlet weak var travelFacebook: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
