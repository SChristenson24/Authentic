//
//  Discussions.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation
import FirebaseFirestore

struct DiscussionPost {
    var postID: String
    var userID: String
    var communityID: String
    var title: String
    var body: String
    var media: [Media]
    var flairs: [String]
    var comments: [Comment]
    var likes: Int
    var shares: Int
    var impressions: Int
    var tags: [String]
    var timestamp: Date
    var editedTimestamp: Date?       // New: Timestamp for when the post was last edited
    var isEdited: Bool = false       // New: Indicates whether the post has been edited
    var verifiedOnly: Bool
    var visibility: PostVisibility

    init(postID: String, userID: String, communityID: String, title: String, body: String, media: [Media] = [],
         flairs: [String] = [], comments: [Comment] = [], likes: Int = 0, shares: Int = 0, impressions: Int = 0,
         tags: [String] = [], timestamp: Date, editedTimestamp: Date? = nil, isEdited: Bool = false,
         verifiedOnly: Bool = false, visibility: PostVisibility = .public) {
        self.postID = postID
        self.userID = userID
        self.communityID = communityID
        self.title = title
        self.body = body
        self.media = media
        self.flairs = flairs
        self.comments = comments
        self.likes = likes
        self.shares = shares
        self.impressions = impressions
        self.tags = tags
        self.timestamp = timestamp
        self.editedTimestamp = editedTimestamp
        self.isEdited = isEdited
        self.verifiedOnly = verifiedOnly
        self.visibility = visibility
    }

    // MARK: - Local CRUD Operations

    mutating func addComment(_ comment: Comment) {
        comments.append(comment)
    }

    mutating func removeComment(byID commentID: String) {
        comments.removeAll { $0.commentID == commentID }
    }

    mutating func like() {
        likes += 1
    }

    mutating func unlike() {
        if likes > 0 {
            likes -= 1
        }
    }

    mutating func incrementShares() {
        shares += 1
    }

    mutating func incrementImpressions() {
        impressions += 1
    }

    mutating func addTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
        }
    }

    mutating func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    mutating func addFlair(_ flair: String) {
        if !flairs.contains(flair) {
            flairs.append(flair)
        }
    }

    mutating func removeFlair(_ flair: String) {
        flairs.removeAll { $0 == flair }
    }

    // MARK: - Media Manipulation Methods

    mutating func addMedia(_ newMedia: Media) {
        media.append(newMedia)
    }

    mutating func removeMedia(at index: Int) {
        guard index >= 0 && index < media.count else { return }
        media.remove(at: index)
    }

    mutating func removeMedia(byID mediaID: String) {
        media.removeAll { $0.mediaID == mediaID }
    }

    mutating func replaceMedia(at index: Int, with newMedia: Media) {
        guard index >= 0 && index < media.count else { return }
        media[index] = newMedia
    }

    mutating func clearMedia() {
        media.removeAll()
    }

    // MARK: - Edit Discussion Properties

    mutating func editTitle(_ newTitle: String) {
        title = newTitle
        markAsEdited()
    }

    mutating func editBody(_ newBody: String) {
        body = newBody
        markAsEdited()
    }

    mutating func editVisibility(_ newVisibility: PostVisibility) {
        visibility = newVisibility
        markAsEdited()
    }

    // Mark the post as edited and update the timestamp
    mutating func markAsEdited() {
        isEdited = true
        editedTimestamp = Date()
    }

    // MARK: - Firestore Serialization

    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "postID": postID,
            "userID": userID,
            "communityID": communityID,
            "title": title,
            "body": body,
            "media": media.map { $0.toDict() },
            "flairs": flairs,
            "comments": comments.map { $0.toDict() },
            "likes": likes,
            "shares": shares,
            "impressions": impressions,
            "tags": tags,
            "timestamp": Timestamp(date: timestamp),
            "isEdited": isEdited,
            "verifiedOnly": verifiedOnly,
            "visibility": visibility.rawValue
        ]
        
        if let editedTimestamp = editedTimestamp {
            dict["editedTimestamp"] = Timestamp(date: editedTimestamp)
        }
        
        return dict
    }

    static func fromDict(_ dict: [String: Any]) throws -> DiscussionPost {
        guard let postID = dict["postID"] as? String,
              let userID = dict["userID"] as? String,
              let communityID = dict["communityID"] as? String,
              let title = dict["title"] as? String,
              let body = dict["body"] as? String,
              let mediaDicts = dict["media"] as? [[String: Any]],
              let flairs = dict["flairs"] as? [String],
              let commentDicts = dict["comments"] as? [[String: Any]],
              let likes = dict["likes"] as? Int,
              let shares = dict["shares"] as? Int,
              let impressions = dict["impressions"] as? Int,
              let tags = dict["tags"] as? [String],
              let timestamp = (dict["timestamp"] as? Timestamp)?.dateValue(),
              let isEdited = dict["isEdited"] as? Bool,
              let verifiedOnly = dict["verifiedOnly"] as? Bool,
              let visibilityString = dict["visibility"] as? String,
              let visibility = PostVisibility(rawValue: visibilityString)
        else {
            throw DiscussionPostError.invalidData
        }

        let media = try mediaDicts.map { try Media.fromDict($0) }
        let comments = try commentDicts.map { try Comment.fromDict($0) }
        let editedTimestamp = (dict["editedTimestamp"] as? Timestamp)?.dateValue()

        return DiscussionPost(
            postID: postID,
            userID: userID,
            communityID: communityID,
            title: title,
            body: body,
            media: media,
            flairs: flairs,
            comments: comments,
            likes: likes,
            shares: shares,
            impressions: impressions,
            tags: tags,
            timestamp: timestamp,
            editedTimestamp: editedTimestamp,
            isEdited: isEdited,
            verifiedOnly: verifiedOnly,
            visibility: visibility
        )
    }

    enum DiscussionPostError: Error {
        case invalidData
    }
}
