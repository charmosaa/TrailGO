//
//  ProfileView.swift
//  TrailGoApp
//
//  Created by stud on 17/12/2024.
//


import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color(hex: "#108932"))
                    .padding(.top, 20)
                
                
                Text("Jan Kowalski")
                    .font(.title2)
                    .fontWeight(.semibold)
                Divider()
                
                VStack(spacing: 20) {
                    
                    HStack {
                        VStack {
                            Text("To do: 4")
                                .font(.title3)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("✓ Completed: 6")
                                .font(.title3)
                               
                        }
                    }
                    .padding(.horizontal)
                    
                    // Total Metrics
                    VStack(spacing: 20) {
                        Text("Total: 2134km")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        HStack(spacing: 30) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: 54 123 m")
                                    .font(.subheadline)
                            }
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color(hex: "#108932"))
                                Text("Total: 100 days 16h")
                                    .font(.subheadline)
                            }
                        }
                    }
                    Divider()
                }
                .padding()
                
            
                VStack(spacing: 16) {
                    NavigationLink(destination: TrailsListView()) {
                        Text("Plan your next adventure ")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#108932"))
                            .underline()
                    }
                }
                .padding()
                Spacer()
            }
            
            
        }
    }
}


// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
