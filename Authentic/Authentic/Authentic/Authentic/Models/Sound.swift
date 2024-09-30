//
//  Sound.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/29/24.
//

import Foundation

class Sound: Media {
    var fileFormat: String
    var sampleRate: Int

    init(mediaID: String, duration: TimeInterval? = nil, title: String? = nil,
         userID: String? = nil, fileURL: URL? = nil, fileFormat: String, sampleRate: Int) {
        self.fileFormat = fileFormat
        self.sampleRate = sampleRate
        super.init(mediaID: mediaID, mediaType: .sound, duration: duration, title: title, userID: userID, fileURL: fileURL)
    }

    override func toDict() -> [String: Any] {
        var dict = super.toDict()
        dict["fileFormat"] = fileFormat
        dict["sampleRate"] = sampleRate
        return dict
    }

}
