//
//  Credit.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 02.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct MovieCredit {
    
    let cast_id: Int
    let character: String
    let credit_id: String
    let id: Int
    let name: String
    let order: Int
    let profile_path: String
    
    init(cast_id: Int, character: String, credit_id: String, id: Int, name: String, order: Int, profile_path: String) {
        self.cast_id = cast_id
        self.character = character
        self.credit_id = credit_id
        self.id = id
        self.name = name
        self.order = order
        self.profile_path = profile_path
    }
    
    static func movieCreditsWithJSON(_ results: NSArray) -> [MovieCredit] {
        // Create an empty array of Movies to append to from this list
        var credits = [MovieCredit]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let cast_id = result["cast_id"] as? Int ?? 0
                let character = result["character"] as? String ?? ""
                let credit_id = result["credit_id"] as? String ?? ""
                let id = result["id"] as? Int ?? 0
                let name = result["name"] as? String ?? ""
                let order = result["order"] as? Int ?? 0
                
                var profile_path = result["profile_path"] as? String ?? ""
                if profile_path != "" {
                    profile_path = profile_path.substring(from: profile_path.characters.index(profile_path.startIndex, offsetBy: 1))
                    profile_path = "\(Config.apiImageURL)\(profile_path)"
                }
                
                let newCredit = MovieCredit(cast_id: cast_id, character: character, credit_id: credit_id, id: id, name: name, order: order, profile_path: profile_path)
                    credits.append(newCredit)
            }
        }
        return credits
    }
}
