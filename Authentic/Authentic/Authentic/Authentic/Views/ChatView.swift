//
//  ChatView.swift
//  Authentic
//
//  Created by John Mark Taylor on 11/19/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatView: View {
    var user: ChatUser
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    
    private let currentUserId = "currentUserId" // Replace with your current logged-in user ID
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            // Messages List
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.senderId == currentUserId {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            // Input Field
            HStack {
                TextField("Enter your message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .onAppear(perform: fetchMessages)
        .navigationTitle("Chat with \(user.username)")
    }
    
    // Function to fetch messages
    private func fetchMessages() {
        let chatId = generateChatId(for: user.id ?? "")
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                self.messages = documents.compactMap { doc -> ChatMessage? in
                    try? doc.data(as: ChatMessage.self)
                }
            }
    }
    
    // Function to send a message
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let chatId = generateChatId(for: user.id ?? "")
        let message = ChatMessage(
            senderId: currentUserId,
            receiverId: user.id ?? "",
            text: messageText,
            timestamp: Date()
        )
        
        do {
            let _ = try db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(from: message)
            
            messageText = ""
        } catch {
            print("Error sending message: \(error)")
        }
    }
    
    // Function to generate a chat ID (for simplicity, sorted concatenation of user IDs)
    private func generateChatId(for otherUserId: String) -> String {
        return [currentUserId, otherUserId].sorted().joined(separator: "_")
    }
}

// MARK: - ChatMessage Model
struct ChatMessage: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var receiverId: String
    var text: String
    var timestamp: Date
}

