//
//  Person.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 07.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct Person {
    
    let adult: Bool
    let backdrop_path: String
    let id: Int
    let known_for: NSArray?
    let name: String
    let popularity: Double
    let profile_path: String
    
    init(adult: Bool, backdrop_path: String, id: Int, known_for: NSArray?, name: String, popularity: Double, profile_path: String) {
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.id = id
        self.known_for = known_for
        self.name = name
        self.profile_path = profile_path
        self.popularity = popularity
    }
    
    static func personsWithJSON(_ results: NSArray) -> [Person] {
        // Create an empty array of Movies to append to from this list
        var persons = [Person]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let adult = result["adult"] as? Bool ?? false
                
                var backdrop_path = result["backdrop_path"] as? String ?? ""
                if backdrop_path != "" {
                    backdrop_path = backdrop_path.substring(from: backdrop_path.characters.index(backdrop_path.startIndex, offsetBy: 1))
                    backdrop_path = "\(Config.apiImageURL)\(backdrop_path)"
                }
                
                let id = result["id"] as? Int ?? 0
                let known_for = result["known_for"] as? NSArray
                
                let name = result["name"] as? String ?? ""
                
                var profile_path = result["profile_path"] as? String ?? ""
                if profile_path != "" {
                    profile_path = profile_path.substring(from: profile_path.characters.index(profile_path.startIndex, offsetBy: 1))
                    profile_path = "\(Config.apiImageURL)\(profile_path)"
                }
                
                let popularity = result["popularity"] as? Double ?? 0
                
                let newPerson = Person(adult: adult, backdrop_path: backdrop_path, id: id, known_for: known_for, name: name, popularity: popularity, profile_path: profile_path)
                persons.append(newPerson)
            }
        }
        return persons
    }
}
