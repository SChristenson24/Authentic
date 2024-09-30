//
//  Post.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/19/24.
//

import Foundation

// add location and impressions
// work on FireBase UInt conversion (if necessary)

class Post {
    var postID: String
    var userID: String
    var media: [Media]
    var caption: String
    var comments: [Comment]
    var likes: Int
    var shares: Int
    var impressions: Int
    var tags: [String]
    var timestamp: Date // using Date since Firebase automatically converts Date from Swift to a Firebase timestamp
    
    init(postID: String, userID: String, media: [Media],
         caption: String, comments: [Comment], likes: Int = 0, shares: Int = 0, impressions: Int = 0, tags: [String], timestamp: Date) {
        self.postID = postID
        self.userID = userID
        self.media = media
        self.caption = caption
        self.comments = comments
        self.likes = likes
        self.shares = shares
        self.impressions = impressions
        self.tags = tags
        self.timestamp = timestamp
    }
    
    func addComment(comment: Comment) {
        comments.append(comment)
    }
        
    func removeComment(commentID: String) {
        comments.removeAll { $0.commentID == commentID }
    }
    
    func likePost() {
        self.likes += 1
    }
    
    func unlikePost() {
        self.likes -= 1
    }
    
    func incrementShares() {
        self.shares += 1
    }
    
    func incrementImpressions() {
        self.impressions += 1
    }
    
    func addTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
        }
    }
    
    func removeTag(_ tag: String) {
        if let index = tags.firstIndex(of: tag) {
            tags.remove(at: index) }
    }
    
    
    static func fromDict(data: [String: Any]) -> Post? {
        guard let postID = data["postID"] as? String,
              let userID = data["userID"] as? String,
              let media = data["media"] as? [Media],
              let caption = data["caption"] as? String,
              let comments = data["comments"] as? [Comment],
              let likes = data["likes"] as? Int,
              let shares = data["shares"] as? Int,
              let impressions = data["impressions"] as? Int,
              let tags = data["tags"] as? [String],
              let timestamp = data["timestamp"] as? Date else {
            return nil
        }
        return Post(postID: postID, userID: userID, media: media, caption: caption, comments: comments, likes: likes, shares: shares, impressions: impressions, tags: tags, timestamp: timestamp)
    }
        
    func toDict() -> [String: Any] {
        return [
            "postID": postID,
            "userID": userID,
            "media": media,
            "caption": caption,
            "comments": comments,
            "likes": likes,
            "shares": shares,
            "impressions": impressions,
            "tags": tags,
            "timestamp": timestamp
        ]
    }
}
