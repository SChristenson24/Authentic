import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navToProfileInfo = false
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    @Binding var isShowingSignup: Bool
    @Binding var showLogInView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("lpink").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("stat")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                        .padding(.bottom, -140)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack {
                        // MARK: Sign Up Text
                        Text("Sign Up")
                            .font(.custom("Lexend-Bold", size: 35))
                            .padding(.bottom, 30)
                            .padding(.top, 50)
                            .foregroundColor(Color("darkgray"))
                            .padding(.trailing, 200)
                        
                        // MARK: Email Field
                        Text("Email")
                            .font(.custom("Lexend-Light", size: 14))
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
                        
                        // MARK: Password Field
                        Text("Password")
                            .font(.custom("Lexend-Light", size: 14))
                            .padding(.top, 25)
                            .padding(.bottom, 1)
                            .padding(.trailing, 235)
                            .foregroundColor(Color.gray)
                        
                        HStack {
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
                        
                        // MARK: Error Messages
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(Color("bpink"))
                                .font(.custom("Lexend-Regular", size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        Button(action: {
                            validateFields()
                        }) {
                            Text("Next")
                                .font(.custom("Lexend-Regular", size: 16))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color("bpink"))
                                .cornerRadius(25)
                        }
                        .padding(.horizontal, 80)
                        .padding(.bottom, 10)
                        .navigationDestination(isPresented: $navToProfileInfo) {
                            ProfileInformationView(isThirdPartyAuth: false, email: email, password: password)
                        }
                        
                        // MARK: Third-Party Auth Buttons
                        HStack(spacing: 30) {
                            Button(action: {
                                // Add Facebook login logic here
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
                                // Add Apple login logic here
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
                                // Add Google login logic here
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
                        
                        HStack {
                            Text("Already have an account?")
                                .font(.custom("Lexend-Light", size: 14))
                                .foregroundColor(Color.gray)
                            Button(action: {
                                isShowingSignup = false
                            }) {
                                Text("Log In")
                                    .font(.custom("Lexend-SemiBold", size: 14))
                                    .foregroundColor(Color("bpink"))
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(35)
                    .edgesIgnoringSafeArea(.bottom)
                    .shadow(radius: 5)
                }
            }
        }
    }
    
    // MARK: Input Validation
    private func validateFields() {
        errorMessage = ""
        
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
        } else if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
        } else {
            navToProfileInfo = true
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isShowingSignup: .constant(true), showLogInView: .constant(false))
    }
}
