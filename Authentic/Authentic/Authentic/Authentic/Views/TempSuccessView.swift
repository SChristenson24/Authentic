import SwiftUI
import FirebaseAuth

struct TempSuccessView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome! This should be the homepage")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding()
            
            Button(action: {
                signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("bpink"))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully.")
        } catch let error as NSError {
            print("Error signing out: %@", error)
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        TempSuccessView()
    }
}
