//
//  Story.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/29/24.
//

import Foundation

class Story: Post {
    var duration: TimeInterval
    var isExpired: Bool {
        return checkExpiration()
    }
    var reactions: [String]

    init(postID: String, userID: String, media: [Media],
             caption: String, comments: [Comment], likes: Int,
             shares: Int = 0, impressions: Int = 0,
             tags: [String], timestamp: Date,
             duration: TimeInterval, reactions: [String] = []) {
            self.duration = duration
            self.reactions = reactions
            
            super.init(postID: postID, userID: userID, media: media, caption: caption,
                       comments: comments, likes: likes, shares: shares, impressions: impressions,
                       tags: tags, timestamp: timestamp)
        }

    func checkExpiration() -> Bool {
        let currentTime = Date()
        return currentTime > timestamp.addingTimeInterval(duration)
    }

    func react(to reaction: String) {
        reactions.append(reaction)
    }
    
    override func toDict() -> [String: Any] {
            var dict = super.toDict()
            dict["duration"] = duration
            dict["reactions"] = reactions
            return dict
        }

    // at later date implement override for fromDict(), it keeps returning errors when implementing

}


