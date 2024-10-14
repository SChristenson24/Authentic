//
//  Post.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation
import FirebaseFirestore

enum PostVisibility: String {
    case `public` = "Public"
    case `private` = "Private"
    case deleted = "Deleted"
}

struct Post {
    var postID: String
    var userID: String
    var media: [Media]
    var caption: String
    var comments: [Comment]
    var likes: Int
    var shares: Int
    var impressions: Int
    var tags: [String]
    var timestamp: Date
    var verifiedOnly: Bool
    var visibility: PostVisibility
    var isShortForm: Bool

    init(postID: String, userID: String, media: [Media], caption: String, comments: [Comment] = [], likes: Int = 0, shares: Int = 0, impressions: Int = 0, tags: [String] = [], timestamp: Date, verifiedOnly: Bool = false, visibility: PostVisibility = .public, isShortForm: Bool = false) {
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
        self.verifiedOnly = verifiedOnly
        self.visibility = visibility
        self.isShortForm = isShortForm
    }

    // MARK: - Local CRUD Operations

    mutating func addComment(_ comment: Comment) {
        comments.append(comment)
    }

    mutating func removeComment(byID commentID: String) {
        comments.removeAll { $0.commentID == commentID }
    }

    mutating func addTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
        }
    }

    mutating func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
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

    // MARK: - Media Manipulation Methods

    // Add a media item to the array
    mutating func addMedia(_ newMedia: Media) {
        media.append(newMedia)
    }

    // Remove a media item by its index (safer than by ID, unless IDs are unique)
    mutating func removeMedia(at index: Int) {
        guard index >= 0 && index < media.count else { return }
        media.remove(at: index)
    }

    // Remove a media item by its ID (assuming Media has an ID)
    mutating func removeMedia(byID mediaID: String) {
        media.removeAll { $0.mediaID == mediaID }
    }

    // Replace an existing media item at a specific index with new media
    mutating func replaceMedia(at index: Int, with newMedia: Media) {
        guard index >= 0 && index < media.count else { return }
        media[index] = newMedia
    }

    // Clear all media
    mutating func clearMedia() {
        media.removeAll()
    }

    // MARK: - Edit Operations (Local Updates)

    mutating func editCaption(_ newCaption: String) {
        caption = newCaption
    }

    mutating func editVisibility(_ newVisibility: PostVisibility) {
        visibility = newVisibility
    }

    mutating func setShortForm(_ isShortForm: Bool) {
        self.isShortForm = isShortForm
    }

    // MARK: - Firestore Serialization

    func toDict() -> [String: Any] {
        return [
            "postID": postID,
            "userID": userID,
            "media": media.map { $0.toDict() },
            "caption": caption,
            "likes": likes,
            "shares": shares,
            "impressions": impressions,
            "tags": tags,
            "timestamp": Timestamp(date: timestamp),
            "verifiedOnly": verifiedOnly,
            "visibility": visibility.rawValue,
            "isShortForm": isShortForm
        ]
    }

    static func fromDict(_ dict: [String: Any]) throws -> Post {
        guard let postID = dict["postID"] as? String,
              let userID = dict["userID"] as? String,
              let mediaDicts = dict["media"] as? [[String: Any]],
              let caption = dict["caption"] as? String,
              let commentDicts = dict["comments"] as? [[String: Any]],
              let likes = dict["likes"] as? Int,
              let shares = dict["shares"] as? Int,
              let impressions = dict["impressions"] as? Int,
              let tags = dict["tags"] as? [String],
              let timestamp = (dict["timestamp"] as? Timestamp)?.dateValue(),
              let verifiedOnly = dict["verifiedOnly"] as? Bool,
              let visibilityString = dict["visibility"] as? String,
              let visibility = PostVisibility(rawValue: visibilityString),
              let isShortForm = dict["isShortForm"] as? Bool
        else {
            throw PostError.invalidData
        }

        let media = try mediaDicts.map { try Media.fromDict($0) }
        let comments = try commentDicts.map { try Comment.fromDict($0) }

        return Post(
            postID: postID,
            userID: userID,
            media: media,
            caption: caption,
            comments: comments,
            likes: likes,
            shares: shares,
            impressions: impressions,
            tags: tags,
            timestamp: timestamp,
            verifiedOnly: verifiedOnly,
            visibility: visibility,
            isShortForm: isShortForm
        )
    }

    enum PostError: Error {
        case invalidData
    }
}
