//
//  Story.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/29/24.
//

import Foundation
import FirebaseFirestore

struct Story {
    var storyID: String
    var userID: String
    var media: [Media]
    var timestamp: Date
    var expirationDate: Date
    var visibility: PostVisibility  // Uses PostVisibility enum

    var isExpired: Bool {
        return Date() > expirationDate
    }

    init(storyID: String, userID: String, media: [Media], timestamp: Date, expirationDuration: TimeInterval = 24 * 3600, visibility: PostVisibility = .public) {
        self.storyID = storyID
        self.userID = userID
        self.media = media
        self.timestamp = timestamp
        self.expirationDate = timestamp.addingTimeInterval(expirationDuration)
        self.visibility = visibility
    }

    // MARK: - Media Manipulation Methods

    // Add a media item to the array
    mutating func addMedia(_ newMedia: Media) {
        media.append(newMedia)
    }

    // Remove a media item by its index
    mutating func removeMedia(at index: Int) {
        guard index >= 0 && index < media.count else { return }
        media.remove(at: index)
    }

    // Remove a media item by its ID
    mutating func removeMedia(byID mediaID: String) {
        media.removeAll { $0.mediaID == mediaID }
    }

    // Replace a media item at a specific index with new media
    mutating func replaceMedia(at index: Int, with newMedia: Media) {
        guard index >= 0 && index < media.count else { return }
        media[index] = newMedia
    }

    // Clear all media from the story
    mutating func clearMedia() {
        media.removeAll()
    }

    // MARK: - Edit Story Properties

    // Edit visibility
    mutating func editVisibility(_ newVisibility: PostVisibility) {
        visibility = newVisibility
    }

    // Extend expiration by adding more time
    mutating func extendExpiration(by additionalTime: TimeInterval) {
        expirationDate = expirationDate.addingTimeInterval(additionalTime)
    }

    // MARK: - Firestore Serialization

    func toDict() -> [String: Any] {
        return [
            "storyID": storyID,
            "userID": userID,
            "media": media.map { $0.toDict() },
            "timestamp": Timestamp(date: timestamp),
            "expirationDate": Timestamp(date: expirationDate),
            "visibility": visibility.rawValue
        ]
    }

    static func fromDict(_ dict: [String: Any]) throws -> Story {
        guard let storyID = dict["storyID"] as? String,
              let userID = dict["userID"] as? String,
              let mediaDicts = dict["media"] as? [[String: Any]],
              let timestamp = (dict["timestamp"] as? Timestamp)?.dateValue(),
              let expirationDate = (dict["expirationDate"] as? Timestamp)?.dateValue(),
              let visibilityString = dict["visibility"] as? String,
              let visibility = PostVisibility(rawValue: visibilityString)
        else {
            throw StoryError.invalidData
        }

        let media = try mediaDicts.map { try Media.fromDict($0) }

        return Story(
            storyID: storyID,
            userID: userID,
            media: media,
            timestamp: timestamp,
            expirationDuration: expirationDate.timeIntervalSince(timestamp),
            visibility: visibility
        )
    }

    enum StoryError: Error {
        case invalidData
    }
}
