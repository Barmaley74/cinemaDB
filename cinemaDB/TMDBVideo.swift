//
//  TMDBVideo.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 02.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct TMDBVideo {
    
    let id: String
    let iso_639_1: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String
    
    init(id: String, iso_639_1: String, key: String, name: String, site: String, size: Int, type: String) {
        self.id = id
        self.iso_639_1 = iso_639_1
        self.key = key
        self.name = name
        self.site = site
        self.size = size
        self.type = type
    }
    
    static func tmdbVideosWithJSON(_ results: NSArray) -> [TMDBVideo] {
        // Create an empty array of Movies to append to from this list
        var tmdbVideos = [TMDBVideo]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            for result in (results as? [[String:Any]])! {
                
                let id = result["id"] as? String ?? ""
                let iso_639_1 = result["iso_639_1"] as? String ?? ""
                let key = result["key"] as? String ?? ""
                let name = result["name"] as? String ?? ""
                let site = result["site"] as? String ?? ""
                let size = result["size"] as? Int ?? 0
                let type = result["type"] as? String ?? ""
                
                let newVideo = TMDBVideo(id: id, iso_639_1: iso_639_1, key: key, name: name, site: site, size: size, type: type)
                tmdbVideos.append(newVideo)
            }
        }
        return tmdbVideos
    }
}
