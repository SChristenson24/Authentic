//
//  Impression.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/20/24.
//

import Foundation

// add functions, consider adding an isSaved

class Impression {
    var impressionID: String
    var postID: String
    var userID: String
    var viewedAt: Date
    var engagementTime: Double
    var isClicked: Bool
    var isLiked: Bool
    var location: String
    var deviceType: String
    
    init(impressionID: String, postID: String, userID: String, viewedAt: Date, engagementTime: Double, isClicked: Bool, isLiked: Bool, location: String, deviceType: String) {
        self.impressionID = impressionID
        self.postID = postID
        self.userID = userID
        self.viewedAt = viewedAt
        self.engagementTime = engagementTime
        self.isClicked = isClicked
        self.isLiked = isLiked
        self.location = location
        self.deviceType = deviceType
    }
}
