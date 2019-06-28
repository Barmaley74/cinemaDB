//
//  PersonMovieCredit.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct PersonMovieCredit {
    
    let adult: Bool
    let character: String
    let credit_id: String
    let id: Int
    let original_title: String
    let poster_path: String
    let release_date: String
    let title: String
    
    init(adult: Bool, character: String, credit_id: String, id: Int, original_title: String, poster_path: String, release_date: String, title: String) {
        self.adult = adult
        self.character = character
        self.credit_id = credit_id
        self.id = id
        self.original_title = original_title
        self.poster_path = poster_path
        self.release_date = release_date
        self.title = title
    }
    
    static func personMovieCreditsWithJSON(_ results: NSArray) -> [PersonMovieCredit] {
        // Create an empty array of Movies to append to from this list
        var credits = [PersonMovieCredit]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let adult = result["adult"] as? Bool ?? false
                let character = result["character"] as? String ?? ""
                let credit_id = result["credit_id"] as? String ?? ""
                let id = result["id"] as? Int ?? 0
                let original_title = result["original_title"] as? String ?? ""
                
                var poster_path = result["poster_path"] as? String ?? ""
                if poster_path != "" {
                    poster_path = poster_path.substring(from: poster_path.characters.index(poster_path.startIndex, offsetBy: 1))
                    poster_path = "\(Config.apiImageURL)\(poster_path)"
                }
                
                let release_date = result["release_date"] as? String ?? ""
                let title = result["title"] as? String ?? ""

                let newCredit = PersonMovieCredit(adult: adult, character: character, credit_id: credit_id, id: id, original_title: original_title, poster_path: poster_path, release_date: release_date, title: title)
                credits.append(newCredit)
            }
        }
        return credits
    }
}
