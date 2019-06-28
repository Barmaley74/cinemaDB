//
//  TVDetailsCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 09.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVDetailsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstAirDateLabel: UILabel!
    @IBOutlet weak var lastAirDateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet weak var numberOfSeasonsLabel: UILabel!
    
    func showLabels (_ tvDetails: TVDetails) {
        
        nameLabel.text = tvDetails.name
        firstAirDateLabel.text = "First Air Date: \(tvDetails.first_air_date)"
        lastAirDateLabel.text = "Last Air Date: \(tvDetails.last_air_date)"
        voteLabel.text = "Score: \(String(format:"%.2f", tvDetails.vote_average)) Voted count: \(tvDetails.vote_count)"
        numberOfEpisodesLabel.text = "Number of Episodes: \(tvDetails.number_of_episodes)"
        numberOfSeasonsLabel.text = "Number of Seasons: \(tvDetails.number_of_seasons)"
        
    }

}
