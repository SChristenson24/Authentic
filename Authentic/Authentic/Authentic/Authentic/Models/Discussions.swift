//
//  Discussions.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation

class Discussion: Post {
    var text: String

    init(postID: String, userID: String, caption: String, text: String,
         comments: [Comment] = [], likes: Int = 0,
         shares: Int = 0, impressions: Int = 0,
         tags: [String] = [], timestamp: Date = Date()) {
        
        self.text = text
        
        super.init(postID: postID, userID: userID, media: [],
                   caption: caption, comments: comments, likes: likes,
                   shares: shares, impressions: impressions,
                   tags: tags, timestamp: timestamp)
    }

    override func toDict() -> [String: Any] {
        var dict = super.toDict()
        dict["textContent"] = text
        return dict
    }

    // at later date implement override for fromDict(), it keeps returning errors when implementing
}

