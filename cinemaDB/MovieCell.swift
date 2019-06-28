//
//  MovieCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 22.02.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    
    func  showLabels(_ movie: Movie, image: UIImage?) {
        
        // Update the Title label text to use the title from the Movie model
        movieTitle.text = movie.title
        releaseDate.text = movie.release_date
        voteCount.text = "Average score: \(String(format:"%.2f", movie.vote_average))"

        if image != nil {
            movieImage.image = image
        }
    }
    
}
