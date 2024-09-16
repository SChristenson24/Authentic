//
//  SignUpView.swift
//  Authentic
//
//  Created by Sydney Christenson on 2/29/24.
//

import SwiftUI

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

    var body: some View {
        ZStack(alignment: .top) {
            

            Color("lpink").edgesIgnoringSafeArea(.all)
            
            VStack{
                Image("stat")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350)
                    //.padding(.top, 10)
                    .padding(.bottom, -150)
                    .edgesIgnoringSafeArea(.bottom)
                VStack{
                    
                    Text("Sign Up")
                        .font(.custom("Lexend-Bold", size: 35))
                        .padding(.bottom, 20)
                        .padding(.top, 50)
                        .foregroundColor(Color("darkgray"))
                        .padding(.trailing, 180)
                    
                    Text("Email")
                        .font(.custom("Lexend-Thin", size: 16))
                        .padding(.top, -10)
                        .padding(.bottom, 15)
                        .padding(.trailing, 270)
                        .foregroundColor(Color.gray)
                    
                    TextField("", text: $email)
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .shadow(radius: 1)
                        .padding(.horizontal, 25)
                    
                    Text("Password")
                        .font(.custom("Lexend-Thin", size: 16))
                        .padding(.top, 25)
                        .padding(.bottom, 15)
                        .padding(.trailing, 250)
                        .foregroundColor(Color.gray)
                    
                    
                    SecureField("", text: $password)
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .shadow(radius: 1)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 30)
                    
                    
                    Button("Next") {
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color("lpink"))
                    .cornerRadius(25)
                    .padding(.horizontal, 50)
                    
                    HStack {
                        Text("Already have an account?")
                        Button(action: {
                            showingLogin.toggle()
                        }) {
                            Text("Sign in")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("lpink"))
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


