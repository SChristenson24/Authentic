//
//  Comment.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation
import FirebaseFirestore
//to-do add functions

class Comment {
    var commentID: String
    var userID: String
    var postID: String
    var text: String
    var likes: Int
    var timestamp: Date
    var parentCommentID: String?
    
    init(commentID: String, userID: String, postID: String, text: String, likes: Int = 0, timestamp: Date, parentCommentID: String? = nil) {
        self.commentID = commentID
        self.userID = userID
        self.postID = postID
        self.text = text
        self.likes = likes
        self.timestamp = timestamp
        self.parentCommentID = parentCommentID
    }
    
    func likeComment() {
        likes += 1
    }
    
    func unlikeCommnent() {
        if (likes > 0) {
            likes -= 1
        }
    }
    
    func toDict() -> [String: Any] {
        return [
            "commentID": commentID,
            "userID": userID,
            "postID": postID,
            "text": text,
            "likes": likes,
            "timestamp": timestamp,
            "parentCommentID": parentCommentID ?? NSNull()
        ]
    }
    
    static func fromDict(_ dict: [String: Any]) -> Comment? {
        guard let commentID = dict["commentID"] as? String,
              let userID = dict["userID"] as? String,
              let postID = dict["postID"] as? String,
              let text = dict["text"] as? String,
              let likes = dict["likes"] as? Int,
              let timestamp = dict["timestamp"] as? Date else {
            return nil
        }
        let parentCommentID = dict["parentCommentID"] as? String
        return Comment(commentID: commentID, userID: userID, postID: postID, text: text, likes: likes, timestamp: timestamp, parentCommentID: parentCommentID)
    }
}
