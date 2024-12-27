import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var userName: String = ""
    @State private var userSurname: String = ""
    
    @Binding var isLoggedIn: Bool  // Bind the isLoggedIn state
    
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login to see your statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Rectangle()
                    .foregroundColor(Color(hex: "#108932"))
                    .frame(height: 10)
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 60)
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                }.padding(.horizontal, 40)
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }.padding(.horizontal, 40)
                .padding(.top, 10)
                
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .fontWeight(.bold)
                        .background(Color(hex: "#108932"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                        .padding(.horizontal, 40)
                }
                
                HStack {
                    Text("New here? ")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#7A7A7A"))
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#108932"))
                    }
                }.padding(.horizontal, 40)
                .padding(.top, 10)
                
                Spacer()

                NavigationLink(destination: ProfileView(isLoggedIn: $isLoggedIn), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
        }
    }
    
    func loginUser() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please enter both email and password."
            showAlert = true
            return
        }
        
        // Sign in the user with Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Login failed: \(error.localizedDescription)"
                showAlert = true
            } else if let user = authResult?.user {
                alertMessage = "Login successful!"
                showAlert = true
                isLoggedIn = true
                
                fetchUserDetails(userId: user.uid)
            }
        }
    }
    
    func fetchUserDetails(userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                // Extract user's name and surname from Firestore
                if let name = document.get("name") as? String,
                   let surname = document.get("surname") as? String {
                    // Update the state variables
                    userName = name
                    userSurname = surname
                } else {
                    alertMessage = "Failed to retrieve user details."
                    showAlert = true
                }
            } else {
                alertMessage = "No user data found."
                showAlert = true
            }
        }
    }
}

#Preview {
    LogInView(isLoggedIn: .constant(false))
}
