//
//  LogInView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit
import CryptoKit
import AuthenticationServices

public struct SignInWithAppleResult {
    let token: String
    let nonce: String
}

@MainActor
final class LoginViewModel: NSObject, ObservableObject {
    private var currentNonce: String?
    @Published var didSignInWithApple = false
    @Published var errorMessage: String? = nil

    // MARK: - Google Sign-In
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }

    // MARK: - Facebook Sign-In
    func signInWithFacebook() async throws {
        let loginManager = LoginManager()
        
        // Use async `withCheckedThrowingContinuation` to handle Facebook login
        let result: LoginManagerLoginResult = try await withCheckedThrowingContinuation { continuation in
            loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result, result.isCancelled {
                    continuation.resume(throwing: NSError(domain: "FacebookLoginError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User cancelled login."]))
                } else if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: NSError(domain: "FacebookLoginError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unknown login error."]))
                }
            }
        }
        
        // Retrieve the access token and sign in with Firebase
        guard let tokenString = result.token?.tokenString else {
            throw NSError(domain: "FacebookLoginError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get Facebook access token."])
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        try await Auth.auth().signIn(with: credential)
    }

    // MARK: - Apple Sign-In
    func signInApple() async throws {
        startSignInWithAppleFlow()
    }

    private func startSignInWithAppleFlow() {
        guard let topVC = Utilities.shared.topViewController() else { return }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }

    // MARK: - Profile Check
    func checkUserProfileExists(completion: @escaping (Bool, Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user ID found"]))
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(false, error)
            } else if document?.exists == true {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }

    // MARK: - Helper Methods
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce
        else {
            print("Error during Apple authentication")
            return
        }
        
        let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce)
        
        Task {
            do {
                try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
            } catch {
                print("Sign in with Apple failed: \(error.localizedDescription)")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        errorMessage = "Sign in with Apple failed"
    }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    @State private var isProfileSetupNeeded = false
    @State private var isLoginSuccessful = false
    @Binding var showLogInView: Bool
    @Binding var isShowingSignup: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color("lpink").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("statue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350)
                    .padding(.bottom, -140)
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    // MARK: Log In Text
                    Text("Log In")
                        .font(.custom("Lexend-Bold", size: 35))
                        .padding(.bottom, 30)
                        .padding(.top, 50)
                        .foregroundColor(Color("darkgray"))
                        .padding(.trailing, 200)
                    
                    // MARK: Email Field
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
                    
                    // MARK: Password Field
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
                    
                    // MARK: Error Messages
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(Color("bpink"))
                            .font(.custom("Lexend-Regular", size: 14))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    if isLoading {
                        ProgressView()
                            .padding(.bottom, 20)
                    }
                    
                    // MARK: Third-Party Auth Buttons
                    HStack(spacing: 30) {
                        Button(action: { thirdPartyLoginWithFacebook() }) {
                            Image("fbicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                        Button(action: { thirdPartyLoginWithApple() }) {
                            Image("appleicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                        Button(action: { thirdPartyLoginWithGoogle() }) {
                            Image("googleicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    // MARK: Log In Button
                    Button(action: { loginUser() }) {
                        Text("Log In")
                            .font(.custom("Lexend-Regular", size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("bpink"))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 80)
                    .padding(.bottom, 10)
                    
                    // MARK: Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .font(.custom("Lexend-Light", size: 14))
                            .foregroundColor(Color.gray)
                        Button(action: { isShowingSignup = true }) {
                            Text("Sign Up")
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
        .fullScreenCover(isPresented: $isProfileSetupNeeded) {
            ProfileInformationView(isThirdPartyAuth: false, email: email, password: password)
        }
        .fullScreenCover(isPresented: $isLoginSuccessful) {
            SuccessView()
        }
    }
    
    private func loginUser() {
        // Check if email or password is empty
        if email.isEmpty {
            errorMessage = "Please enter an email address."
            return
        }
        
        if password.isEmpty {
            errorMessage = "Please enter a password."
            return
        }

        // Reset error message and show loading indicator
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error as NSError? {
                    // Check Firebase error codes by directly using error.code
                    switch error.code {
                    case AuthErrorCode.userNotFound.rawValue:
                        self.errorMessage = "The email does not belong to an account."
                    case AuthErrorCode.wrongPassword.rawValue:
                        self.errorMessage = "The password is incorrect. Please try again."
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    return
                }
                
                // If no error, proceed to profile check or success view
                self.checkUserProfileExists()
            }
        }
    }


    private func thirdPartyLoginWithFacebook() {
        Task {
            do {
                try await viewModel.signInWithFacebook()
                checkUserProfileExists()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func thirdPartyLoginWithGoogle() {
        Task {
            do {
                try await viewModel.signInGoogle()
                checkUserProfileExists()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func thirdPartyLoginWithApple() {
        Task {
            do {
                try await viewModel.signInApple()
                checkUserProfileExists()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func checkUserProfileExists() {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not retrieve user ID."
            return
        }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userID)

        userDocRef.getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Error fetching profile: \(error.localizedDescription)"
            } else if let document = document, document.exists {
                // Profile exists, go to success view
                self.isProfileSetupNeeded = false
                self.isLoginSuccessful = true
            } else {
                // Profile does not exist, proceed to setup
                self.isProfileSetupNeeded = true
            }
        }
    }
}


