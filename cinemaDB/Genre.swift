//
//  Genre.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 12.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct Genre {
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    static func genresWithJSON(_ results: NSArray) -> [Genre] {
        // Create an empty array of Movies to append to from this list
        var genres = [Genre]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let name = result["name"] as? String ?? ""
                
                if let id = result["id"] as? Int {
                    let newGenre = Genre(id: id, name: name)
                    genres.append(newGenre)
                }
            }
        }
        return genres
    }
}
