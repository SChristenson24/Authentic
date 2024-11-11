//
//  ImagePicker.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 11/7/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

func uploadProfilePicture(image: UIImage, userId: String, completion: @escaping (URL?) -> Void) {
    let storageRef = Storage.storage().reference().child("profilePictures/\(userId).jpg")
    
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(nil)
        return
    }
    
    storageRef.putData(imageData, metadata: nil) { _, error in
        if let error = error {
            print("Failed to upload image: \(error)")
            completion(nil)
            return
        }
        
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Failed to get download URL: \(error)")
                completion(nil)
                return
            }
            completion(url)
        }
    }
}

func saveProfilePictureURL(userId: String, url: URL) {
    let db = Firestore.firestore()
    db.collection("users").document(userId).setData(["profilePictureURL": url.absoluteString], merge: true) { error in
        if let error = error {
            print("Error saving profile picture URL: \(error)")
        } else {
            return
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
