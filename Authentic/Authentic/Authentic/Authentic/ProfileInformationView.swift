import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileInformationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var birthday = Date()
    @State private var errorMessage: String = ""
    @State private var navToSuccess = false

    // Passed from the SignUpView
    let email: String
    let password: String

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lpink").edgesIgnoringSafeArea(.all)

                VStack {
                    // MARK: Custom Back Button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .padding(.leading, 16)
                        }
                        Spacer()
                    }

                    Text("Complete Your Profile")
                        .font(.custom("Lexend-Bold", size: 24))
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .foregroundColor(Color("darkgray"))

                    VStack(spacing: 20) {
                        // MARK: First Name Field
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("First Name", text: $firstName)
                                .padding(.leading, 10)
                        }
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .padding(.horizontal, 20)

                        // MARK: Last Name Field
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            TextField("Last Name", text: $lastName)
                                .padding(.leading, 10)
                        }
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .padding(.horizontal, 20)

                        // MARK: Username Field
                        HStack {
                            Image(systemName: "at")
                                .foregroundColor(.gray)
                            TextField("Username", text: $username)
                                .padding(.leading, 10)
                        }
                        .padding()
                        .background(Color("lightgray"))
                        .cornerRadius(25)
                        .padding(.horizontal, 20)

                        // MARK: Birthday Date Picker
                        VStack(alignment: .leading) {
                            Text("Birthday")
                                .font(.custom("Lexend-Light", size: 16))
                                .foregroundColor(Color.gray)
                                .padding(.leading, 30)

                            DatePicker("", selection: $birthday, displayedComponents: .date)
                                .padding()
                                .background(Color("lightgray"))
                                .cornerRadius(25)
                                .padding(.horizontal, 20)
                                .datePickerStyle(WheelDatePickerStyle())
                                .padding(.bottom, -30)
                        }

                        // MARK: Error Message Styling
                        Text(errorMessage.isEmpty ? " " : errorMessage)
                            .foregroundColor(Color("bpink"))
                            .font(.custom("Lexend-Regular", size: 14))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .fixedSize(horizontal: false, vertical: true)
                            .opacity(errorMessage.isEmpty ? 0 : 1)

                        Spacer()

                        // MARK: Save Profile Button
                        Button(action: validateAndSaveProfile) {
                            Text("Save Profile")
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .background(Color("bpink"))
                                .cornerRadius(25)
                                .padding(.horizontal, 80)
                                .padding(.bottom, 20)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                    .background(Color.white)
                    .cornerRadius(35)
                    .shadow(radius: 5)
                    .frame(maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .navigationDestination(isPresented: $navToSuccess) {
                    SuccessView()
                }
                .navigationBarBackButtonHidden(true)
            }
        }
    }

    // MARK: Validate and Save Profile
    private func validateAndSaveProfile() {
        errorMessage = ""
        
        // Validate fields
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year ?? 0
        
        if firstName.isEmpty || lastName.isEmpty || username.isEmpty {
            errorMessage = "All fields are required."
            return
        } else if age < 18 {
            errorMessage = "You must be at least 18 years old."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                }
                return
            }
            
            let db = Firestore.firestore()
            if let userId = Auth.auth().currentUser?.uid {
                db.collection("users").document(userId).setData([
                    "firstName": firstName,
                    "lastName": lastName,
                    "username": username,
                    "birthday": birthday,
                    "email": email
                ]) { err in
                    if let err = err {
                        errorMessage = "Error saving profile: \(err.localizedDescription)"
                    } else {
                        navToSuccess = true
                    }
                }
            }
        }
    }
}
