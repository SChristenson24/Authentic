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
    var content: String
    var likes: UInt
    var timestamp: Date
    
    init(commentID: String, userID: String, postID: String, content: String, likes: UInt, timestamp: Date) {
        self.commentID = commentID
        self.userID = userID
        self.postID = postID
        self.content = content
        self.likes = likes
        self.timestamp = timestamp
    }
}
