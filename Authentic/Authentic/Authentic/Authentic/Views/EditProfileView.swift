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
        
        // Update the field in Firestore
        db.collection("users").document(userId).updateData([fieldLabel.lowercased(): newValue]) { error in
            if let error = error {
                print("Error updating \(fieldLabel): \(error.localizedDescription)")
            } else {
                print("\(fieldLabel) updated successfully.")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
