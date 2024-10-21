//
//  SignUpView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//
// MARK: The Log In button WILL NOT WORK while in dev. The Log in page will appear first and will show this SignUpView once called by user clicking the "Sign Up" button. 

import SwiftUI
import FirebaseAuth
import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    // MARK: View Properties
    @Binding var isShowingSignup: Bool
    //@Binding var isShowingLogin: Bool
    @State private var alertMessage: String? = nil
    @State private var showAlert: Bool = false


    var body: some View {
        ZStack(alignment: .top) {
            Color("lpink").edgesIgnoringSafeArea(.all)
            
            VStack{
                Image("stat")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350)
                    .padding(.bottom, -140)
                    .edgesIgnoringSafeArea(.bottom)
                VStack{
                    
                    Text("Sign Up")
                        .font(.custom("Lexend-Bold", size: 35))
                        .padding(.bottom, 30)
                        .padding(.top, 50)
                        .foregroundColor(Color("darkgray"))
                        .padding(.trailing, 180)
                    
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
                        .padding(.bottom, 30)
                    
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
                    
                    
                    Button("Next") {
                                    //logic here
                                }
                    .font(.custom("Lexend-Regular", size: 16))
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("lpink"))
                    .cornerRadius(25)
                    .padding(.horizontal, 80)
                    
                    HStack {
                         Text("Already have an account?")
                             .font(.custom("Lexend-Light", size: 14))
                             .foregroundColor(Color.gray)
                         Button(action: {
                             isShowingSignup = false
                         }) {
                             Text("Log In")
                                 .font(.custom("Lexend-SemiBold", size: 14))
                                 .foregroundColor(Color("bpink"))
                         }
                    }
                    .padding(.top, 50) 
                    .padding(.bottom, 60)
                    
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isShowingSignup: .constant(true)) 
    }
}


