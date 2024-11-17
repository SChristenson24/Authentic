//
//  SettingsView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 11/7/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView { // Wrap in NavigationView
            VStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .padding(.horizontal, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text("Settings")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 15)
                    .padding(.horizontal, 25)
                
                Text("Manage your account information here")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.top, 2)
                
                VStack {
                    // NavigationLink for Personal Details
                    NavigationLink(destination: PersonalDetailsView()) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.black)
                                .padding(.leading, 15)
                            
                            Text("Personal Details")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 15)
                        }
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                            .padding(.leading, 15)
                        
                        Text("Help")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 15)
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color("lightgray"))
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
        }
    }
}


#Preview {
    SettingsView()
}


