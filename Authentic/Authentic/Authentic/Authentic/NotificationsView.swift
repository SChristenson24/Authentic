//
//  NotificationsView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 9/22/24.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notification Page")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Notification")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotificationsView()
}
