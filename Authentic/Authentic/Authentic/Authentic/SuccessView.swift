//
//  SuccessView.swift
//  Authentic
//
//  Created by John Mark Taylor on 9/24/24.
//
import SwiftUI

struct SuccessView: View {
    var body: some View {
        ZStack {
            // Background Color (Pink)
            Color.pink
                .ignoresSafeArea() // Fills the entire screen
            
            // Text in the center
            Text("You are successfully signed in")
                .font(.title) // Font size
                .foregroundColor(.black) // Text color
                .padding()
        }
    }
}
