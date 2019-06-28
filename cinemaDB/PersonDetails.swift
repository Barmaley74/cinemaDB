//
//  PersonDetails.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 07.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct PersonDetails {
    
    let adult: Bool
    let also_known_as: NSArray
    let biography: String
    let birthday: String
    let deathday: String
    let homepage: String
    let id: Int
    let name: String
    let place_of_birth: String
    let profile_path: String
    
    init(adult: Bool, also_known_as: NSArray, biography: String, birthday: String, deathday: String, homepage: String, id: Int, name: String, place_of_birth: String, profile_path: String) {
        self.adult = adult
        self.also_known_as = also_known_as
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.homepage = homepage
        self.id = id
        self.name = name
        self.place_of_birth = place_of_birth
        self.profile_path = profile_path
    }
    
    static func personDetailsWithJSON(_ result: NSDictionary) -> PersonDetails {
        
        let adult = result["adult"] as? Bool ?? false
        let also_known_as = result["also_known_as"] as? NSArray
        let biography = result["biography"] as? String ?? ""
        let birthday = result["birthday"] as? String ?? ""
        let deathday = result["deathday"] as? String ?? ""
        let homepage = result["homepage"] as? String ?? ""
        let id = result["id"] as? Int
        let name = result["name"] as? String ?? ""
        let place_of_birth = result["place_of_birth"] as? String ?? ""
        
        var profile_path = result["profile_path"] as? String ?? ""
        if profile_path != "" {
            profile_path = profile_path.substring(from: profile_path.characters.index(profile_path.startIndex, offsetBy: 1))
            profile_path = "\(Config.apiImageURL)\(profile_path)"
        }
        
        let newPerson = PersonDetails(adult: adult, also_known_as: also_known_as!, biography:  biography, birthday: birthday, deathday: deathday, homepage: homepage, id: id!, name: name, place_of_birth: place_of_birth, profile_path: profile_path)
        
        return newPerson
    }
}
