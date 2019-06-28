//
//  MovieDetailsCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 02.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieDetailsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!

    func showLabels (_ movieDetails: MovieDetails) {
        
        titleLabel.text = movieDetails.title
        releaseDateLabel.text = movieDetails.release_date
        voteLabel.text = "Score: \(String(format:"%.2f", movieDetails.vote_average)) Voted count: \(movieDetails.vote_count)"
        runtimeLabel.text = "Runtime: \(movieDetails.runtime) min."
        
    }

}
