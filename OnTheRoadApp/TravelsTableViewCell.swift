//
//  TravelsTableViewCell.swift
//  OnTheRoadApp
//
//  Created by Дмитрий on 04.04.17.
//  Copyright © 2017 LighthouseTeam. All rights reserved.
//

import UIKit

class TravelsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var typeLabel: UILabel!

    @IBOutlet weak var descripLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subviews.forEach { (view) in
            if type(of: view).description() == "_UITableViewCellSeparatorView" {
                view.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
