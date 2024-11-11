//
//  ViewModel.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 11/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var username: String = ""
    
    let db = Firestore.firestore()
    func fetchData() async {
        let userid = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection("users").document(userid)
        
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let data = document.data()
                if let firstName = data?["firstName"] as? String {
                    DispatchQueue.main.async {
                        self.firstName = firstName
                    }
                }
                
                if let lastName = data?["lastName"] as? String {
                    DispatchQueue.main.async {
                        self.lastName = lastName
                    }
                }
                
                if let email = data?["email"] as? String {
                    DispatchQueue.main.async {
                        self.email = email
                    }
                }
                
                if let username = data?["username"] as? String {
                    DispatchQueue.main.async {
                        self.username = username
                    }
                }
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
}
