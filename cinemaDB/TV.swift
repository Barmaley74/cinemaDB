//
//  TV.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct TV {
    
    let backdrop_path: String
    let first_air_date: String
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_name: String
    let overview: String
    let origin_country: NSArray
    let poster_path: String
    let popularity: Double
    let name: String
    let vote_average: Double
    let vote_count: Int
    
    init(backdrop_path: String, first_air_date: String, genre_ids: [Int], id: Int, original_language: String, original_name: String, overview: String, origin_country: NSArray, poster_path: String, popularity: Double, name: String, vote_average: Double, vote_count: Int) {
        self.backdrop_path = backdrop_path
        self.first_air_date = first_air_date
        self.genre_ids = genre_ids
        self.id = id
        self.original_language = original_language
        self.original_name = original_name
        self.overview = overview
        self.origin_country = origin_country
        self.poster_path = poster_path
        self.popularity = popularity
        self.name = name
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
    
    static func tvsWithJSON(_ results: NSArray) -> [TV] {
        // Create an empty array of Movies to append to from this list
        var tvs = [TV]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                var backdrop_path = result["backdrop_path"] as? String ?? ""
                if backdrop_path != "" {
                    backdrop_path = backdrop_path.substring(from: backdrop_path.characters.index(backdrop_path.startIndex, offsetBy: 1))
                    backdrop_path = "\(Config.apiImageURL)\(backdrop_path)"
                }
                
                let first_air_date = result["first_air_date"] as? String ?? ""

                var genre_ids = [Int]()
                genre_ids = result["genre_ids"] as! [Int]
                
                let original_language = result["original_language"] as? String ?? ""
                let original_name = result["original_name"] as? String ?? ""
                let overview = result["overview"] as? String ?? ""
                let origin_country = result["origin_country"] as? NSArray
                
                var poster_path = result["poster_path"] as? String ?? ""
                if poster_path != "" {
                    poster_path = poster_path.substring(from: poster_path.characters.index(poster_path.startIndex, offsetBy: 1))
                    poster_path = "\(Config.apiImageURL)\(poster_path)"
                }
                
                let popularity = result["popularity"] as? Double ?? 0
                let name = result["name"] as? String ?? ""
                let vote_average = result["vote_average"] as? Double ?? 0
                let vote_count = result["vote_count"] as? Int ?? 0
                
                if let id = result["id"] as? Int {
                    let newTV = TV(backdrop_path: backdrop_path, first_air_date: first_air_date, genre_ids: genre_ids, id: id, original_language: original_language, original_name: original_name, overview: overview, origin_country: origin_country!, poster_path: poster_path, popularity: popularity, name: name, vote_average: vote_average, vote_count: vote_count)
                    tvs.append(newTV)
                }
            }
        }
        return tvs
    }
}
