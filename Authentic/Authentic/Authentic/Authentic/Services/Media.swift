//
//  Media.swift
//  Authentic
//
//  Created by Gage Fulwood on 10/13/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreMediaService {

    private let db = Firestore.firestore()
    
    // Firestore collection path for media
    private let mediaCollection = "media"

    // MARK: - Create Media
    func createMedia(_ media: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        let mediaDict = media.toDict()  // Convert media to dictionary
        db.collection(mediaCollection).document(media.mediaID).setData(mediaDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Read Media by ID
    func getMedia(byID mediaID: String, completion: @escaping (Result<Media, Error>) -> Void) {
        let mediaRef = db.collection(mediaCollection).document(mediaID)
        mediaRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = documentSnapshot, document.exists {
                do {
                    if let mediaDict = document.data() {
                        let media = try Media.fromDict(mediaDict)
                        completion(.success(media))
                    } else {
                        completion(.failure(FirestoreMediaServiceError.invalidData))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(FirestoreMediaServiceError.documentNotFound))
            }
        }
    }

    // MARK: - Update Media
    func updateMedia(_ media: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        let mediaDict = media.toDict()  // Convert media to dictionary
        db.collection(mediaCollection).document(media.mediaID).updateData(mediaDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Delete Media
    func deleteMedia(byID mediaID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(mediaCollection).document(mediaID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Add/Update File URL to Media
    func updateMediaFileURL(mediaID: String, fileURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let mediaRef = db.collection(mediaCollection).document(mediaID)
        mediaRef.updateData(["fileURL": fileURL.absoluteString]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Update Media Title
    func updateMediaTitle(mediaID: String, newTitle: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let mediaRef = db.collection(mediaCollection).document(mediaID)
        mediaRef.updateData(["title": newTitle]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Update Media Duration
    func updateMediaDuration(mediaID: String, newDuration: TimeInterval, completion: @escaping (Result<Void, Error>) -> Void) {
        let mediaRef = db.collection(mediaCollection).document(mediaID)
        mediaRef.updateData(["duration": newDuration]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Change Media Type
    func changeMediaType(mediaID: String, newMediaType: MediaTypes, completion: @escaping (Result<Void, Error>) -> Void) {
        let mediaRef = db.collection(mediaCollection).document(mediaID)
        mediaRef.updateData(["mediaType": newMediaType.rawValue]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - FirestoreMediaServiceError
enum FirestoreMediaServiceError: Error {
    case invalidData
    case documentNotFound
}

