//
//  TMDBImage.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 02.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct TMDBImage {
    
    let file_path: String
    let width: Int
    let height: Int
    let iso_639_1: String
    let aspect_ratio: Double
    let vote_average: Double
    let vote_count: Int
    
    init(file_path: String, width: Int, height: Int, iso_639_1: String, aspect_ratio: Double, vote_average: Double, vote_count: Int) {
        self.file_path = file_path
        self.width = width
        self.height = height
        self.iso_639_1 = iso_639_1
        self.aspect_ratio = aspect_ratio
        self.vote_average = vote_average
        self.vote_count = vote_count
    }
    
    static func tmdbImagesWithJSON(_ results: NSArray) -> [TMDBImage] {
        // Create an empty array of Movies to append to from this list
        var tmdbImages = [TMDBImage]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                var file_path = result["file_path"] as? String ?? ""
                if file_path != "" {
                    file_path = file_path.substring(from: file_path.characters.index(file_path.startIndex, offsetBy: 1))
                    file_path = "\(Config.apiImageURL)\(file_path)"
                }

                let width = result["width"] as? Int ?? 0
                let height = result["height"] as? Int ?? 0
                let iso_639_1 = result["iso_639_1"] as? String ?? ""
                let aspect_ratio = result["aspect_ratio"] as? Double ?? 0
                let vote_average = result["vote_average"] as? Double ?? 0
                let vote_count = result["vote_count"] as? Int ?? 0
                
                let newImage = TMDBImage(file_path: file_path, width: width, height: height, iso_639_1: iso_639_1, aspect_ratio: aspect_ratio, vote_average: vote_average, vote_count: vote_count)
                tmdbImages.append(newImage)
            }
        }
        return tmdbImages
    }
}
