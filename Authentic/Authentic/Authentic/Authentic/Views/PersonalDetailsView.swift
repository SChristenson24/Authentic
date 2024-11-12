//
//  PersonalDetailsView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 11/11/24.
//

import SwiftUI
import FirebaseAuth

struct PersonalDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userViewModel = ViewModel()
    let userid = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
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
            
            Text("Personal Details")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
                .padding(.horizontal, 25)
            
            Text("Authentic uses this information to verify your identity and to keep our community safe.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.top, 2)
            
            VStack {
                detailRow(label: "Username", value: userViewModel.username)
                detailRow(label: "First Name", value: userViewModel.firstName)
                detailRow(label: "Last Name", value: userViewModel.lastName)
                detailRow(label: "Email", value: userViewModel.email)
                detailRow(label: "Bio", value: userViewModel.email)
            }
            .padding()
            .background(Color("lightgray"))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await userViewModel.fetchData()
            }
        }
    }
    
    func detailRow(label: String, value: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                Text(value)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            NavigationLink(destination: EditProfileView(fieldLabel: label, currentValue: value, userId: userid)) {
                Text("Edit")
                    .foregroundColor(.pink)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 15)
            }
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PersonalDetailsView()
}


