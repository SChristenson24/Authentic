import SwiftUI

struct ProfileInformationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var birthday = Date()
    @State private var errorMessage: String = ""
    @State private var isProfileComplete = false
    
    var body: some View {
        ZStack {
            Color("lpink").edgesIgnoringSafeArea(.all)
            // MARK: White Field Container
            VStack {


                Text("Complete Your Profile")
                    .font(.custom("Lexend-Bold", size: 24))
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    .foregroundColor(Color("darkgray"))
                
                VStack(spacing: 20) {
                    // MARK: First Name
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

                    // MARK: Last Name
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

                    //MARK: Birthday Date Picker
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
                    }

                    // MARK: Error Message Styling
                    Text(errorMessage.isEmpty ? " " : errorMessage)
                        .foregroundColor(Color("bpink"))
                        .font(.custom("Lexend-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                        .opacity(errorMessage.isEmpty ? 0 : 1)
                    
                    Spacer()
                    
                    //MARK: Save Button
                    Button(action: validateAndSaveProfile) {
                        Text("Save Profile")
                            .font(.custom("Lexend-Regular", size: 16))
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color("bpink"))
                            .cornerRadius(25)
                            .padding(.horizontal, 80)
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
        }
    }
    
    // MARK: Profile Function
    func validateAndSaveProfile() {
        errorMessage = ""
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year ?? 0
        
        if firstName.isEmpty || lastName.isEmpty || username.isEmpty {
            errorMessage = "All fields are required."
        } else if age < 18 {
            errorMessage = "You must be at least 18 years old."
        } else {
            isProfileComplete = true
            print("Profile saved successfully.")
        }
    }
}

struct ProfileInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationView()
    }
}
