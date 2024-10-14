//
//  Comment.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//
import Foundation
import FirebaseFirestore

enum CommentStatus: String {
    case active = "Active"
    case deleted = "Deleted"
    case reported = "Reported"
}

struct Comment {
    var commentID: String
    var userID: String
    var postID: String
    var text: String
    var likes: Int
    var timestamp: Date
    var parentCommentID: String?
    var children: [Comment] = []
    var isEdited: Bool = false
    var editedTimestamp: Date?
    var status: CommentStatus = .active
    
    mutating func like() {
        likes += 1
    }
    
    mutating func unlike() {
        if likes > 0 {
            likes -= 1
        }
    }
    
    mutating func edit(newText: String) {
        text = newText
        isEdited = true
        editedTimestamp = Date()
    }
    
    mutating func addReply(_ reply: Comment) {
        children.append(reply)
    }
    
    mutating func removeReply(byID commentID: String) {
        children.removeAll { $0.commentID == commentID }
    }

    mutating func delete() {
        status = .deleted
        text = "[Deleted]"
    }
    
    mutating func toggleLike(likedByUser: Bool) {
        likedByUser ? unlike() : like()
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "commentID": commentID,
            "userID": userID,
            "postID": postID,
            "text": text,
            "likes": likes,
            "timestamp": Timestamp(date: timestamp),
            "isEdited": isEdited,
            "status": status.rawValue,
            "children": children.map { $0.toDict() }
        ]
        
        if let editedTimestamp = editedTimestamp {
            dict["editedTimestamp"] = Timestamp(date: editedTimestamp)
        }
        
        if let parentCommentID = parentCommentID {
            dict["parentCommentID"] = parentCommentID
        }
        
        return dict
    }

    static func fromDict(_ dict: [String: Any]) throws -> Comment {
        guard let commentID = dict["commentID"] as? String,
              let userID = dict["userID"] as? String,
              let postID = dict["postID"] as? String,
              let text = dict["text"] as? String,
              let likes = dict["likes"] as? Int,
              let timestamp = dict["timestamp"] as? Timestamp,
              let statusString = dict["status"] as? String,
              let status = CommentStatus(rawValue: statusString),
              let childDicts = dict["children"] as? [[String: Any]]
        else {
            throw CommentError.invalidData
        }
        
        let isEdited = dict["isEdited"] as? Bool ?? false
        let editedTimestamp = (dict["editedTimestamp"] as? Timestamp)?.dateValue()
        let parentCommentID = dict["parentCommentID"] as? String
        let children = try childDicts.map { try Comment.fromDict($0) }
        
        return Comment(
            commentID: commentID,
            userID: userID,
            postID: postID,
            text: text,
            likes: likes,
            timestamp: timestamp.dateValue(),
            parentCommentID: parentCommentID,
            children: children,
            isEdited: isEdited,
            editedTimestamp: editedTimestamp,
            status: status
        )
    }

    enum CommentError: Error {
        case invalidData
    }
}

