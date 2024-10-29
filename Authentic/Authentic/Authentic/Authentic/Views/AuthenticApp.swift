import SwiftUI
import FirebaseCore
import FBSDKCoreKit

@main
struct AuthenticApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }

    var body: some Scene {
        WindowGroup {
            LandingPageView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}
