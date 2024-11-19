//
//  DirectMessageView.swift
//  Authentic
//
//  Created by John Mark Taylor on 11/17/24.
//

//
//  DirectMessageView.swift
//  Authentic
//
//  Created by John Mark Taylor on 11/17/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DirectMessageView: View {
    @State private var searchText: String = ""
    @State private var users: [ChatUser] = []
    @State private var selectedUser: ChatUser? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search users...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        if newValue.isEmpty {
                            users.removeAll() // Clear the list when search is empty
                        } else {
                            searchUsers(byName: newValue)
                        }
                    }
                
                // User List
                List(users) { user in
                    NavigationLink(destination: ChatView(user: user)) {
                        Text(user.username)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Direct Messages")
        }
    }

    // Function to search users by name
    private func searchUsers(byName name: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: name)
            .whereField("username", isLessThanOrEqualTo: name + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    DispatchQueue.main.async {
                        users = querySnapshot?.documents.compactMap { document in
                            try? document.data(as: ChatUser.self)
                        } ?? []
                    }
                }
            }
    }
}

// MARK: - ChatUser Model
struct ChatUser: Identifiable, Codable {
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var username: String
    var email: String
}

