//
//  LogInView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    // MARK: User Details
    @State private var email: String = ""
    @State private var password: String = ""
    // MARK: View Properties
    @State var showingSignUp: Bool = false
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @Binding var isShowingSignup: Bool
   // @Binding var isShowingLogin: Bool

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
                    
                    // MARK: Email Text
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

                    // MARK: Password Text
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
                    // MARK: Reset Password
                    Button("Reset password?", action: {})
                        .font(.custom("Lexend-Regular", size: 12))
                        .foregroundColor(Color("bpink"))
                        .padding(.top, -20)
                       // .padding(.bottom, 10)
                        .padding(.leading, 175)
                    // MARK: Auth Buttons
                    HStack(spacing: 30) {
                        Button(action: {
                            // do smtn here
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
                            // do smtn here
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
                            // do smtn here
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
                        //validateSignUpData()
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
    }
}
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isShowingSignup: .constant(false))
    }
}




