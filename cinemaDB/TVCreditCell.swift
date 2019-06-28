//
//  TVCreditCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 10.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVCreditCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    func  showLabels(_ credit: TVCredit, image: UIImage?) {
        
        nameLabel.text = credit.name
        characterLabel.text = credit.character
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
//        profileImage.image = UIImage(named: "Blank52")
        
        if image != nil {
            profileImage.image = image
            // Circular image
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
            profileImage.clipsToBounds = true
        }
    }

}
