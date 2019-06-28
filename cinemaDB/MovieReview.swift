//
//  MovieReview.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 02.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct MovieReview {
    
    let id: String
    let author: String
    let content: String
    let url: String
    
    init(id: String, author: String, content: String, url: String) {
        self.id = id
        self.author = author
        self.content = content
        self.url = url
    }
    
    static func movieReviewsWithJSON(_ results: NSArray) -> [MovieReview] {
        // Create an empty array of Movies to append to from this list
        var movieReviews = [MovieReview]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let id = result["id"] as? String ?? ""
                let author = result["author"] as? String ?? ""
                let content = result["content"] as? String ?? ""
                let url = result["url"] as? String ?? ""
                
                let newMovieReview = MovieReview(id: id, author: author, content: content, url: url)
                movieReviews.append(newMovieReview)
            }
        }
        return movieReviews
    }
}
