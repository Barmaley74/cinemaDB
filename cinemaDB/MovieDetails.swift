//
//  MovieDetails.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 29.05.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct MovieDetails {
    
    let adult: Bool
    let backdrop_path: String
    let belongs_to_collection: String
    let genres: NSArray
    let homepage: String
    let id: Int
    let imdb_id: String
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let production_companies: NSArray
    let production_countries: NSArray
    let release_date: String
    let revenue: Int
    let runtime: Int
    let spoken_languages: NSArray
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    init(adult: Bool, backdrop_path: String, belongs_to_collection: String, genres: NSArray, homepage: String, id: Int, imdb_id: String, original_language: String, original_title: String, overview: String, popularity: Double, poster_path: String, production_companies: NSArray, production_countries: NSArray, release_date: String, revenue: Int, runtime: Int, spoken_languages: NSArray, status: String, tagline: String, title: String, video: Bool, vote_average: Double, vote_count: Int) {
        self.adult = adult
        self.backdrop_path = backdrop_path
        self.belongs_to_collection = belongs_to_collection
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdb_id = imdb_id
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.production_companies = production_companies
        self.production_countries = production_countries
        self.release_date = release_date
        self.revenue = revenue
        self.runtime = runtime
        self.spoken_languages = spoken_languages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
    
    static func movieDetailsWithJSON(_ result: NSDictionary) -> MovieDetails {
        
                let adult = result["adult"] as? Bool ?? false
                
                var backdrop_path = result["backdrop_path"] as? String ?? ""
                if backdrop_path != "" {
                    backdrop_path = backdrop_path.substring(from: backdrop_path.characters.index(backdrop_path.startIndex, offsetBy: 1))
                    backdrop_path = "\(Config.apiImageURL)\(backdrop_path)"
                }
                
                let belongs_to_collection = result["belongs_to_collection"] as? String ?? ""
                let genres = result["genres"] as? NSArray
                let homepage = result["homepage"] as? String ?? ""
                let id = result["id"] as? Int
                let imdb_id = result["imdb_id"] as? String ?? ""
                let original_language = result["original_language"] as? String ?? ""
                let original_title = result["original_title"] as? String ?? ""
                let overview = result["overview"] as? String ?? ""
                let popularity = result["popularity"] as? Double ?? 0

                var poster_path = result["poster_path"] as? String ?? ""
                if poster_path != "" {
                    poster_path = poster_path.substring(from: poster_path.characters.index(poster_path.startIndex, offsetBy: 1))
                    poster_path = "\(Config.apiImageURL)\(poster_path)"
                }
        
                let production_companies = result["production_companies"] as? NSArray
                let production_countries = result["production_countries"] as? NSArray
                let release_date = result["release_date"] as? String ?? ""
                let revenue = result["revenue"] as? Int ?? 0
                let runtime = result["runtime"] as? Int ?? 0
                let spoken_languages = result["spoken_languages"] as? NSArray
                let status = result["status"] as? String ?? ""
                let tagline = result["tagline"] as? String ?? ""
                let title = result["title"] as? String ?? ""
                let video = result["video"] as? Bool ?? false
                let vote_average = result["vote_average"] as? Double ?? 0
                let vote_count = result["vote_count"] as? Int ?? 0
        
        let newMovie = MovieDetails(adult: adult, backdrop_path: backdrop_path, belongs_to_collection:  belongs_to_collection, genres: genres!, homepage: homepage, id: id!, imdb_id: imdb_id, original_language: original_language, original_title: original_title, overview: overview, popularity: popularity, poster_path: poster_path, production_companies: production_companies!, production_countries: production_countries!, release_date: release_date, revenue: revenue, runtime: runtime, spoken_languages: spoken_languages!, status: status, tagline: tagline, title: title, video: video, vote_average: vote_average, vote_count: vote_count)

        return newMovie
    }
}
