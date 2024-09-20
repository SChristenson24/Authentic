//
//  AuthenticApp.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/28/24.
//

import SwiftUI
import FirebaseCore

@main
struct AuthenticApp: App {
    let persistenceController = PersistenceController.shared
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LandingPageView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
