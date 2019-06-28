//
//  PersonMovieCreditCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonMovieCreditCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    func  showLabels(_ credit: PersonMovieCredit, image: UIImage?) {
        
        titleLabel.text = credit.title
        characterLabel.text = credit.character
        releaseDateLabel.text = credit.release_date
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
//        posterImage.image = UIImage(named: "Blank52")
        
        if image != nil {
            posterImage.image = image
        }
    }
    
}
