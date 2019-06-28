//
//  TVDetails.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct TVDetails {
    
    let backdrop_path: String
    let created_by: NSArray
    let episode_run_time: NSArray
    let first_air_date: String
    let genres: NSArray
    let homepage: String
    let id: Int
    let in_production: Bool
    let languages: NSArray
    let last_air_date: String
    let name: String
    let networks: NSArray
    let number_of_episodes: Int
    let number_of_seasons: Int
    let origin_country: NSArray
    let original_language: String
    let original_name: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let production_companies: NSArray
    let seasons: NSArray
    let status: String
    let type: String
    let vote_average: Double
    let vote_count: Int
    
    init(backdrop_path: String, created_by: NSArray, episode_run_time: NSArray, first_air_date: String, genres: NSArray, homepage: String, id: Int, in_production: Bool, languages: NSArray, last_air_date: String, name: String, networks: NSArray, number_of_episodes: Int, number_of_seasons: Int, origin_country: NSArray, original_language: String, original_name: String, overview: String, popularity: Double, poster_path: String, production_companies: NSArray, seasons: NSArray, status: String, type: String, vote_average: Double, vote_count: Int) {
        self.backdrop_path = backdrop_path
        self.created_by = created_by
        self.episode_run_time = episode_run_time
        self.first_air_date = first_air_date
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.in_production = in_production
        self.languages = languages
        self.last_air_date = last_air_date
        self.name = name
        self.networks = networks
        self.number_of_episodes = number_of_episodes
        self.number_of_seasons = number_of_seasons
        self.origin_country = origin_country
        self.original_language = original_language
        self.original_name = original_name
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.production_companies = production_companies
        self.seasons = seasons
        self.status = status
        self.type = type
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
    
    static func tvDetailsWithJSON(_ result: NSDictionary) -> TVDetails {
        
        var backdrop_path = result["backdrop_path"] as? String ?? ""
        if backdrop_path != "" {
            backdrop_path = backdrop_path.substring(from: backdrop_path.characters.index(backdrop_path.startIndex, offsetBy: 1))
            backdrop_path = "\(Config.apiImageURL)\(backdrop_path)"
        }
        
        let created_by = result["created_by"] as? NSArray
        let episode_run_time = result["episode_run_time"] as? NSArray
        let first_air_date = result["first_air_date"] as? String ?? ""
        let genres = result["genres"] as? NSArray
        let homepage = result["homepage"] as? String ?? ""
        let id = result["id"] as? Int
        let in_production = result["in_production"] as? Bool ?? false
        let languages = result["languages"] as? NSArray
        let last_air_date = result["last_air_date"] as? String ?? ""
        let name = result["name"] as? String ?? ""
        let networks = result["networks"] as? NSArray
        let number_of_episodes = result["number_of_episodes"] as? Int ?? 0
        let number_of_seasons = result["number_of_seasons"] as? Int ?? 0
        let origin_country = result["origin_country"] as? NSArray
        let original_language = result["original_language"] as? String ?? ""
        let original_name = result["original_name"] as? String ?? ""
        let overview = result["overview"] as? String ?? ""
        let popularity = result["popularity"] as? Double ?? 0
        
        var poster_path = result["poster_path"] as? String ?? ""
        if poster_path != "" {
            poster_path = poster_path.substring(from: poster_path.characters.index(poster_path.startIndex, offsetBy: 1))
            poster_path = "\(Config.apiImageURL)\(poster_path)"
        }
        
        let production_companies = result["production_companies"] as? NSArray
        let seasons = result["seasons"] as? NSArray
        let status = result["status"] as? String ?? ""
        let type = result["type"] as? String ?? ""
        let vote_average = result["vote_average"] as? Double ?? 0
        let vote_count = result["vote_count"] as? Int ?? 0
        
        let newTV = TVDetails(backdrop_path: backdrop_path, created_by: created_by!, episode_run_time: episode_run_time!, first_air_date: first_air_date, genres: genres!, homepage: homepage, id: id!, in_production: in_production, languages: languages!, last_air_date: last_air_date, name: name, networks: networks!, number_of_episodes: number_of_episodes, number_of_seasons: number_of_seasons, origin_country: origin_country!, original_language: original_language, original_name: original_name, overview: overview, popularity: popularity, poster_path: poster_path, production_companies: production_companies!, seasons: seasons!, status: status, type: type, vote_average: vote_average, vote_count: vote_count)
        
        return newTV
    }
}
