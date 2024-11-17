//
//  DashboardView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 9/21/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            NewsView()
                .tabItem {
                    Image(systemName: "newspaper")
                }
            
            CreateView()
                .tabItem {
                    Image(systemName: "plus.app")
                }
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    DashboardView()
}










