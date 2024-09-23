//
//  NewsView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 9/22/24.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        VStack {
            Text("News Page")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NewsView()
}
