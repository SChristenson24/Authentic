//
//  DirectMessageView.swift
//  Authentic
//
//  Created by John Mark Taylor on 11/17/24.
//

import SwiftUI

struct DirectMessageView: View {
    @State private var searchText: String = ""
    @State private var selectedConversation: Conversation? = nil
    @State private var messages: [Message] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search users...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Conversation List
                List(sampleConversations) { conversation in
                    Button {
                        selectedConversation = conversation
                    } label: {
                        ConversationRow(conversation: conversation)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Direct Messages")
            .background(
                NavigationLink(destination: ConversationDetailView(conversation: selectedConversation), isActive: .constant(selectedConversation != nil)) {
                    EmptyView()
                }
            )
        }
    }
}

// MARK: - Conversation Row
struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .overlay(Text(conversation.userInitials).foregroundColor(.white))
            VStack(alignment: .leading) {
                Text(conversation.userName).font(.headline)
                Text(conversation.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(conversation.timestamp, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Conversation Detail View
struct ConversationDetailView: View {
    let conversation: Conversation?
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            // Message List
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(conversation?.messages ?? []) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message Input
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    // Send action (To be implemented)
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(newMessage.isEmpty ? .gray : .blue)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle(conversation?.userName ?? "Conversation")
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isSentByCurrentUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Preview
struct DirectMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        DirectMessageView()
    }
}

// MARK: - Sample Data
struct Conversation: Identifiable {
    let id = UUID()
    let userName: String
    let userInitials: String
    let lastMessage: String
    let timestamp: Date
    let messages: [Message]
}

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isSentByCurrentUser: Bool
}

let sampleConversations: [Conversation] = [
    Conversation(userName: "Alice", userInitials: "A", lastMessage: "See you tomorrow!", timestamp: Date(), messages: [
        Message(content: "Hey Alice!", isSentByCurrentUser: true),
        Message(content: "See you tomorrow!", isSentByCurrentUser: false)
    ]),
    Conversation(userName: "Bob", userInitials: "B", lastMessage: "Sounds good!", timestamp: Date(), messages: [
        Message(content: "Want to meet?", isSentByCurrentUser: false),
        Message(content: "Sounds good!", isSentByCurrentUser: true)
    ])
]
