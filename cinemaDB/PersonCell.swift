//
//  PersonCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 07.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    func  showLabels(_ person: Person, image: UIImage?) {
        
        nameLabel.text = person.name
        popularityLabel.text = "Popularity: \(String(format:"%.2f", person.popularity))"
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
//        personImage.image = UIImage(named: "Blank52")
        
        if image != nil {
            personImage.image = image
            // Circular image
            personImage.layer.cornerRadius = personImage.frame.size.width / 2
            personImage.clipsToBounds = true
        }
    }    

}
