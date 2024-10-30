import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navToProfileInfo = false
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    @Binding var isShowingSignup: Bool
    @Binding var showLogInView: Bool
    @StateObject private var viewModel = LoginViewModel() // Using the ViewModel for third-party auth

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("lpink").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("stat")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                        .padding(.bottom, -140)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack {
                        Text("Sign Up")
                            .font(.custom("Lexend-Bold", size: 35))
                            .padding(.bottom, 30)
                            .padding(.top, 50)
                            .foregroundColor(Color("darkgray"))
                            .padding(.trailing, 200)
                        
                        Text("Email")
                            .font(.custom("Lexend-Light", size: 14))
                            .padding(.top, -10)
                            .padding(.bottom, 1)
                            .padding(.trailing, 270)
                            .foregroundColor(Color.gray)
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 2)
                            
                            TextField("", text: $email)
                                .padding(.leading, 10)
                        }
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .shadow(radius: 1)
                        .padding(.horizontal, 45)
                        
                        Text("Password")
                            .font(.custom("Lexend-Light", size: 14))
                            .padding(.top, 25)
                            .padding(.bottom, 1)
                            .padding(.trailing, 235)
                            .foregroundColor(Color.gray)
                        
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 2)
                                .rotationEffect(.degrees(45))
                            SecureField("", text: $password)
                                .padding(.leading, 10)
                        }
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .shadow(radius: 1)
                        .padding(.horizontal, 45)
                        .padding(.bottom, 20)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(Color("bpink"))
                                .font(.custom("Lexend-Regular", size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        HStack(spacing: 30) {
                            Button(action: { thirdPartySignUpWithFacebook() }) {
                                Image("fbicon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                    .padding(.bottom, 10)
                            }
                            Button(action: { thirdPartySignUpWithApple() }) {
                                Image("appleicon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                    .padding(.bottom, 10)
                            }
                            Button(action: { thirdPartySignUpWithGoogle() }) {
                                Image("googleicon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                    .padding(.bottom, 10)
                            }
                        }
                        
                        Button(action: { signUpUser() }) {
                            Text("Next")
                                .font(.custom("Lexend-Regular", size: 16))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color("bpink"))
                                .cornerRadius(25)
                        }
                        .padding(.horizontal, 80)
                        .padding(.bottom, 10)
                        .navigationDestination(isPresented: $navToProfileInfo) {
                            ProfileInformationView(isThirdPartyAuth: false, email: email, password: password)
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .font(.custom("Lexend-Light", size: 14))
                                .foregroundColor(Color.gray)
                            Button(action: { isShowingSignup = false }) {
                                Text("Log In")
                                    .font(.custom("Lexend-SemiBold", size: 14))
                                    .foregroundColor(Color("bpink"))
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(35)
                    .edgesIgnoringSafeArea(.bottom)
                    .shadow(radius: 5)
                }
            }
        }
    }

    private func signUpUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.navToProfileInfo = true
            }
        }
    }

    private func thirdPartySignUpWithFacebook() {
        Task {
            do {
                try await viewModel.signInWithFacebook()
                handleSignUpForThirdPartyAuth()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func thirdPartySignUpWithGoogle() {
        Task {
            do {
                try await viewModel.signInGoogle()
                handleSignUpForThirdPartyAuth()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func thirdPartySignUpWithApple() {
        Task {
            do {
                try await viewModel.signInApple()
                handleSignUpForThirdPartyAuth()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func handleSignUpForThirdPartyAuth() {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not retrieve user ID."
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userID)

        userDocRef.getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Failed to retrieve user profile: \(error.localizedDescription)"
            } else if let document = document, document.exists {
                self.navToProfileInfo = false
                self.isShowingSignup = false
                self.showLogInView = false
            } else {
                userDocRef.setData(["userID": userID, "email": Auth.auth().currentUser?.email ?? ""]) { error in
                    if let error = error {
                        self.errorMessage = "Error creating user profile: \(error.localizedDescription)"
                    } else {
                        self.navToProfileInfo = true
                    }
                }
            }
        }
    }
}
