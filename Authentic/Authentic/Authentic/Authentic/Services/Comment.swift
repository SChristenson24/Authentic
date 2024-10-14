//
//  Comment.swift
//  Authentic
//
//  Created by Gage Fulwood on 10/13/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreCommentService {
    
    private let db = Firestore.firestore()
    
    // Firestore collection path for comments
    private let commentsCollection = "comments"

    // MARK: - Create Comment
    func createComment(_ comment: Comment, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentDict = comment.toDict()  // Convert comment to dictionary
        db.collection(commentsCollection).document(comment.commentID).setData(commentDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Read Comment by ID
    func getComment(byID commentID: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        commentRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let commentDict = document.data() {
                        let comment = try Comment.fromDict(commentDict)
                        completion(.success(comment))
                    } else {
                        completion(.failure(FirestoreCommentServiceError.invalidData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(FirestoreCommentServiceError.documentNotFound))
            }
        }
    }

    // MARK: - Update Comment
    func updateComment(_ comment: Comment, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentDict = comment.toDict()
        db.collection(commentsCollection).document(comment.commentID).updateData(commentDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Delete Comment
    func deleteComment(byID commentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(commentsCollection).document(commentID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Increment Likes
    func incrementLikes(forComment commentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let commentDocument: DocumentSnapshot
            do {
                commentDocument = try transaction.getDocument(commentRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var likes = commentDocument.data()?["likes"] as? Int else {
                return nil
            }
            likes += 1
            transaction.updateData(["likes": likes], forDocument: commentRef)
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
    func decrementLikes(forComment commentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let commentDocument: DocumentSnapshot
            do {
                commentDocument = try transaction.getDocument(commentRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var likes = commentDocument.data()?["likes"] as? Int, likes > 0 else {
                return nil
            }
            likes -= 1
            transaction.updateData(["likes": likes], forDocument: commentRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Add Reply to Comment
    func addReply(toComment commentID: String, reply: Comment, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let commentDocument: DocumentSnapshot
            do {
                commentDocument = try transaction.getDocument(commentRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var commentData = commentDocument.data(),
                  var replies = commentData["children"] as? [[String: Any]] else {
                return nil
            }
            
            replies.append(reply.toDict())  // Append new reply
            transaction.updateData(["children": replies], forDocument: commentRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Delete Reply from Comment
    func deleteReply(fromComment commentID: String, replyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let commentDocument: DocumentSnapshot
            do {
                commentDocument = try transaction.getDocument(commentRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var commentData = commentDocument.data(),
                  var replies = commentData["children"] as? [[String: Any]] else {
                return nil
            }
            
            replies.removeAll { ($0["commentID"] as? String) == replyID }  // Remove reply by ID
            transaction.updateData(["children": replies], forDocument: commentRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Mark Comment as Deleted
    func markCommentAsDeleted(commentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        commentRef.updateData([
            "status": CommentStatus.deleted.rawValue,
            "text": "[Deleted]"
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Mark Comment as Reported
    func markCommentAsReported(commentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let commentRef = db.collection(commentsCollection).document(commentID)
        commentRef.updateData([
            "status": CommentStatus.reported.rawValue
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - FirestoreCommentServiceError
enum FirestoreCommentServiceError: Error {
    case invalidData
    case documentNotFound
}
