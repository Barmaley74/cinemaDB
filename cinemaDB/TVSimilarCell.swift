//
//  TVSimilarCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 11.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVSimilarCell: UITableViewCell {

    @IBOutlet weak var tvImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    
    func  showLabels(_ tv: TV, image: UIImage?) {
        
        // Update the Title label text to use the title from the Movie model
        nameLabel.text = tv.name
        firstAirDateLabel.text = tv.first_air_date
        voteCount.text = "Average score: \(String(format:"%.2f", tv.vote_average))"
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
//        tvImage.image = UIImage(named: "Blank52")
        
        if image != nil {
            tvImage.image = image
        }
    }
    
}
