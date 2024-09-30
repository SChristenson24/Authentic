//
//  LogInView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//

import SwiftUI
import FirebaseAuth
import FBSDKLoginKit



@MainActor
final class LoginViewModel: ObservableObject{
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
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("lpink").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("statue")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350)
                    .padding(.bottom, -150)
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    Spacer()
                    
                    Text("Log In")
                        .font(.custom("Lexend-Bold", size: 35))
                        .padding(.bottom, 20)
                        .foregroundColor(Color("darkgray"))
                        .padding(.trailing, 180)
                    
                    Text("Email")
                        .font(.custom("Lexend-Thin", size: 16))
                        .padding(.top, -10)
                        .padding(.bottom, 15)
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
                        .font(.custom("Lexend-Thin", size: 16))
                        .padding(.top, 25)
                        .padding(.bottom, 15)
                        .padding(.trailing, 250)
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
                    .padding(.bottom, 30)
                    
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
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                        Button(action: {
                            // do smtn here
                        }){
                            Image("appleicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
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
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    Button("Log In") {
                        signIn()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("lpink"))
                    .cornerRadius(25)
                    .padding(.horizontal, 80)
                    
                    HStack {
                        Text("Don't have an account?")
                        Button(action: {
                            showingSignUp.toggle()
                        }) {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("bpink"))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                    
                    Spacer()
                }
                .background(Color.white)
                .cornerRadius(35)
                .edgesIgnoringSafeArea(.bottom)
                .shadow(radius: 5)
            }
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
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
