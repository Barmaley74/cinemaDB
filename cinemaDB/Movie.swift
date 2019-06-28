//
//  Movie.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 22.02.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct Movie {
    
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let release_date: String
    let poster_path: String
    let popularity: Double
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    init(adult: Bool, backdrop_path: String, genre_ids: [Int], id: Int, original_language: String, original_title: String, overview: String, release_date: String, poster_path: String, popularity: Double, title: String, video: Bool, vote_average: Double, vote_count: Int) {
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.genre_ids = genre_ids
        self.id = id
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.release_date = release_date
        self.poster_path = poster_path
        self.popularity = popularity
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
    
    static func moviesWithJSON(_ results: NSArray) -> [Movie] {
        // Create an empty array of Movies to append to from this list
        var movies = [Movie]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let adult = result["adult"] as? Bool ?? false
                
                var backdrop_path = result["backdrop_path"] as? String ?? ""
                if backdrop_path != "" {
                    backdrop_path = backdrop_path.substring(from: backdrop_path.characters.index(backdrop_path.startIndex, offsetBy: 1))
                    backdrop_path = "\(Config.apiImageURL)\(backdrop_path)"
                }
                
                var genre_ids = [Int]()
                genre_ids = result["genre_ids"] as! [Int]

                let original_language = result["original_language"] as? String ?? ""
                let original_title = result["original_title"] as? String ?? ""
                let overview = result["overview"] as? String ?? ""
                let release_date = result["release_date"] as? String ?? ""
                
                var poster_path = result["poster_path"] as? String ?? ""
                if poster_path != "" {
                    poster_path = poster_path.substring(from: poster_path.characters.index(poster_path.startIndex, offsetBy: 1))
                    poster_path = "\(Config.apiImageURL)\(poster_path)"
                }
                
                let popularity = result["popularity"] as? Double ?? 0
                let title = result["title"] as? String ?? ""
                let video = result["video"] as? Bool ?? false
                let vote_average = result["vote_average"] as? Double ?? 0
                let vote_count = result["vote_count"] as? Int ?? 0
                
                if let id = result["id"] as? Int {
                    let newMovie = Movie(adult: adult, backdrop_path: backdrop_path, genre_ids: genre_ids, id: id, original_language: original_language, original_title: original_title, overview: overview, release_date: release_date, poster_path: poster_path, popularity: popularity, title: title, video: video, vote_average: vote_average, vote_count: vote_count)
                    movies.append(newMovie)
                }
            }
        }
        return movies
    }
}
