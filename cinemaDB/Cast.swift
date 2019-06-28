//
//  Cast.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 23.02.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

struct Cast {
    let id: Int
    let character: String
    let previewUrl: String
    
    init(id: Int, character: String, previewUrl: String) {
        self.id = id
        self.character = character
        self.previewUrl = previewUrl
    }
    
    static func castsWithJSON(results: NSArray) -> [Cast] {
        var casts = [Cast]()
        for castInfo in results {
            // Create the track
            let castId = castInfo["id"] as? Int
            let castPreviewUrl = castInfo["previewUrl"] as? String
            let castCharacter = castInfo["character"] as? String
            let cast = Cast(id: castId!, character: castCharacter!, previewUrl: castPreviewUrl!)
            casts.append(cast)
        }
        return casts
    }
}