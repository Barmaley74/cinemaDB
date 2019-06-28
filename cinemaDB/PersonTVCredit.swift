//
//  PersonTVCredit.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct PersonTVCredit {
    
    let character: String
    let credit_id: String
    let episode_count: Int
    let first_air_date: String
    let id: Int
    let name: String
    let original_name: String
    let poster_path: String
    
    init(character: String, credit_id: String, episode_count: Int, first_air_date: String, id: Int, name: String, original_name: String, poster_path: String) {
        self.character = character
        self.credit_id = credit_id
        self.episode_count = episode_count
        self.first_air_date = first_air_date
        self.id = id
        self.name = name
        self.original_name = original_name
        self.poster_path = poster_path
    }
    
    static func personTVCreditsWithJSON(_ results: NSArray) -> [PersonTVCredit] {
        // Create an empty array to append to from this list
        var credits = [PersonTVCredit]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let character = result["character"] as? String ?? ""
                let credit_id = result["credit_id"] as? String ?? ""
                let episode_count = result["episode_count"] as? Int ?? 0
                let first_air_date = result["first_air_date"] as? String ?? ""
                let id = result["id"] as? Int ?? 0
                let name = result["name"] as? String ?? ""
                let original_name = result["original_name"] as? String ?? ""
                
                var poster_path = result["poster_path"] as? String ?? ""
                if poster_path != "" {
                    poster_path = poster_path.substring(from: poster_path.characters.index(poster_path.startIndex, offsetBy: 1))
                    poster_path = "\(Config.apiImageURL)\(poster_path)"
                }
                
                
                let newCredit = PersonTVCredit(character: character, credit_id: credit_id, episode_count: episode_count, first_air_date: first_air_date,id: id, name: name, original_name: original_name, poster_path: poster_path)
                credits.append(newCredit)
            }
        }
        return credits
    }
}
