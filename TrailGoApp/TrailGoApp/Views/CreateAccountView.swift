//
//  CreateAccountView.swift
//  TrailGoApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
               
                VStack(alignment: .leading){
                    Text("Name")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } .padding(.horizontal,40)
                
                VStack(alignment: .leading){
                    Text("Surename")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } .padding(.horizontal,40)
                
                VStack(alignment: .leading){
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } .padding(.horizontal,40)
               
                
                
                VStack(alignment: .leading){
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#108932"))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } .padding(.horizontal,40)
                
                // Login Button
                Button(action: {
                    loginUser()
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color(hex: "#108932"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top,20)
                        .padding(.horizontal,40)
                }
                HStack{
                    Text("By clicking the button yu accept")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#7A7A7A"))
                    NavigationLink(destination: CreateAccountView()) {
                                           Text("Privacy Policy")
                                               .fontWeight(.bold)
                                               .foregroundColor(Color(hex: "#108932"))
                                       }
                } .padding(.horizontal,40)
                    .padding(.top,10)
                
                
                Spacer()
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Up Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
    CreateAccountView()
}
