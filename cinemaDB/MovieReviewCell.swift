//
//  MovieReviewCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 03.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieReviewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func  showLabels(_ review: MovieReview) {
        
        authorLabel.text = "Author: \(review.author)"
        contentLabel.text = review.content
        
    }

}
