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
    @State private var lastSavedImage: UIImage? 
    
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
                loadProfilePicture()
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(image: $image)
        }
        .onChange(of: image) { newImage in
            if let newImage = newImage, newImage != lastSavedImage {
                uploadProfilePicture(image: newImage, userId: userId) { url in
                    if let url = url {
                        saveProfilePictureURL(userId: userId, url: url)
                        loadProfilePicture() // Reload after uploading new image
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
}


