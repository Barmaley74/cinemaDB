//
//  MovieSimilarCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 11.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieSimilarCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    
    func  showLabels(_ movie: Movie, image: UIImage?) {
        
        // Update the Title label text to use the title from the Movie model
        movieTitle.text = movie.title
        releaseDate.text = movie.release_date
        voteCount.text = "Average score: \(String(format:"%.2f", movie.vote_average))"
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
//        movieImage.image = UIImage(named: "Blank52")
        
        if image != nil {
            movieImage.image = image
        }
    }
    

}
