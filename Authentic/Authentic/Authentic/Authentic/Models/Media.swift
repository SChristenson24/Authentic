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
}

struct Media {
    var mediaID: String
    var mediaType: MediaTypes
    var duration: TimeInterval? {
        return mediaType == .video || mediaType == .sound ? _duration : nil
    }
    private var _duration: TimeInterval?
    var title: String?
    var userID: String?
    var fileURL: URL?
    
    init(mediaID: String, mediaType: MediaTypes, duration: TimeInterval? = nil, title: String? = nil, userID: String? = nil, fileURL: URL? = nil) {
        self.mediaID = mediaID
        self.mediaType = mediaType
        self._duration = duration
        self.title = title
        self.userID = userID
        self.fileURL = fileURL
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "mediaID": mediaID,
            "mediaType": mediaType.rawValue,
            "title": title ?? NSNull(),
            "userID": userID ?? NSNull(),
            "fileURL": fileURL?.absoluteString ?? NSNull()
        ]
        if let duration = _duration {
            dict["duration"] = duration
        }
        return dict
    }
    
    static func fromDict(_ dict: [String: Any]) throws -> Media {
        guard let mediaID = dict["mediaID"] as? String,
              let mediaTypeString = dict["mediaType"] as? String,
              let mediaType = MediaTypes(rawValue: mediaTypeString) else {
            throw MediaError.invalidData
        }
        let duration = dict["duration"] as? TimeInterval
        let title = dict["title"] as? String
        let userID = dict["userID"] as? String
        let fileURLString = dict["fileURL"] as? String
        let fileURL = fileURLString.flatMap { URL(string: $0) }
        
        return Media(mediaID: mediaID, mediaType: mediaType, duration: duration, title: title, userID: userID, fileURL: fileURL)
    }
    
    enum MediaError: Error {
        case invalidData
    }
    
}
