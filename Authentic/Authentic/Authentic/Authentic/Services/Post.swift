//
//  Post.swift
//  Authentic
//
//  Created by Gage Fulwood on 10/13/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostService {

    private let db = Firestore.firestore()
    
    // Firestore collection path for posts
    private let postsCollection = "posts"

    // MARK: - Create Post
    func createPost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        let postDict = post.toDict()  // Convert post to dictionary
        db.collection(postsCollection).document(post.postID).setData(postDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Read Post by ID
    func getPost(byID postID: String, completion: @escaping (Result<Post, Error>) -> Void) {
        let postRef = db.collection(postsCollection).document(postID)
        postRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let postDict = document.data() {
                        let post = try Post.fromDict(postDict)
                        completion(.success(post))
                    } else {
                        completion(.failure(FirestorePostServiceError.invalidData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(FirestorePostServiceError.documentNotFound))
            }
        }
    }

    // MARK: - Update Post
    func updatePost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        let postDict = post.toDict()  // Convert post to dictionary
        db.collection(postsCollection).document(post.postID).updateData(postDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Delete Post
    func deletePost(byID postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(postsCollection).document(postID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Increment Likes
    func incrementLikes(forPost postID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(postsCollection).document(postID)
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
        let postRef = db.collection(postsCollection).document(postID)
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
        let postRef = db.collection(postsCollection).document(postID)
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
        let postRef = db.collection(postsCollection).document(postID)
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

    // MARK: - Add Media to Post
    func addMedia(toPost postID: String, newMedia: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(postsCollection).document(postID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(postRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var mediaArray = postDocument.data()?["media"] as? [[String: Any]] else {
                return nil
            }
            mediaArray.append(newMedia.toDict())  // Add new media
            transaction.updateData(["media": mediaArray], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Remove Media from Post by Index
    func removeMedia(fromPost postID: String, at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(postsCollection).document(postID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                postDocument = try transaction.getDocument(postRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var mediaArray = postDocument.data()?["media"] as? [[String: Any]] else {
                return nil
            }
            guard index >= 0 && index < mediaArray.count else {
                return nil  // Invalid index
            }
            mediaArray.remove(at: index)  // Remove media at index
            transaction.updateData(["media": mediaArray], forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Edit Post Visibility
    func editPostVisibility(postID: String, newVisibility: PostVisibility, completion: @escaping (Result<Void, Error>) -> Void) {
        let postRef = db.collection(postsCollection).document(postID)
        postRef.updateData([
            "visibility": newVisibility.rawValue
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - FirestorePostServiceError
enum FirestorePostServiceError: Error {
    case invalidData
    case documentNotFound
}
