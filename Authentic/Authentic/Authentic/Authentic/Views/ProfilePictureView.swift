//
//  ProfilePictureView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 11/7/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfilePictureView: View {
    @State private var image: UIImage?
    @State private var isPickerPresented = false
    @State private var hasLoadedImage = false // Track if the image has already been loaded
    @State private var lastSavedImage: UIImage? // Track the last saved image
    
    var userId: String

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .clipped()
                    .onTapGesture {
                        isPickerPresented = true
                    }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        isPickerPresented = true
                    }
            }
        }
        .onAppear {
            if !hasLoadedImage {
                loadProfilePicture() // Load image only once when the view appears
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $image)
        }
        .onChange(of: image) { newImage in
            if let newImage = newImage, newImage != lastSavedImage {
                // Only upload when the image changes
                uploadProfilePicture(image: newImage, userId: userId) { url in
                    if let url = url {
                        saveProfilePictureURL(userId: userId, url: url)
                        lastSavedImage = newImage // Update last saved image
                    }
                }
            }
        }
    }
    
    // Method to load the profile picture URL from Firestore
    private func loadProfilePicture() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if let urlString = document.get("profilePictureURL") as? String, let url = URL(string: urlString) {
                    downloadImage(from: url)
                }
            } else {
                print("No profile picture found or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Method to download image from Firebase Storage
    private func downloadImage(from url: URL) {
        let storageRef = Storage.storage().reference(forURL: url.absoluteString)
        
        storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            if let data = data, let downloadedImage = UIImage(data: data) {
                self.image = downloadedImage
                self.hasLoadedImage = true // Set flag to avoid reloading unnecessarily
            }
        }
    }

    // Method to upload the profile picture to Firebase Storage
    private func uploadProfilePicture(image: UIImage, userId: String, completion: @escaping (URL?) -> Void) {
        // Convert UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Error: Unable to convert image to data.")
            completion(nil)
            return
        }

        // Create a unique filename for the image using the user's ID
        let storageRef = Storage.storage().reference().child("profile_pictures/\(userId).jpg")

        // Upload the image data to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            // Get the download URL for the uploaded image
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                // Return the download URL in the completion handler
                completion(url)
            }
        }
    }

    // Method to save the profile picture URL to Firestore
    private func saveProfilePictureURL(userId: String, url: URL) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)
        
        docRef.updateData([
            "profilePictureURL": url.absoluteString
        ]) { error in
            if let error = error {
                print("Error saving profile picture URL: \(error.localizedDescription)")
            } else {
                print("Profile picture URL saved successfully.")
            }
        }
    }
}


