//
//  LogInView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//

import SwiftUI
import FirebaseAuth
import FBSDKLoginKit
import CryptoKit
import AuthenticationServices


public struct SignInWithAppleResult{
    let token: String
    let nonce: String
    
}

@MainActor
final class LoginViewModel: NSObject, ObservableObject{
    private var currentNonce: String?
    public var didSignInWithApple: Bool = false
    
   
    
    func singInGoogle() async throws{
       
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
    }
    func signInWithFacebook() async throws {
            let helper = SignInFacebookHelper()
            let tokens = try await helper.signIn()
            try await AuthenticationManager.shared.signInWithFacebook(tokens: tokens)
        }
    func signInApple() async throws{
        startSignInWithAppleFlow()
    }
    
    func startSignInWithAppleFlow() {
        guard let TopVC = Utilities.shared.topViewController() else {
            return
        }
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = TopVC
      authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

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
            print("error")
            return
        }
        
        let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce)
    
    Task {
        do {
            try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
            didSignInWithApple = true
        } catch {
            print("Sign in with apple failed: \(error.localizedDescription)")
        }
    }
}
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding{
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingSignUp = false
    @State private var isLoading = false
    @State private var error: String = ""
    @State private var isLoggedIn = false
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
                    Spacer()
                    
                    Text("Log In")
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
                    
                    HStack{
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
                    
                    // MARK: RESET BUTTON
                    Button("Reset password?", action: {})
                        .font(.custom("Lexend-Regular", size: 12))
                        .foregroundColor(Color("bpink"))
                        .padding(.top, -20)
                        .padding(.leading, 175)
                    
                    //MARK: AUTH BUTTONS
                    if !error.isEmpty{
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                    }
                    if isLoading{
                        ProgressView()
                            .padding(.bottom, 20)
                    }
                    HStack(spacing: 30) {
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.signInWithFacebook()
                                    isLoggedIn = true
                                } catch {
                                    self.error = error.localizedDescription
                                }
                            }
                        }){
                            Image("fbicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.signInApple()
                                    isLoggedIn = true
                                } catch {
                                    print(error)
                                }
                            }
                        }){
                            Image("appleicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                        
                        Button(action: {
                            Task{
                                do{
                                    try await viewModel.singInGoogle()
                                    isLoggedIn = true
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }){
                            Image("googleicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    Button(action: {
                        signIn()
                    }) {
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
                    
                    HStack {
                        Text("Don't have an account?")
                            .font(.custom("Lexend-Light", size: 14))
                            .foregroundColor(Color.gray)
                        Button(action: {
                            isShowingSignup = true
                        }) {
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

        .fullScreenCover(isPresented: $isLoggedIn)
        {
            SuccessView() //********WILL NEED UPDATED APPROPRIATELY**********
        }
    }
    
    
    
    func signIn() {
        isLoading = true
        error = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                self.isLoggedIn = true
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showLogInView: .constant(true), isShowingSignup: .constant(false))
    }
}


