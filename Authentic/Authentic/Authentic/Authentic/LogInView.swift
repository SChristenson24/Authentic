//
//  LogInView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingSignUp = false

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
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            // do smtn here
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
                            // do smtn here
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
                        // Handle the login logic here
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
