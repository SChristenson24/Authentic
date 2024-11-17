//
//  EditProfileView.swift
//  Authentic
//
//  Created by Amanuel Tesfaye on 11/11/24.
//

import SwiftUI
import FirebaseFirestore

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var currentValue: String
    @State private var newValue: String
    var fieldLabel: String
    let userId: String
    let fieldMapping: [String: String] = [
        "First Name": "firstName",
        "Last Name": "lastName",
        "Username": "username",
        "Email": "email",
        "Bio": "bio"
    ]
    
    init(fieldLabel: String, currentValue: String, userId: String) {
        self.fieldLabel = fieldLabel
        self._currentValue = State(initialValue: currentValue)
        self._newValue = State(initialValue: currentValue)
        self.userId = userId
    }

    var body: some View {
        VStack {
            TextField("Enter new \(fieldLabel)", text: $newValue)
                .padding()
                .background(Color("lightgray"))
                .cornerRadius(5)
                .padding(.horizontal, 20)
            
            Button(action: {
                saveChanges()
            }) {
                Text("Save Changes")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(5)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .navigationTitle("Edit \(fieldLabel)")
    }

    func saveChanges() {
        guard !newValue.isEmpty else { return }
        
        let db = Firestore.firestore()
        
        // Get the correct Firestore field name based on fieldLabel
        if let firestoreField = fieldMapping[fieldLabel] {
            db.collection("users").document(userId).updateData([firestoreField: newValue]) { error in
                if let error = error {
                    print("Error updating \(fieldLabel): \(error.localizedDescription)")
                } else {
                    print("\(fieldLabel) updated successfully.")
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            print("No matching Firestore field found for \(fieldLabel)")
        }
    }
}
