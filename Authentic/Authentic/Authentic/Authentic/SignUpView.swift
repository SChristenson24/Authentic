//
//  SignUpView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
            .previewDisplayName("iPhone 15")
    }
}


import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingLogin = false
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
                    //.padding(.top, 10)
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
                        .font(.custom("Lexend-Thin", size: 14))
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
                        .font(.custom("Lexend-Thin", size: 14))
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
                            .font(.custom("Lexend-Thin", size: 14))
                            .foregroundColor(Color.gray)
                        Button(action: {
                            showingLogin.toggle()
                        }) {
                            Text("Log in")
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
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
    }
}


