//
//  MovieArrays.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 06.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieArraysCell: UITableViewCell {

    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    
    func showLabels (_ movieDetails: MovieDetails) {
        
        var genres: String = ""
        for genre in (movieDetails.genres as? [[String:Any]])! {
            if genres != "" {
                genres = "\(genres), "
            }
            genres = "\(genres) \(genre["name"] as! String)"
        }
        genresLabel.text = genres.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var countries: String = ""
        for country in (movieDetails.production_countries as? [[String:Any]])! {
            if countries != "" {
                countries = "\(countries), "
            }
            countries = "\(countries) \(country["name"] as! String)"
        }
        countriesLabel.text = countries.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var companies: String = ""
        for company in (movieDetails.production_companies as? [[String:Any]])! {
            if companies != "" {
                companies = "\(companies), "
            }
            companies = "\(companies) \(company["name"] as! String)"
        }
        companiesLabel.text = companies.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
        
}

