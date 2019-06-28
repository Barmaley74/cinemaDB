//
//  TVArraysCell.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 09.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVArraysCell: UITableViewCell {

    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var networksLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    
    func showLabels (_ tvDetails: TVDetails) {
        
        var genres: String = ""
        for genre in (tvDetails.genres as? [[String:Any]])! {
            if genres != "" {
                genres = "\(genres), "
            }
            genres = "\(genres) \(genre["name"] as! String)"
        }
        genresLabel.text = genres.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var createdBy: String = ""
        for create in (tvDetails.created_by as? [[String:Any]])! {
            if createdBy != "" {
                createdBy = "\(createdBy), "
            }
            createdBy = "\(createdBy) \(create["name"] as! String)"
        }
        createdByLabel.text = createdBy.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var networks: String = ""
        for network in (tvDetails.networks as? [[String:Any]])! {
            if networks != "" {
                networks = "\(networks), "
            }
            networks = "\(networks) \(network["name"] as! String)"
        }
        networksLabel.text = networks.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var companies: String = ""
        for company in (tvDetails.production_companies as? [[String:Any]])! {
            if companies != "" {
                companies = "\(companies), "
            }
            companies = "\(companies) \(company["name"] as! String)"
        }
        companiesLabel.text = companies.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }

}
