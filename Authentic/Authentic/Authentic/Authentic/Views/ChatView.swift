//
//  ChatView.swift
//  Authentic
//
//  Created by John Mark Taylor on 11/19/24.
//

import SwiftUI

struct ChatView: View {
    var user: ChatUser

    var body: some View {
        VStack {
            Text("Chat with \(user.username)")
                .font(.largeTitle)
                .padding()
            
            // Here you can add your chat interface (message list, input field, etc.)
            // For example:
            Text("Messages will go here...")
                .padding()
        }
        .navigationTitle("Chat")
    }
}
