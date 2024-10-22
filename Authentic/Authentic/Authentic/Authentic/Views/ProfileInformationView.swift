import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileInformationView: View {
    @Environment(\.presentationMode) var presentationMode
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
                            presentationMode.wrappedValue.dismiss()
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
                        Button(action: validateAndCreateAccount) {
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
                    TempSuccessView()
                }
                .navigationBarBackButtonHidden(true)  // Hides default back button
            }
        }
    }
    
    // MARK: Profile Function and Firebase Logic
    func validateAndCreateAccount() {
        errorMessage = ""
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year ?? 0
        
        if firstName.isEmpty || lastName.isEmpty || username.isEmpty {
            errorMessage = "All fields are required."
        } else if age < 18 {
            errorMessage = "You must be at least 18 years old."
        } else {
            // Account creation and profile info submission logic
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        errorMessage = error.localizedDescription
                    }
                } else {
                    // Save profile data in Firestore
                    let db = Firestore.firestore()
                    if let userId = authResult?.user.uid {
                        db.collection("users").document(userId).setData([
                            "firstName": firstName,
                            "lastName": lastName,
                            "username": username,
                            "birthday": birthday
                        ]) { err in
                            if let err = err {
                                DispatchQueue.main.async {
                                    errorMessage = "Error saving profile: \(err.localizedDescription)"
                                }
                            } else {
                                // Navigate to success view after successful profile creation
                                DispatchQueue.main.async {
                                    navToSuccess = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
