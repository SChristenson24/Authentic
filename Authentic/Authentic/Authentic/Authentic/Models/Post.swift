//
//  Post.swift
//  Authentic
//
//  Created by Gage Fulwood on 9/19/24.
//

import Foundation
import FirebaseFirestore

// add location and impressions
// work on FireBase UInt conversion (if necessary)

class Post {
    var postID: String
    var userID: String
    var mediaURLs: [String]
    var caption: String
    var likes: UInt
    var tags: [String]
    var timestamp: Date // using Date since Firebase automatically converts Date from Swift to a Firebase timestamp
    
    init(postID: String, userID: String, mediaURLs: [String],
         caption: String, likes: UInt, tags: [String], timestamp: Date) {
        self.postID = postID
        self.userID = userID
        self.mediaURLs = mediaURLs
        self.caption = caption
        self.likes = likes
        self.tags = tags
        self.timestamp = timestamp
    }
    
    func uploadPost() {
        let db = Firestore.firestore()
        let postData = self.toDict()
        
        db.collection("posts").document(postID).setData(postData) { error in
            if let error = error {
                print("Error uploading post: \(error.localizedDescription)")
            } else {
                print("Post successfully uploaded!")
            }
        }
    }
    
    func updatePost() {
        let db = Firestore.firestore()
        let postData = self.toDict()
        
        db.collection("posts").document(postID).updateData(postData) { error in
            if let error = error {
                print("Error updating post: \(error.localizedDescription)")
            } else {
                print("Post successfully updated!")
            }
        }
    }
        
    func deletePost() {
        let db = Firestore.firestore()
            
        db.collection("posts").document(postID).delete { error in
            if let error = error {
                print("Error removing post: \(error.localizedDescription)")
            } else {
                print("Post successfully deleted!")
            }
        }
    }
        
    static func getPost(byID postID: String, completion: @escaping (Post?) -> Void) {
        let db = Firestore.firestore()
            
        db.collection("posts").document(postID).getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {
                    let post = Post.fromDict(data: data)
                    completion(post)
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "")")
                    completion(nil)
            }
        }
    }
    
    static func fromDict(data: [String: Any]) -> Post? {
        guard let postID = data["postID"] as? String,
              let userID = data["userID"] as? String,
              let mediaURLs = data["mediaURLs"] as? [String],
              let caption = data["caption"] as? String,
              let likes = data["likes"] as? UInt,
              let tags = data["tags"] as? [String],
              let timestamp = data["timestamp"] as? Date else {
            return nil
        }
        return Post(postID: postID, userID: userID, mediaURLs: mediaURLs, caption: caption, likes: likes, tags: tags, timestamp: timestamp)
    }
        
    func toDict() -> [String: Any] {
        return [
            "postID": postID,
            "userID": userID,
            "mediaURLs": mediaURLs,
            "caption": caption,
            "likes": likes,
            "tags": tags,
            "timestamp": timestamp
        ]
    }
}
