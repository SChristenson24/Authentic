//
//  ShortForm.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation

class ShortForm: Post {
    var sounds: [Sound]

    init(postID: String, userID: String, mediaURLs: [String],
         caption: String, comments: [Comment] = [], likes: Int = 0,
         shares: Int = 0, impressions: Int = 0,
         tags: [String] = [], timestamp: Date = Date(),
         sounds: [Sound] = [], effects: [String] = []) {
        
        self.sounds = sounds
        
        super.init(postID: postID, userID: userID, mediaURLs: mediaURLs,
                   caption: caption, comments: comments, likes: likes,
                   shares: shares, impressions: impressions,
                   tags: tags, timestamp: timestamp)
    }

    override func toDict() -> [String: Any] {
        var dict = super.toDict()
        dict["sounds"] = sounds
        return dict
    }

    // at later date implement override for fromDict(), it keeps returning errors when implementing
}

