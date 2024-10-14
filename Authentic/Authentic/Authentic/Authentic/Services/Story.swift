//
//  Story.swift
//  Authentic
//
//  Created by Gage Fulwood on 10/13/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreStoryService {
    
    private let db = Firestore.firestore()
    
    // Firestore collection path for stories
    private let storiesCollection = "stories"

    // MARK: - Create Story
    func createStory(_ story: Story, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyDict = story.toDict()  // Convert Story to dictionary
        db.collection(storiesCollection).document(story.storyID).setData(storyDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Read Story by ID
    func getStory(byID storyID: String, completion: @escaping (Result<Story, Error>) -> Void) {
        let storyRef = db.collection(storiesCollection).document(storyID)
        storyRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let storyDict = document.data() {
                        let story = try Story.fromDict(storyDict)
                        completion(.success(story))
                    } else {
                        completion(.failure(FirestoreStoryServiceError.invalidData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(FirestoreStoryServiceError.documentNotFound))
            }
        }
    }

    // MARK: - Update Story
    func updateStory(_ story: Story, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyDict = story.toDict()  // Convert story to dictionary
        db.collection(storiesCollection).document(story.storyID).updateData(storyDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Delete Story
    func deleteStory(byID storyID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(storiesCollection).document(storyID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Extend Story Expiration
    func extendStoryExpiration(byID storyID: String, additionalTime: TimeInterval, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyRef = db.collection(storiesCollection).document(storyID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let storyDocument: DocumentSnapshot
            do {
                storyDocument = try transaction.getDocument(storyRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard let expirationTimestamp = storyDocument.data()?["expirationDate"] as? Timestamp else {
                return nil
            }
            let newExpirationDate = expirationTimestamp.dateValue().addingTimeInterval(additionalTime)
            transaction.updateData(["expirationDate": Timestamp(date: newExpirationDate)], forDocument: storyRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Add Media to Story
    func addMedia(toStory storyID: String, newMedia: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyRef = db.collection(storiesCollection).document(storyID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let storyDocument: DocumentSnapshot
            do {
                storyDocument = try transaction.getDocument(storyRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var mediaArray = storyDocument.data()?["media"] as? [[String: Any]] else {
                return nil
            }
            mediaArray.append(newMedia.toDict())  // Add new media
            transaction.updateData(["media": mediaArray], forDocument: storyRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Remove Media from Story by Index
    func removeMedia(fromStory storyID: String, at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyRef = db.collection(storiesCollection).document(storyID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let storyDocument: DocumentSnapshot
            do {
                storyDocument = try transaction.getDocument(storyRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var mediaArray = storyDocument.data()?["media"] as? [[String: Any]] else {
                return nil
            }
            guard index >= 0 && index < mediaArray.count else {
                return nil  // Invalid index
            }
            mediaArray.remove(at: index)  // Remove media at index
            transaction.updateData(["media": mediaArray], forDocument: storyRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Replace Media in Story by Index
    func replaceMedia(inStory storyID: String, at index: Int, with newMedia: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyRef = db.collection(storiesCollection).document(storyID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let storyDocument: DocumentSnapshot
            do {
                storyDocument = try transaction.getDocument(storyRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            
            guard var mediaArray = storyDocument.data()?["media"] as? [[String: Any]] else {
                return nil
            }
            guard index >= 0 && index < mediaArray.count else {
                return nil  // Invalid index
            }
            mediaArray[index] = newMedia.toDict()  // Replace media at index
            transaction.updateData(["media": mediaArray], forDocument: storyRef)
            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Edit Story Visibility
    func editStoryVisibility(storyID: String, newVisibility: PostVisibility, completion: @escaping (Result<Void, Error>) -> Void) {
        let storyRef = db.collection(storiesCollection).document(storyID)
        storyRef.updateData([
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

// MARK: - FirestoreStoryServiceError
enum FirestoreStoryServiceError: Error {
    case invalidData
    case documentNotFound
}
