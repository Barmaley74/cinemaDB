//
//  PersonDetailsCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 07.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var deathdayLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    func showLabels (_ personDetails: PersonDetails) {
        
        nameLabel.text = personDetails.name
        birthdayLabel.text = "Birth Day: \(personDetails.birthday)"
        placeOfBirthLabel.text = "Place of Birth: \(personDetails.place_of_birth)"
        if personDetails.deathday == "" {
            deathdayLabel.text = ""
        } else {
            deathdayLabel.text = "Death Day: \(personDetails.deathday)"
        }
        biographyLabel.text = personDetails.biography
        biographyLabel.sizeToFit()
    
    }
    

}
