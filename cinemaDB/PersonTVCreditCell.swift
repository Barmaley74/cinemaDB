//
//  PersonTVCreditCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonTVCreditCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    func  showLabels(_ credit: PersonTVCredit, image: UIImage?) {
        
        nameLabel.text = credit.name
        characterLabel.text = credit.character
        firstAirDateLabel.text = credit.first_air_date
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
//        posterImage.image = UIImage(named: "Blank52")
        
        if image != nil {
            posterImage.image = image
        }
    }

}
