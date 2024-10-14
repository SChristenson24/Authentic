//
//  Discussions.swift
//  Authentic
//
//  Created by Gage Fulwood on 10/13/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreDiscussionPostService {
    
    private let db = Firestore.firestore()
    
    // Firestore collection path for discussion posts
    private let discussionsCollection = "discussionPosts"

    // MARK: - Create Discussion Post
    func createDiscussionPost(_ post: DiscussionPost, completion: @escaping (Result<Void, Error>) -> Void) {
        let postDict = post.toDict()  // No need for a do-catch block here
        db.collection(discussionsCollection).document(post.postID).setData(postDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Read Discussion Post by ID
    func getDiscussionPost(byID postID: String, completion: @escaping (Result<DiscussionPost, Error>) -> Void) {
        let postRef = db.collection(discussionsCollection).document(postID)
        postRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let postDict = document.data() {
                        let post = try DiscussionPost.fromDict(postDict)
                        completion(.success(post))
                    } else {
                        completion(.failure(FirestoreDiscussionPostServiceError.invalidData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(FirestoreDiscussionPostServiceError.documentNotFound))
            }
        }
    }

    // MARK: - Update Discussion Post
    func updateDiscussionPost(_ post: DiscussionPost, completion: @escaping (Result<Void, Error>) -> Void) {
        let postDict = post.toDict()  // No need for a do-catch block here
        db.collection(discussionsCollection).document(post.postID).updateData(postDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Delete Discussion Post
    func deleteDiscussionPost(byID postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(discussionsCollection).document(postID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Increment Likes
    func incrementLikes(forPost postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(discussionsCollection).document(postID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(postRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var likes = postDocument.data()?["likes"] as? Int else {
                return nil
            }
            likes += 1
            transaction.updateData(["likes": likes], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Decrement Likes
    func decrementLikes(forPost postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(discussionsCollection).document(postID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(postRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var likes = postDocument.data()?["likes"] as? Int, likes > 0 else {
                return nil
            }
            likes -= 1
            transaction.updateData(["likes": likes], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Increment Shares
    func incrementShares(forPost postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(discussionsCollection).document(postID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(postRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var shares = postDocument.data()?["shares"] as? Int else {
                return nil
            }
            shares += 1
            transaction.updateData(["shares": shares], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Increment Impressions
    func incrementImpressions(forPost postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(discussionsCollection).document(postID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(postRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var impressions = postDocument.data()?["impressions"] as? Int else {
                return nil
            }
            impressions += 1
            transaction.updateData(["impressions": impressions], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - FirestoreDiscussionPostServiceError
enum FirestoreDiscussionPostServiceError: Error {
    case invalidData
    case documentNotFound
}
