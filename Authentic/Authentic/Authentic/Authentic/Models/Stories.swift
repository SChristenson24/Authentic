//
//  Stories.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation
import FirebaseFirestore

class Story: Post {
    var duration: TimeInterval
    var isVisible: Bool
    var viewers: [String]
    
    init(postID: String, userID: String, mediaURLs: [String], caption: String, likes: UInt, tags: [String], timestamp: Date, duration: TimeInterval, isVisible: Bool, viewers: [String]) {
        self.duration = duration
        self.isVisible = isVisible
        self.viewers = viewers
        
        super.init(postID: postID, userID: userID, mediaURLs: mediaURLs, caption: caption, likes: likes, tags: tags, timestamp: timestamp)
    }
}
