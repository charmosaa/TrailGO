import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateAccountView: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false  // To handle login status and navigate to profile view

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("Name")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Enter your name", text: $name)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }.padding(.horizontal, 40)

                VStack(alignment: .leading) {
                    Text("Surname")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Enter your surname", text: $surname)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }.padding(.horizontal, 40)

                VStack(alignment: .leading) {
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none) // Disable auto-capitalization
                        .onChange(of: email) { newValue in
                            email = newValue.lowercased() // Convert to lowercase
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }.padding(.horizontal, 40)

                VStack(alignment: .leading) {
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }.padding(.horizontal, 40)

                Button(action: {
                    createUser()
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color(hex: "#108932"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                        .padding(.horizontal, 40)
                }
                Spacer()
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                    if alertMessage == "Account created successfully!" {
                        // Delay the navigation to ProfileView until the alert is dismissed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isLoggedIn = true  // Navigate to the profile view
                        }
                    }
                }))
            }
            .padding()
        }
    }

    func createUser() {
        // Validate input fields
        if name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        // Create user in Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = "Sign up failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                guard let user = authResult?.user else { return }
                // Save additional user data to Firestore
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "name": name,
                    "surname": surname,
                    "email": email,
                    "uid": user.uid
                ]) { error in
                    if let error = error {
                        alertMessage = "Failed to save user data: \(error.localizedDescription)"
                    } else {
                        alertMessage = "Account created successfully!"
                    }
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
