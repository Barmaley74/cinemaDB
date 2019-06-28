//
//  Config.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 22.02.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct Config {
    static let apiURL = "https://api.themoviedb.org/3/"
    static let apiKey = "77886cbb9d6a00887e2af941c39be8c9"
    static let apiImageURL = "https://image.tmdb.org/t/p/w500/"
    
    static let apiMovie = apiURL + "movie/"
    static let apiDiscoverMovie = apiURL + "discover/movie"
    static let apiDiscoverTV = apiURL + "discover/tv"
    static let apiSearchMovie = apiURL + "search/movie"
    static let apiPerson = apiURL + "person/"
    static let apiPersonPopular = apiURL + "person/popular"
    static let apiSearchPerson = apiURL + "search/person"
    static let apiTV = apiURL + "tv/"
    static let apiSearchTV = apiURL + "search/tv"
    static let apiGenresList = apiURL + "genre/movie/list"
    static let apiGenre = apiURL + "genre/"
    
    static let sortByVoteAverage = "sort_by=vote_average.desc&vote_count.gte=50"
    
    static let movieUpcoming = apiURL + "movie/upcoming"
    static let movieNowPlaying = apiURL + "movie/now_playing"
    static let moviePopular = apiURL + "movie/popular"
    static let movieTopRated = apiURL + "movie/top_rated"
    
    static let tvOnTheAir = apiURL + "tv/on_the_air"
    static let tvAiringToday = apiURL + "tv/airing_today"
    static let tvTopRated = apiURL + "tv/top_rated"
    static let tvPopular = apiURL + "tv/popular"
    
    static let moviesArray = ["Voted", "Now playing", "Popular", "Top rated", "Upcoming"]
    static let tvArray = ["Voted", "Popular", "Top Rated", "On the Air", "Airing Today"]

}