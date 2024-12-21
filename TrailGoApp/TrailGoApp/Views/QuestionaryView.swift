//
//  QuestionaryView.swift
//  TrailGoApp
//
//  Created by Martyna Lopianiak on 21/12/2024.
//

//
//  LogInView.swift
//  TrailGoApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI

struct QuestionaryView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Login to see your statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top,40)
                    
                
                Rectangle()
                    .foregroundColor(Color(hex: "#108932"))
                    .frame(height: 10)
                    .cornerRadius(20)
                    .padding(.bottom,40)
                    .padding(.horizontal, 60)
                
                
                
                // Username TextField
                VStack(alignment: .leading){
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } .padding(.horizontal,40)
               
                
                // Password TextField
                VStack(alignment: .leading){
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } .padding(.horizontal,40)
                .padding(.top, 30)
                
                // Login Button
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
                        .padding(.top,20)
                        .padding(.horizontal,40)
                }
                HStack{
                    Text("New here? ")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#7A7A7A"))
                    NavigationLink(destination: CreateAccountView()) {
                                           Text("Sign Up")
                                               .fontWeight(.bold)
                                               .foregroundColor(Color(hex: "#108932"))
                                       }
                } .padding(.horizontal,40)
                .padding(.top, 30)
                
                
                Spacer()
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
        }
    }
    
    func loginUser() {
        // Validate user input
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please enter both username and password."
            showAlert = true
            return
        }
        
        
        if email == "user" && password == "password" {
            isLoggedIn = true
            alertMessage = "Login successful!"
            showAlert = true
        } else {
            alertMessage = "Invalid username or password."
            showAlert = true
        }
    }
}

#Preview {
    QuestionaryView()
}
