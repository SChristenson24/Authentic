//
//  SuccessView.swift
import SwiftUI

struct SuccessView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Background Color (Pink)
            Color.pink
                .ignoresSafeArea() // Fills the entire screen
            
            // Content
            VStack {
                Text("You are successfully signed in")
                    .font(.title) // Font size
                    .foregroundColor(.black) // Text color
                    .padding()
                
                // Logout Button
                Button(action: {
                    Task {
                        do {
                            try await AuthenticationManager.shared.signOut()
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error signing out: \(error)")
                        }
                    }
                }) {
                    Text("Log Out")
                        .font(.headline) // Font size
                        .padding()
                        .background(Color.black) // Background color for the button
                        .foregroundColor(.white) // Text color
                        .cornerRadius(10) // Rounded corners
                }
            }
            .padding(.top, 20) // Space above the button
        }
    }
}
