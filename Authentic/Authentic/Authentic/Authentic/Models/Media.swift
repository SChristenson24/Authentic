//
//  Media.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/29/24.
//

import Foundation

enum MediaTypes: String {
    case image = "Image"
    case video = "Video"
    case sound = "Sound"
    case effect = "Effect"
}

import Foundation

class Media {
    var mediaID: String
    var mediaType: MediaTypes
    var duration: TimeInterval?
    var title: String?
    var userID: String?
    var fileURL: URL? 

    init(mediaID: String, mediaType: MediaTypes, duration: TimeInterval? = nil, title: String? = nil, userID: String? = nil, fileURL: URL? = nil) {
        self.mediaID = mediaID
        self.mediaType = mediaType
        self.duration = duration
        self.title = title
        self.userID = userID
        self.fileURL = fileURL
    }

    func toDict() -> [String: Any] {
        return [
            "mediaID": mediaID,
            "mediaType": mediaType.rawValue,
            "duration": duration ?? NSNull(),
            "title": title ?? NSNull(),
            "userID": userID ?? NSNull(),
            "fileURL": fileURL?.absoluteString ?? NSNull()
        ]
    }

    static func fromDict(_ dict: [String: Any]) -> Media? {
        guard let mediaID = dict["mediaID"] as? String,
              let mediaTypeString = dict["mediaType"] as? String,
              let mediaType = MediaTypes(rawValue: mediaTypeString) else {
            return nil
        }
        let duration = dict["duration"] as? TimeInterval
        let title = dict["title"] as? String
        let userID = dict["userID"] as? String
        let fileURLString = dict["fileURL"] as? String
        let fileURL = fileURLString != nil ? URL(string: fileURLString!) : nil

        return Media(mediaID: mediaID, mediaType: mediaType, duration: duration, title: title, userID: userID, fileURL: fileURL)
    }
}
