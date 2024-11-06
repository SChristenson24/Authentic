//
//  DashboardView.swift
//  Authentic
//
//  Created by Sydney Christenson on 11/6/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    LandingPageView()
}
